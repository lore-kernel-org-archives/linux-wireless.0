Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2722 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab1HONeo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/15] staging: brcm80211: got rid of several void
 pointers in softmac
Date: Mon, 15 Aug 2011 15:34:16 +0200
Message-ID: <1313415267-5264-5-git-send-email-arend@broadcom.com> (sfid-20110815_153451_444233_480FDACB)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Replaced void pointers by less generic pointer types.

Reported-by: Julian Calaby <julian.calaby@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |   14 -------
 drivers/staging/brcm80211/brcmsmac/dma.c         |    1 -
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    4 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    4 +-
 drivers/staging/brcm80211/brcmsmac/main.c        |   45 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/main.h        |   23 ++---------
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    7 ++-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h    |    3 +-
 drivers/staging/brcm80211/brcmsmac/pub.h         |   16 +++----
 drivers/staging/brcm80211/brcmsmac/scb.h         |    1 -
 10 files changed, 44 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 3c0fa13..6fc1591 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -109,7 +109,6 @@ struct brcms_fifo_info {
  * rx_factor: maximum rx ampdu factor (0-3) ==> 2^(13+x) bytes
  * ffpld_rsvd: number of bytes to reserve for preload
  * max_txlen: max size of ampdu per mcs, bw and sgi
- * ini_free: array of ini's to be freed on detach
  * mfbr: enable multiple fallback rate
  * tx_max_funl: underflows should be kept such that
  *		(tx_max_funfl*underflows) < tx frames
@@ -132,7 +131,6 @@ struct ampdu_info {
 	u8 rx_factor;
 	u32 ffpld_rsvd;
 	u32 max_txlen[MCS_TABLE_SIZE][2][2];
-	void *ini_free[AMPDU_INI_FREE];
 	bool mfbr;
 	u32 tx_max_funl;
 	struct brcms_fifo_info fifo_tb[NUM_FFPLD_FIFO];
@@ -231,18 +229,6 @@ struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc)
 
 void brcms_c_ampdu_detach(struct ampdu_info *ampdu)
 {
-	int i;
-
-	if (!ampdu)
-		return;
-
-	/*
-	 * free all ini's which were to be freed on
-	 * callbacks which were never called
-	 */
-	for (i = 0; i < AMPDU_INI_FREE; i++)
-		kfree(ampdu->ini_free[i]);
-
 	kfree(ampdu);
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 3cb9e68..815329c 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -229,7 +229,6 @@ struct dma_seg {
 };
 
 struct dma_seg_map {
-	void *oshdmah;	/* Opaque handle for OSL to store its information */
 	uint origsize;	/* Size of the virtual packet */
 	uint nsegs;
 	struct dma_seg segs[MAX_DMA_SEGS];
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index a4d46dd..e465749 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -802,7 +802,7 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 	}
 
 	/* common load-time initialization */
-	wl->wlc = brcms_c_attach((void *)wl, vendor, device, unit, false,
+	wl->wlc = brcms_c_attach(wl, vendor, device, unit, false,
 				 wl->regsva, btparam, &err);
 	brcms_release_fw(wl);
 	if (!wl->wlc) {
@@ -1782,7 +1782,7 @@ static int brcms_request_fw(struct brcms_info *wl, struct pci_dev *pdev)
 	char fw_name[100];
 	int i;
 
-	memset((void *)&wl->fw, 0, sizeof(struct brcms_firmware));
+	memset(&wl->fw, 0, sizeof(struct brcms_firmware));
 	for (i = 0; i < MAX_FW_IMAGES; i++) {
 		if (brcms_firmwares[i] == NULL)
 			break;
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index c574723..fcd711a 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -51,8 +51,8 @@ struct brcms_firmware {
 };
 
 struct brcms_info {
-	struct brcms_pub *pub;	/* pointer to public wlc state */
-	void *wlc;		/* pointer to private common data */
+	struct brcms_pub *pub;		/* pointer to public wlc state */
+	struct brcms_c_info *wlc;	/* pointer to private common data */
 	u32 magic;
 
 	int irq;
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index c462377..d6837d3 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -367,9 +367,9 @@ static u32 brcms_c_wlintrsoff(struct brcms_c_info *wlc);
 static void brcms_c_wlintrsrestore(struct brcms_c_info *wlc, u32 macintmask);
 static void brcms_c_gpio_init(struct brcms_c_info *wlc);
 static void brcms_c_write_hw_bcntemplate0(struct brcms_hardware *wlc_hw,
-					  void *bcn, int len);
+					  u16 bcn[], int len);
 static void brcms_c_write_hw_bcntemplate1(struct brcms_hardware *wlc_hw,
-					  void *bcn, int len);
+					  u16 bcn[], int len);
 static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec);
 static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit);
 static void brcms_b_setband(struct brcms_hardware *wlc_hw, uint bandunit,
@@ -457,6 +457,8 @@ static uint brcms_c_down_del_timer(struct brcms_c_info *wlc);
 static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc);
 static int _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 		      struct brcms_c_if *wlcif);
+static void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, u16 bcn[],
+					  int len, bool both);
 
 const u8 prio2fifo[NUMPRIO] = {
 	TX_AC_BE_FIFO,		/* 0    BE      AC_BE   Best Effort */
@@ -1375,7 +1377,7 @@ void brcms_b_bw_set(struct brcms_hardware *wlc_hw, u16 bw)
 }
 
 static void
