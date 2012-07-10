Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:41466 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611Ab2GJMBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 08:01:41 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de, brcm80211-dev-list@broadcom.com,
	pieterpg@broadcom.com, gregkh@suse.de, frankyl@broadcom.com,
	arend@broadcom.com, rvossen@broadcom.com, brudley@broadcom.com
Subject: [PATCH v4] brcmsmac: restructure info->control.sta handling as it is goning to be removed soon.
Date: Tue, 10 Jul 2012 14:01:37 +0200
Message-Id: <1341921697-62091-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120710_140153_376859_295E0B4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmsmac uses info->control.sta while doing ampdu aggregation. This patch
changes the usage of the structure info->control.sta, as it is going to be
removed soon from struct ieee80211_tx_info. This patch is a pre-requisit in
order to add transmission power control (TPC) to the mac80211 subsystem.

Suggested-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
sta pointer is not used in brcms_c_sendampdu(), sta removed. thx to A.v.Spriel
remove sta declaration from ampdu.c as well. thx to A.v.Spriel
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c       | 11 ++++-------
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |  2 ++
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |  2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 01b190a..be5bcfb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -663,9 +663,6 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		/* patch the first MPDU */
 		if (count == 1) {
 			u8 plcp0, plcp3, is40, sgi;
-			struct ieee80211_sta *sta;
-
-			sta = tx_info->control.sta;
 
 			if (rr) {
 				plcp0 = plcp[0];
@@ -1195,8 +1192,8 @@ static bool cb_del_ampdu_pkt(struct sk_buff *mpdu, void *arg_a)
 	bool rc;
 
 	rc = tx_info->flags & IEEE80211_TX_CTL_AMPDU ? true : false;
-	rc = rc && (tx_info->control.sta == NULL || ampdu_pars->sta == NULL ||
-		    tx_info->control.sta == ampdu_pars->sta);
+	rc = rc && (tx_info->rate_driver_data[0] == NULL || ampdu_pars->sta == NULL ||
+		    tx_info->rate_driver_data[0] == ampdu_pars->sta);
 	rc = rc && ((u8)(mpdu->priority) == ampdu_pars->tid);
 	return rc;
 }
@@ -1210,8 +1207,8 @@ static void dma_cb_fn_ampdu(void *txi, void *arg_a)
 	struct ieee80211_tx_info *tx_info = (struct ieee80211_tx_info *)txi;
 
 	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
-	    (tx_info->control.sta == sta || sta == NULL))
-		tx_info->control.sta = NULL;
+	    (tx_info->rate_driver_data[0] == sta || sta == NULL))
+		tx_info->rate_driver_data[0] = NULL;
 }
 
 /*
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 2d5a404..f3ab8a6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -267,6 +267,7 @@ static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
 static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct brcms_info *wl = hw->priv;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 
 	spin_lock_bh(&wl->lock);
 	if (!wl->pub->up) {
@@ -275,6 +276,7 @@ static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		goto done;
 	}
 	brcms_c_sendpkt_mac80211(wl->wlc, skb, hw);
+	tx_info->rate_driver_data[0] = tx_info->control.sta;
  done:
 	spin_unlock_bh(&wl->lock);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 8776fbc..28dd37e3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -879,7 +879,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	tx_info = IEEE80211_SKB_CB(p);
 	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
 
-	if (tx_info->control.sta)
+	if (tx_info->rate_driver_data[0])
 		scb = &wlc->pri_scb;
 
 	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-- 
1.7.11.1

