Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55643 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3CXAsl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 20:48:41 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 15/15] brcmsmac: add support for adhoc mode
Date: Sun, 24 Mar 2013 01:46:03 +0100
Message-Id: <1364085963-25940-16-git-send-email-hauke@hauke-m.de> (sfid-20130324_014844_137680_337581C6)
In-Reply-To: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds adhoc mode support to brcmsmac.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |   12 ++++++++----
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |   11 +++++++++++
 drivers/net/wireless/brcm80211/brcmsmac/pub.h         |    1 +
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 445de66..0b3f8d9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -357,11 +357,12 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct brcms_info *wl = hw->priv;
 
-	/* Just STA and AP for now */
+	/* Just STA, AP and ADHOC for now */
 	if (vif->type != NL80211_IFTYPE_STATION &&
-	    vif->type != NL80211_IFTYPE_AP) {
+	    vif->type != NL80211_IFTYPE_AP &&
+	    vif->type != NL80211_IFTYPE_ADHOC) {
 		brcms_err(wl->wlc->hw->d11core,
-			  "%s: Attempt to add type %d, only STA and AP for now\n",
+			  "%s: Attempt to add type %d, only STA, AP and AdHoc for now\n",
 			  __func__, vif->type);
 		return -EOPNOTSUPP;
 	}
@@ -374,6 +375,8 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	else if (vif->type == NL80211_IFTYPE_AP)
 		brcms_c_start_ap(wl->wlc, vif->addr, vif->bss_conf.bssid,
 				 vif->bss_conf.ssid, vif->bss_conf.ssid_len);
+	else if (vif->type == NL80211_IFTYPE_ADHOC)
+		brcms_c_start_adhoc(wl->wlc, vif->addr);
 	spin_unlock_bh(&wl->lock);
 
 	return 0;
@@ -1056,7 +1059,8 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	/* channel change time is dependent on chip and band  */
 	hw->channel_change_time = 7 * 1000;
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-				     BIT(NL80211_IFTYPE_AP);
+				     BIT(NL80211_IFTYPE_AP) |
+				     BIT(NL80211_IFTYPE_ADHOC);
 
 	/*
 	 * deactivate sending probe responses by ucude, because this will
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 7825202..59d4384 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2186,6 +2186,14 @@ void brcms_c_start_ap(struct brcms_c_info *wlc, u8 *addr, const u8 *bssid,
 	brcms_b_mctrl(wlc->hw, MCTL_AP | MCTL_INFRA, MCTL_AP | MCTL_INFRA);
 }
 
+void brcms_c_start_adhoc(struct brcms_c_info *wlc, u8 *addr)
+{
+	memcpy(wlc->pub->cur_etheraddr, addr, sizeof(wlc->pub->cur_etheraddr));
+	wlc->bsscfg->type = BRCMS_TYPE_ADHOC;
+
+	brcms_b_mctrl(wlc->hw, MCTL_AP | MCTL_INFRA, 0);
+}
+
 /* Initialize GPIOs that are controlled by D11 core */
 static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 {
@@ -3077,6 +3085,9 @@ static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 	if (wlc->bsscfg->type == BRCMS_TYPE_AP)
 		return false;
 
+	if (wlc->bsscfg->type == BRCMS_TYPE_ADHOC)
+		return false;
+
 	return true;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index e3bdccf..d36ea5e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -334,6 +334,7 @@ extern bool brcms_c_tx_flush_completed(struct brcms_c_info *wlc);
 extern void brcms_c_start_station(struct brcms_c_info *wlc, u8 *addr);
 extern void brcms_c_start_ap(struct brcms_c_info *wlc, u8 *addr,
 			     const u8 *bssid, u8 *ssid, size_t ssid_len);
+extern void brcms_c_start_adhoc(struct brcms_c_info *wlc, u8 *addr);
 extern void brcms_c_update_beacon(struct brcms_c_info *wlc);
 extern void brcms_c_set_new_beacon(struct brcms_c_info *wlc,
 				   struct sk_buff *beacon, u16 tim_offset,
-- 
1.7.10.4