-brcms_c_write_hw_bcntemplate0(struct brcms_hardware *wlc_hw, void *bcn,
+brcms_c_write_hw_bcntemplate0(struct brcms_hardware *wlc_hw, u16 bcn[],
 			      int len)
 {
 	struct d11regs *regs = wlc_hw->regs;
@@ -1389,7 +1391,7 @@ brcms_c_write_hw_bcntemplate0(struct brcms_hardware *wlc_hw, void *bcn,
 }
 
 static void
-brcms_c_write_hw_bcntemplate1(struct brcms_hardware *wlc_hw, void *bcn,
+brcms_c_write_hw_bcntemplate1(struct brcms_hardware *wlc_hw, u16 bcn[],
 			      int len)
 {
 	struct d11regs *regs = wlc_hw->regs;
@@ -4287,9 +4289,9 @@ static uint brcms_c_attach_module(struct brcms_c_info *wlc)
 	return err;
 }
 
-struct brcms_pub *brcms_c_pub(void *wlc)
+struct brcms_pub *brcms_c_pub(struct brcms_c_info *wlc)
 {
-	return ((struct brcms_c_info *) wlc)->pub;
+	return wlc->pub;
 }
 
 #define CHIP_SUPPORTS_11N(wlc)	1
@@ -4644,7 +4646,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 /*
  * The common driver entry routine. Error codes should be unique
  */
-void *
+struct brcms_c_info *
 brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	       bool piomode, void *regsva, struct pci_dev *btparam, uint *perr)
 {
@@ -4884,7 +4886,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	if (perr)
 		*perr = 0;
 
-	return (void *)wlc;
+	return wlc;
 
  fail:
 	wiphy_err(wl->wiphy, "wl%d: %s: failed with err %d\n",
@@ -6319,7 +6321,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
  * register watchdog and down handlers.
  */
 int brcms_c_module_register(struct brcms_pub *pub,
-			    const char *name, void *hdl,
+			    const char *name, struct brcms_info *hdl,
 			    int (*d_fn)(void *handle))
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) pub->wlc;
@@ -6340,8 +6342,8 @@ int brcms_c_module_register(struct brcms_pub *pub,
 }
 
 /* unregister module callbacks */
-int
-brcms_c_module_unregister(struct brcms_pub *pub, const char *name, void *hdl)
+int brcms_c_module_unregister(struct brcms_pub *pub, const char *name,
+			      struct brcms_info *hdl)
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) pub->wlc;
 	int i;
@@ -6668,8 +6670,8 @@ static u16 brcms_c_rate_shm_offset(struct brcms_c_info *wlc, u8 rate)
  *
  * Returns true if packet consumed (queued), false if not.
  */
-bool
-brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q, void *pkt, int prec)
+bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
+		      struct sk_buff *pkt, int prec)
 {
 	return brcms_c_prec_enq_head(wlc, q, pkt, prec, false);
 }
@@ -6721,10 +6723,9 @@ brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
 	return true;
 }
 
