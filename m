Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1670 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab2K1Uo1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:44:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/11] brcmsmac: handle packet drop during transmit
 correctly
Date: Wed, 28 Nov 2012 21:44:05 +0100
Message-ID: <1354135454-7035-3-git-send-email-arend@broadcom.com> (sfid-20121128_214432_468910_FAB27B8C)
In-Reply-To: <1354135454-7035-1-git-send-email-arend@broadcom.com>
References: <1354135454-7035-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

The .tx() callback function can drop packets when there is no
space in the DMA fifo. Propagate that information to caller
and make sure the freed sk_buff reference is not accessed.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    4 ++--
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |   13 ++++++++-----
 drivers/net/wireless/brcm80211/brcmsmac/pub.h         |    2 +-
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 1710ccb..f917d62 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -285,8 +285,8 @@ static void brcms_ops_tx(struct ieee80211_hw *hw,
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
index 2a44593..54ab2f7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -6928,17 +6928,20 @@ static int brcms_c_tx(struct brcms_c_info *wlc, struct sk_buff *skb)
 	return ret;
 }
 
-void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
+bool brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 			      struct ieee80211_hw *hw)
 {
 	uint fifo;
 	struct scb *scb = &wlc->pri_scb;
 
 	fifo = brcms_ac_to_fifo(skb_get_queue_mapping(sdu));
-	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0))
-		return;
-	if (brcms_c_tx(wlc, sdu))
-		dev_kfree_skb_any(sdu);
+	brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0);
+	if (!brcms_c_tx(wlc, sdu))
+		return true;
+
+	/* packet discarded */
+	dev_kfree_skb_any(sdu);
+	return false;
 }
 
 int
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 0148dec..0d7af34 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -284,7 +284,7 @@ extern void brcms_c_intrsrestore(struct brcms_c_info *wlc, u32 macintmask);
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


