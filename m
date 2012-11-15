Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767935Ab2KOOIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:19 -0500
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
Subject: [PATCH v2 02/22] brcmsmac: Don't weight AMPDU packets in txfifo
Date: Thu, 15 Nov 2012 08:07:52 -0600
Message-Id: <1352988492-21340-3-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150840_096635_59C78433)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the comments this "reduces rate lag," but in reality the
only way this value is used is for determining whether or not any frames
remain to be transmitted. Therefore there's no reason for AMPDU packets
to receive any weighting.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |   12 +++---------
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |   19 +++++++++----------
 drivers/net/wireless/brcm80211/brcmsmac/main.h  |    6 ++----
 3 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 5739534..ea84087 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -40,8 +40,6 @@
 #define AMPDU_DEF_RETRY_LIMIT		5
 /* default tx retry limit at reg rate */
 #define AMPDU_DEF_RR_RETRY_LIMIT	2
-/* default weight of ampdu in txfifo */
-#define AMPDU_DEF_TXPKT_WEIGHT		2
 /* default ffpld reserved bytes */
 #define AMPDU_DEF_FFPLD_RSVD		2048
 /* # of inis to be freed on detach */
@@ -114,7 +112,6 @@ struct brcms_fifo_info {
  * mpdu_density: min mpdu spacing (0-7) ==> 2^(x-1)/8 usec
  * max_pdu: max pdus allowed in ampdu
  * dur: max duration of an ampdu (in msec)
- * txpkt_weight: weight of ampdu in txfifo; reduces rate lag
  * rx_factor: maximum rx ampdu factor (0-3) ==> 2^(13+x) bytes
  * ffpld_rsvd: number of bytes to reserve for preload
  * max_txlen: max size of ampdu per mcs, bw and sgi
@@ -136,7 +133,6 @@ struct ampdu_info {
 	u8 mpdu_density;
 	s8 max_pdu;
 	u8 dur;
-	u8 txpkt_weight;
 	u8 rx_factor;
 	u32 ffpld_rsvd;
 	u32 max_txlen[MCS_TABLE_SIZE][2][2];
@@ -247,7 +243,6 @@ struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc)
 	ampdu->mpdu_density = AMPDU_DEF_MPDU_DENSITY;
 	ampdu->max_pdu = AUTO;
 	ampdu->dur = AMPDU_MAX_DUR;
-	ampdu->txpkt_weight = AMPDU_DEF_TXPKT_WEIGHT;
 
 	ampdu->ffpld_rsvd = AMPDU_DEF_FFPLD_RSVD;
 	/*
@@ -942,8 +937,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 
 		while ((p = skb_dequeue(&session.skb_list)) != NULL)
 			brcms_c_txfifo(wlc, fifo, p,
-				       skb_queue_empty(&session.skb_list),
-				       ampdu->txpkt_weight);
+				       skb_queue_empty(&session.skb_list));
 	}
 	/* endif (count) */
 	return err;
@@ -1162,7 +1156,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	/* update rate state */
 	antselid = brcms_c_antsel_antsel2id(wlc->asi, mimoantsel);
 
-	brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
+	brcms_c_txfifo_complete(wlc, queue);
 }
 
 void
@@ -1219,7 +1213,7 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 			p = dma_getnexttxp(wlc->hw->di[queue],
 					   DMA_RANGE_TRANSMITTED);
 		}
-		brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
+		brcms_c_txfifo_complete(wlc, queue);
 	}
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 75086b3..e4ef457 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -982,7 +982,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	totlen = p->len;
 	free_pdu = true;
 
-	brcms_c_txfifo_complete(wlc, queue, 1);
+	brcms_c_txfifo_complete(wlc, queue);
 
 	if (lastframe) {
 		/* remove PLCP & Broadcom tx descriptor header */
@@ -7319,8 +7319,7 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 			err = brcms_c_prep_pdu(wlc, pkt[0], &fifo);
 			if (!err) {
 				for (i = 0; i < count; i++)
-					brcms_c_txfifo(wlc, fifo, pkt[i], true,
-						       1);
+					brcms_c_txfifo(wlc, fifo, pkt[i], true);
 			}
 		}
 
@@ -7340,7 +7339,7 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 
 void
 brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
-	       bool commit, s8 txpktpend)
+	       bool commit)
 {
 	u16 frameid = INVALIDFID;
 	struct d11txh *txh;
@@ -7358,9 +7357,9 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	 * used, this will be handled in brcms_b_txfifo()
 	 */
 	if (commit) {
-		wlc->core->txpktpend[fifo] += txpktpend;
-		BCMMSG(wlc->wiphy, "pktpend inc %d to %d\n",
-			 txpktpend, wlc->core->txpktpend[fifo]);
+		wlc->core->txpktpend[fifo] += 1;
+		BCMMSG(wlc->wiphy, "pktpend inc 1 to %d\n",
+			 wlc->core->txpktpend[fifo]);
 	}
 
 	/* Commit BCMC sequence number in the SHM frame ID location */
@@ -7424,10 +7423,10 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 }
 
 void
-brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo, s8 txpktpend)
+brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo)
 {
-	wlc->core->txpktpend[fifo] -= txpktpend;
-	BCMMSG(wlc->wiphy, "pktpend dec %d to %d\n", txpktpend,
+	wlc->core->txpktpend[fifo] -= 1;
+	BCMMSG(wlc->wiphy, "pktpend dec 1 to %d\n",
 	       wlc->core->txpktpend[fifo]);
 
 	/* There is more room; mark precedences related to this FIFO sendable */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 8debc74..0ab7d36 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -638,10 +638,8 @@ struct brcms_bss_cfg {
 };
 
 extern void brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
-			   struct sk_buff *p,
-			   bool commit, s8 txpktpend);
-extern void brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo,
-				    s8 txpktpend);
+			   struct sk_buff *p, bool commit);
+extern void brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo);
 extern void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 			    struct sk_buff *sdu, uint prec);
 extern void brcms_c_print_txstatus(struct tx_status *txs);
-- 
1.7.9.5

