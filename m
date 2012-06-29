Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:59951 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552Ab2F2M4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 08:56:50 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de,
	brcm80211-dev-list@broadcom.com, pieterpg@broadcom.com,
	gregkh@suse.de, frankyl@broadcom.com, arend@broadcom.com,
	rvossen@broadcom.com, brudley@broadcom.com, linville@tuxdriver.com
Subject: [PATCH v2] brcmsmac: restructure info->control.sta handling as it is goning to be removed soon.
Date: Fri, 29 Jun 2012 05:56:03 -0700
Message-Id: <1340974563-77085-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120629_145655_517679_6EED29D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmsmac uses info->control.sta while doing ampdu aggregation. This patch
changes the usage of the structure info->control.sta, as it is going to be
removed soon from struct ieee80211_tx_info. This patch is a pre-requisit in
order to add transmission power control (TPC) to the mac80211 subsystem.

Suggested-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
Change sequence of overwriting data. Thx to Johannes.
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c       |   10 +++++-----
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    2 ++
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 01b190a..d341c91 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -665,7 +665,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 			u8 plcp0, plcp3, is40, sgi;
 			struct ieee80211_sta *sta;
 
-			sta = tx_info->control.sta;
+			sta = tx_info->rate_driver_data[0];
 
 			if (rr) {
 				plcp0 = plcp[0];
@@ -1195,8 +1195,8 @@ static bool cb_del_ampdu_pkt(struct sk_buff *mpdu, void *arg_a)
 	bool rc;
 
 	rc = tx_info->flags & IEEE80211_TX_CTL_AMPDU ? true : false;
-	rc = rc && (tx_info->control.sta == NULL || ampdu_pars->sta == NULL ||
-		    tx_info->control.sta == ampdu_pars->sta);
+	rc = rc && (tx_info->rate_driver_data[0] == NULL || ampdu_pars->sta == NULL ||
+		    tx_info->rate_driver_data[0] == ampdu_pars->sta);
 	rc = rc && ((u8)(mpdu->priority) == ampdu_pars->tid);
 	return rc;
 }
@@ -1210,8 +1210,8 @@ static void dma_cb_fn_ampdu(void *txi, void *arg_a)
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
1.7.10.4

