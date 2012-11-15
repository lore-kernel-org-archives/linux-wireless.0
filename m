Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58871 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767933Ab2KOOIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:25 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 05/22] brcmsmac: Use IEEE 802.11 AC levels for pktq precedence levels
Date: Thu, 15 Nov 2012 08:07:55 -0600
Message-Id: <1352988492-21340-6-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150839_139375_7E6BFC4C)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211 tx queues and brcmsmac DMA fifos both map directly to AC
levels. Therefore it's much more straightforward to queue tx frames and
choose the tx fifo based on the mac80211 queue instead of mapping 802.1D
priority tags to precedence levels then back to AC levels. mac80211
already maps the 802.1D levels to the appropriate AC levels and queues
management frames at the maximum priority, so the results should be
identical.

One functional change resulting from this patch is that AMPDU retries no
longer get a priority boost to queue them ahead of packets with the same
priority already in the tx queue. This behavior will be restored (in
effect at least) in a later patch when the tx queue is removed.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |   13 +----
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |   67 ++++++++---------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h  |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h   |   26 +--------
 4 files changed, 26 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index ea84087..0b4a490 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -827,7 +827,6 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 	struct scb *scb;
 	struct scb_ampdu *scb_ampdu;
 	struct scb_ampdu_tid_ini *ini;
-	struct brcms_fifo_info *f;
 	struct ieee80211_tx_info *tx_info;
 	u16 qlen;
 	struct wiphy *wiphy;
@@ -838,8 +837,6 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 
 	tid = (u8) (p->priority);
 
-	f = ampdu->fifo_tb + prio2fifo[tid];
-
 	scb = &wlc->pri_scb;
 	scb_ampdu = &scb->scb_ampdu;
 	ini = &scb_ampdu->ini[tid];
@@ -1048,8 +1045,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				 * if there were underflows, but pre-loading
 				 * is not active, notify rate adaptation.
 				 */