-void brcms_c_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
-			     uint prec)
+void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
+		     struct sk_buff *sdu, uint prec)
 {
-	struct brcms_c_info *wlc = (struct brcms_c_info *) ctx;
 	struct brcms_txq_info *qi = wlc->pkt_queue;	/* Check me */
 	struct pktq *q = &qi->q;
 	int prio;
@@ -6767,7 +6768,6 @@ brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 {
 	u8 prio;
 	uint fifo;
-	void *pkt;
 	struct scb *scb = &global_scb;
 	struct ieee80211_hdr *d11_header = (struct ieee80211_hdr *)(sdu->data);
 
@@ -6778,12 +6778,11 @@ brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
 		MAXPRIO;
 	fifo = prio2fifo[prio];
-	pkt = sdu;
 	if (unlikely
 	    (brcms_c_d11hdrs_mac80211(
-		wlc, hw, pkt, scb, 0, 1, fifo, 0, NULL, 0)))
+		wlc, hw, sdu, scb, 0, 1, fifo, 0, NULL, 0)))
 		return -EINVAL;
-	brcms_c_txq_enq(wlc, scb, pkt, BRCMS_PRIO_TO_PREC(prio));
+	brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio));
 	brcms_c_send_q(wlc);
 	return 0;
 }
@@ -8969,7 +8968,7 @@ int brcms_c_get_header_len()
 
 /* mac is assumed to be suspended at this point */
 void
-brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, void *bcn,
+brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, u16 bcn[],
 			      int len, bool both)
 {
 	struct d11regs *regs = wlc_hw->regs;
@@ -9424,8 +9423,8 @@ void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset, int len,
 	brcms_b_write_template_ram(wlc->hw, offset, len, buf);
 }
 
-void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, void *bcn, int len,
-			       bool both)
+void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, u16 bcn[], int len,
+				   bool both)
 {
 	brcms_b_write_hw_bcntemplates(wlc->hw, bcn, len, both);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index e2febe0..433e6a9 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -461,7 +461,7 @@ struct modulecb {
 	/* iovar table */
 	const struct brcmu_iovar *iovars;
 	/* handle passed when handler 'doiovar' is called */
-	void *hdl;
+	struct brcms_info *hdl;
 
 	/* IOVar handler
 	 *
@@ -491,15 +491,6 @@ struct modulecb {
 
 };
 
-/* dump control blocks */
-struct dumpcb_s {
-	const char *name;	/* dump name */
-	/* 'wl dump' handler */
-	int (*dump_fn)(void *handle, struct brcmu_strbuf *b);
-	void *dump_fn_arg;
-	struct dumpcb_s *next;
-};
-
 struct edcf_acparam {
 	u8 ACI;
 	u8 ECW;
@@ -580,8 +571,8 @@ struct brcms_hardware {
 	char *vars;		/* "environment" name=value */
 	uint vars_size;		/* size of vars, free vars on detach */
 	struct d11regs *regs;	/* pointer to device registers */
-	void *physhim;		/* phy shim layer handler */
-	void *phy_sh;		/* pointer to shared phy state */
+	struct phy_shim_info *physhim; /* phy shim layer handler */
+	struct shared_phy *phy_sh;	/* pointer to shared phy state */
 	struct brcms_hw_band *band;/* pointer to active per-band state */
 	/* band state per phy/radio */
 	struct brcms_hw_band *bandstate[MAXBANDS];
@@ -1082,16 +1073,14 @@ extern void brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
 			   bool commit, s8 txpktpend);
 extern void brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo,
 				    s8 txpktpend);
-extern void brcms_c_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
-			    uint prec);
+extern void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
+			    struct sk_buff *sdu, uint prec);
 extern void brcms_c_info_init(struct brcms_c_info *wlc, int unit);
 extern void brcms_c_print_txstatus(struct tx_status *txs);
 extern int brcms_c_xmtfifo_sz_get(struct brcms_c_info *wlc, uint fifo,
 				  uint *blocks);
 extern void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset,
 				       int len, void *buf);
-extern void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, void *bcn,
-					  int len, bool both);
 extern void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, u32 req_bit);
 extern void brcms_c_reset_bmac_done(struct brcms_c_info *wlc);
 
@@ -1168,8 +1157,6 @@ extern void brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
 extern bool brcms_c_ismpc(struct brcms_c_info *wlc);
 extern bool brcms_c_is_non_delay_mpc(struct brcms_c_info *wlc);
 extern void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc);
