Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3688 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab2KZUXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 15:23:30 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>
Subject: [PATCH V2 v3.7] brcmsmac: handle packet drop on enqueuing
 correctly
Date: Mon, 26 Nov 2012 21:23:16 +0100
Message-ID: <1353961396-7061-1-git-send-email-arend@broadcom.com> (sfid-20121126_212333_814509_A05E9E24)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

In the event that tx packet can not be queued by the driver
the packet is dropped. Propagate that information to the .tx()
callback to make sure the freed packet is not accessed after
that.

This has happened causing slab corruptions as reported by
Stanislaw Gruszka.

Bug #47721: https://bugzilla.kernel.org/show_bug.cgi?id=47721

Reported-by: Stanislaw Gruszka <stf_xl@wp.pl>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    4 ++--
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |   14 +++++++++-----
 drivers/net/wireless/brcm80211/brcmsmac/main.h        |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h         |    2 +-
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index a744ea5..5590499 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -280,8 +280,8 @@ static void brcms_ops_tx(struct ieee80211_hw *hw,
 		kfree_skb(skb);
 		goto done;
 	}
-	brcms_c_sendpkt_mac80211(wl->wlc, skb, hw);
-	tx_info->rate_driver_data[0] = control->sta;
+	if (brcms_c_sendpkt_mac80211(wl->wlc, skb, hw))
+		tx_info->rate_driver_data[0] = control->sta;
  done:
 	spin_unlock_bh(&wl->lock);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 75086b3..9fb0a4c9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -6095,7 +6095,7 @@ static bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
 	return brcms_c_prec_enq_head(wlc, q, pkt, prec, false);
 }
 
-void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
+bool brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 		     struct sk_buff *sdu, uint prec)
 {
 	struct brcms_txq_info *qi = wlc->pkt_queue;	/* Check me */
@@ -6110,7 +6110,9 @@ void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 		 * packet flooding from mac80211 stack
 		 */
 		brcmu_pkt_buf_free_skb(sdu);
+		return false;
 	}
+	return true;
 }
 
 /*
@@ -7273,7 +7275,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	return 0;
 }
 
-void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
+bool brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 			      struct ieee80211_hw *hw)
 {
 	u8 prio;
@@ -7288,10 +7290,12 @@ void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
 		MAXPRIO;
 	fifo = prio2fifo[prio];
-	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0))
-		return;
-	brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio));
+	brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0);
+	if (!brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio)))
+		return false;
 	brcms_c_send_q(wlc);
+
+	return true;
 }
 
 void brcms_c_send_q(struct brcms_c_info *wlc)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 8debc74..b44725c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -642,7 +642,7 @@ extern void brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
 			   bool commit, s8 txpktpend);
 extern void brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo,
 				    s8 txpktpend);
-extern void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
+extern bool brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 			    struct sk_buff *sdu, uint prec);
 extern void brcms_c_print_txstatus(struct tx_status *txs);
 extern int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 5855f4f..bfa2630 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -321,7 +321,7 @@ extern void brcms_c_intrsrestore(struct brcms_c_info *wlc, u32 macintmask);
 extern bool brcms_c_intrsupd(struct brcms_c_info *wlc);
 extern bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc);
 extern bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded);
-extern void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc,
+extern bool brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc,
 				     struct sk_buff *sdu,
 				     struct ieee80211_hw *hw);
 extern bool brcms_c_aggregatable(struct brcms_c_info *wlc, u8 tid);
-- 
1.7.10.4