-				if (brcms_c_ffpld_check_txfunfl(wlc,
-					prio2fifo[tid]) > 0)
+				if (brcms_c_ffpld_check_txfunfl(wlc, queue) > 0)
 					tx_error = true;
 			}
 		} else if (txs->phyerr) {
@@ -1119,12 +1115,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			if (retry && (ini->txretry[index] < (int)retry_limit)) {
 				ini->txretry[index]++;
 				ini->tx_in_transit--;
-				/*
-				 * Use high prededence for retransmit to
-				 * give some punch
-				 */
-				brcms_c_txq_enq(wlc, scb, p,
-						BRCMS_PRIO_TO_HI_PREC(tid));
+				brcms_c_txq_enq(wlc, scb, p);
 			} else {
 				/* Retry timeout */
 				ini->tx_in_transit--;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 135af9a..8abf39d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -277,17 +277,6 @@ struct edcf_acparam {
 	u16 TXOP;
 } __packed;
 
-const u8 prio2fifo[NUMPRIO] = {
-	TX_AC_BE_FIFO,		/* 0    BE      AC_BE   Best Effort */
-	TX_AC_BK_FIFO,		/* 1    BK      AC_BK   Background */
-	TX_AC_BK_FIFO,		/* 2    --      AC_BK   Background */
-	TX_AC_BE_FIFO,		/* 3    EE      AC_BE   Best Effort */
-	TX_AC_VI_FIFO,		/* 4    CL      AC_VI   Video */
-	TX_AC_VI_FIFO,		/* 5    VI      AC_VI   Video */
-	TX_AC_VO_FIFO,		/* 6    VO      AC_VO   Voice */
-	TX_AC_VO_FIFO		/* 7    NC      AC_VO   Voice */
-};
-
 /* debug/trace */
 uint brcm_msg_level =
 #if defined(DEBUG)
@@ -314,18 +303,6 @@ static const u8 wme_ac2fifo[] = {
 	TX_AC_BK_FIFO
 };
 
-/* 802.1D Priority to precedence queue mapping */
-const u8 wlc_prio2prec_map[] = {
-	_BRCMS_PREC_BE,		/* 0 BE - Best-effort */
-	_BRCMS_PREC_BK,		/* 1 BK - Background */
-	_BRCMS_PREC_NONE,		/* 2 None = - */
-	_BRCMS_PREC_EE,		/* 3 EE - Excellent-effort */
-	_BRCMS_PREC_CL,		/* 4 CL - Controlled Load */
-	_BRCMS_PREC_VI,		/* 5 Vi - Video */
-	_BRCMS_PREC_VO,		/* 6 Vo - Voice */
-	_BRCMS_PREC_NC,		/* 7 NC - Network Control */
-};
-
 static const u16 xmtfifo_sz[][NFIFO] = {
 	/* corerev 17: 5120, 49152, 49152, 5376, 4352, 1280 */
 	{20, 192, 192, 21, 17, 5},
@@ -365,6 +342,21 @@ static const char fifo_names[6][0];
 static struct brcms_c_info *wlc_info_dbg = (struct brcms_c_info *) (NULL);
 #endif
 
+/* Mapping of ieee80211 AC numbers to tx fifos */
+static const u8 ac_to_fifo_mapping[IEEE80211_NUM_ACS] = {
+	[IEEE80211_AC_VO]	= TX_AC_VO_FIFO,
+	[IEEE80211_AC_VI]	= TX_AC_VI_FIFO,
+	[IEEE80211_AC_BE]	= TX_AC_BE_FIFO,
+	[IEEE80211_AC_BK]	= TX_AC_BK_FIFO,
+};
+
+static u8 brcms_ac_to_fifo(u8 ac)
+{
+	if (ac >= ARRAY_SIZE(ac_to_fifo_mapping))
+		return TX_AC_BE_FIFO;
+	return ac_to_fifo_mapping[ac];
+}
+
 /* Find basic rate for a given rate */
 static u8 brcms_basic_rate(struct brcms_c_info *wlc, u32 rspec)
 {
@@ -3753,12 +3745,6 @@ brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
 static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc)
 {
 	wlc->tx_prec_map = BRCMS_PREC_BMP_ALL;
-	memset(wlc->fifo2prec_map, 0, NFIFO * sizeof(u16));
-
-	wlc->fifo2prec_map[TX_AC_BK_FIFO] = BRCMS_PREC_BMP_AC_BK;
-	wlc->fifo2prec_map[TX_AC_BE_FIFO] = BRCMS_PREC_BMP_AC_BE;
-	wlc->fifo2prec_map[TX_AC_VI_FIFO] = BRCMS_PREC_BMP_AC_VI;
-	wlc->fifo2prec_map[TX_AC_VO_FIFO] = BRCMS_PREC_BMP_AC_VO;
 }
 
 /* push sw hps and wake state through hardware */
@@ -6068,14 +6054,13 @@ static bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
 }
 
 void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
-		     struct sk_buff *sdu, uint prec)
+		     struct sk_buff *sdu)
 {
 	struct brcms_txq_info *qi = wlc->pkt_queue;	/* Check me */
 	struct pktq *q = &qi->q;
-	int prio;
-
-	prio = sdu->priority;
+	uint prec;
 
+	prec = brcms_ac_to_fifo(skb_get_queue_mapping(sdu));
 	if (!brcms_c_prec_enq(wlc, q, sdu, prec)) {
 		/*
 		 * we might hit this condtion in case
@@ -7248,21 +7233,13 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 			      struct ieee80211_hw *hw)
 {
-	u8 prio;
 	uint fifo;
 	struct scb *scb = &wlc->pri_scb;
-	struct ieee80211_hdr *d11_header = (struct ieee80211_hdr *)(sdu->data);
 
-	/*
-	 * 802.11 standard requires management traffic
-	 * to go at highest priority
-	 */
-	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
-		MAXPRIO;
-	fifo = prio2fifo[prio];
+	fifo = brcms_ac_to_fifo(skb_get_queue_mapping(sdu));
 	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0))
 		return;
-	brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio));
+	brcms_c_txq_enq(wlc, scb, sdu);
 	brcms_c_send_q(wlc);
 }
 