-extern bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
-			     void *pkt, int prec);
 extern bool brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
 			      struct sk_buff *pkt, int prec, bool head);
 extern u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index ec88867..31c9374 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -31,12 +31,13 @@
 /* PHY SHIM module specific state */
 struct phy_shim_info {
 	struct brcms_hardware *wlc_hw;	/* pointer to main wlc_hw structure */
-	void *wlc;		/* pointer to main wlc structure */
-	void *wl;		/* pointer to os-specific private state */
+	struct brcms_c_info *wlc;	/* pointer to main wlc structure */
+	struct brcms_info *wl; /* pointer to os-specific private state */
 };
 
 struct phy_shim_info *wlc_phy_shim_attach(struct brcms_hardware *wlc_hw,
-						       void *wl, void *wlc) {
+					  struct brcms_info *wl,
+					  struct brcms_c_info *wlc) {
 	struct phy_shim_info *physhim = NULL;
 
 	physhim = kzalloc(sizeof(struct phy_shim_info), GFP_ATOMIC);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index 14c56f9..d88c820 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -125,7 +125,8 @@
 struct brcms_phy;
 
 extern struct phy_shim_info *wlc_phy_shim_attach(struct brcms_hardware *wlc_hw,
-						void *wl, void *wlc);
+						 struct brcms_info *wl,
+						 struct brcms_c_info *wlc);
 extern void wlc_phy_shim_detach(struct phy_shim_info *physhim);
 
 /* PHY to WL utility functions */
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 40efee6..c2ab1a3 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -228,8 +228,7 @@ struct brcms_bss_info {
  * The wlc handle points at this.
  */
 struct brcms_pub {
-	void *wlc;
-
+	struct brcms_c_info *wlc;
 	struct ieee80211_hw *ieee_hw;
 	struct scb *global_scb;
 	struct scb_ampdu *global_ampdu;
@@ -549,9 +548,9 @@ struct brcms_antselcfg {
 };
 
 /* common functions for every port */
-extern void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device,
-			uint unit, bool piomode, void *regsva,
-			struct pci_dev *btparam, uint *perr);
+struct brcms_c_info *
+brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
+	       bool piomode, void *regsva, struct pci_dev *btparam, uint *perr);
 extern uint brcms_c_detach(struct brcms_c_info *wlc);
 extern int brcms_c_up(struct brcms_c_info *wlc);
 extern uint brcms_c_down(struct brcms_c_info *wlc);
@@ -588,7 +587,7 @@ extern void brcms_c_set_addrmatch(struct brcms_c_info *wlc,
 extern void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 			      const struct ieee80211_tx_queue_params *arg,
 			      bool suspend);
-extern struct brcms_pub *brcms_c_pub(void *wlc);
+extern struct brcms_pub *brcms_c_pub(struct brcms_c_info *wlc);
 
 /* common functions for every port */
 extern void brcms_c_mhf(struct brcms_c_info *wlc, u8 idx, u16 mask, u16 val,
@@ -614,11 +613,10 @@ extern void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc);
 extern void brcms_c_mctrl(struct brcms_c_info *wlc, u32 mask, u32 val);
 
 extern int brcms_c_module_register(struct brcms_pub *pub,
-				   const char *name, void *hdl,
+				   const char *name, struct brcms_info *hdl,
 				   int (*down_fn)(void *handle));
-
 extern int brcms_c_module_unregister(struct brcms_pub *pub, const char *name,
-				 void *hdl);
+				     struct brcms_info *hdl);
 extern void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc);
 extern void brcms_c_enable_mac(struct brcms_c_info *wlc);
 extern void brcms_c_associate_upd(struct brcms_c_info *wlc, bool state);
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index 22ef8e8..efa5047 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -63,7 +63,6 @@ struct scb {
 	u32 flags2;	/* various bit flags2 as defined below */
 	u8 state;	/* current state bitfield of auth/assoc process */
 	u8 ea[ETH_ALEN];	/* station address */
-	void *fragbuf[NUMPRIO];	/* defragmentation buffer per prio */
 	uint fragresid[NUMPRIO];/* #bytes unused in frag buffer per prio */
 
 	u16 seqctl[NUMPRIO];	/* seqctl of last received frame (for dups) */
-- 
1.7.4.1