@@ -7402,7 +7379,7 @@ brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo)
 	       wlc->core->txpktpend[fifo]);
 
 	/* There is more room; mark precedences related to this FIFO sendable */
-	wlc->tx_prec_map |= wlc->fifo2prec_map[fifo];
+	wlc->tx_prec_map |= 1 << fifo;
 
 	/* figure out which bsscfg is being worked on... */
 }
@@ -7877,7 +7854,7 @@ int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
 	if (*wlc->core->txavail[fifo] < MAX_DMA_SEGS) {
 		/* Mark precedences related to this FIFO, unsendable */
 		/* A fifo is full. Clear precedences related to that FIFO */
-		wlc->tx_prec_map &= ~(wlc->fifo2prec_map[fifo]);
+		wlc->tx_prec_map &= ~(1 << fifo);
 		return -EBUSY;
 	}
 	return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 0ab7d36..4e3af67 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -101,9 +101,6 @@
 
 #define DATA_BLOCK_TX_SUPR	(1 << 4)
 
-/* 802.1D Priority to TX FIFO number for wme */
-extern const u8 prio2fifo[];
-
 /* Ucode MCTL_WAKE override bits */
 #define BRCMS_WAKE_OVERRIDE_CLKCTL	0x01
 #define BRCMS_WAKE_OVERRIDE_PHYREG	0x02
@@ -534,7 +531,6 @@ struct brcms_c_info {
 
 	u16 wme_retries[IEEE80211_NUM_ACS];
 	u16 tx_prec_map;
-	u16 fifo2prec_map[NFIFO];
 
 	struct brcms_bss_cfg *bsscfg;
 
@@ -641,7 +637,7 @@ extern void brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
 			   struct sk_buff *p, bool commit);
 extern void brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo);
 extern void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
-			    struct sk_buff *sdu, uint prec);
+			    struct sk_buff *sdu);
 extern void brcms_c_print_txstatus(struct tx_status *txs);
 extern int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 		   uint *blocks);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 5855f4f..40ccc69 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -200,13 +200,7 @@ enum wlc_par_id {
 /* WL11N Support */
 #define AMPDU_AGG_HOST	1
 
-/* pri is priority encoded in the packet. This maps the Packet priority to
- * enqueue precedence as defined in wlc_prec_map
- */
-extern const u8 wlc_prio2prec_map[];
-#define BRCMS_PRIO_TO_PREC(pri)	wlc_prio2prec_map[(pri) & 7]
-
-#define	BRCMS_PREC_COUNT	16	/* Max precedence level implemented */
+#define	BRCMS_PREC_COUNT	4	/* Max precedence level implemented */
 
 /* Mask to describe all precedence levels */
 #define BRCMS_PREC_BMP_ALL		MAXBITVAL(BRCMS_PREC_COUNT)
@@ -219,24 +213,6 @@ extern const u8 wlc_prio2prec_map[];
 #define BRCMS_PRIO_TO_HI_PREC(pri)	min(BRCMS_PRIO_TO_PREC(pri) + 1,\
 					    BRCMS_PREC_COUNT - 1)
 
-/* Define a bitmap of precedences comprised by each AC */
-#define BRCMS_PREC_BMP_AC_BE	(NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_BE)) | \
-			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_BE)) |	\
-			NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_EE)) |	\
-			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_EE)))
-#define BRCMS_PREC_BMP_AC_BK	(NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_BK)) | \
-			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_BK)) |	\
-			NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_NONE)) |	\
-			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_NONE)))
-#define BRCMS_PREC_BMP_AC_VI	(NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_CL)) | \
-			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_CL)) |	\
-			NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_VI)) |	\
-			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_VI)))
-#define BRCMS_PREC_BMP_AC_VO	(NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_VO)) | \
-			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_VO)) |	\
-			NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_NC)) |	\
-			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_NC)))
-
 /* network protection config */
 #define	BRCMS_PROT_G_SPEC		1	/* SPEC g protection */
 #define	BRCMS_PROT_G_OVR		2	/* SPEC g prot override */
-- 
1.7.9.5

