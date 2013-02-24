Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53996 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759450Ab3BXBHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 20:07:17 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 13/13] brcmsmac: activate AP support
Date: Sun, 24 Feb 2013 02:06:11 +0100
Message-Id: <1361667972-22909-14-git-send-email-hauke@hauke-m.de> (sfid-20130224_020725_850420_4AF84F8E)
In-Reply-To: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This activates the AP mode support.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    9 +++++++--
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |   15 +++++++++++++++
 drivers/net/wireless/brcm80211/brcmsmac/pub.h         |    2 ++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 1348d73..17880e8 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -357,7 +357,8 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct brcms_info *wl = hw->priv;
 
 	/* Just STA for now */
-	if (vif->type != NL80211_IFTYPE_STATION) {
+	if (vif->type != NL80211_IFTYPE_STATION &&
+	    vif->type != NL80211_IFTYPE_AP) {
 		brcms_err(wl->wlc->hw->d11core,
 			  "%s: Attempt to add type %d, only STA for now\n",
 			  __func__, vif->type);
@@ -369,6 +370,9 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	brcms_c_mute(wl->wlc, false);
 	if (vif->type == NL80211_IFTYPE_STATION)
 		brcms_c_start_station(wl->wlc, vif->addr);
+	else if (vif->type == NL80211_IFTYPE_AP)
+		brcms_c_start_ap(wl->wlc, vif->addr, vif->bss_conf.bssid,
+				 vif->bss_conf.ssid, vif->bss_conf.ssid_len);
 	spin_unlock_bh(&wl->lock);
 
 	return 0;
@@ -1043,7 +1047,8 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 
 	/* channel change time is dependent on chip and band  */
 	hw->channel_change_time = 7 * 1000;
-	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				     BIT(NL80211_IFTYPE_AP);
 
 	hw->wiphy->flags |= WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 15bff24..d723e15 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2174,6 +2174,18 @@ void brcms_c_start_station(struct brcms_c_info *wlc, u8 *addr)
 	wlc->bsscfg->type = BRCMS_TYPE_STATION;
 }
 
+void brcms_c_start_ap(struct brcms_c_info *wlc, u8 *addr, const u8 *bssid,
+		      u8 *ssid, size_t ssid_len)
+{
+	brcms_c_set_ssid(wlc, ssid, ssid_len);
+
+	memcpy(wlc->pub->cur_etheraddr, addr, sizeof(wlc->pub->cur_etheraddr));
+	memcpy(wlc->bsscfg->BSSID, bssid, sizeof(wlc->bsscfg->BSSID));
+	wlc->bsscfg->type = BRCMS_TYPE_AP;
+
+	brcms_b_mctrl(wlc->hw, MCTL_AP | MCTL_INFRA, MCTL_AP | MCTL_INFRA);
+}
+
 /* Initialize GPIOs that are controlled by D11 core */
 static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 {
@@ -3062,6 +3074,9 @@ static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 	if (wlc->filter_flags & FIF_PROMISC_IN_BSS)
 		return false;
 
+	if (wlc->bsscfg->type == BRCMS_TYPE_AP)
+		return false;
+
 	return true;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 5e6db62..ecff925 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -332,6 +332,8 @@ extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
 extern void brcms_c_mute(struct brcms_c_info *wlc, bool on);
 extern bool brcms_c_tx_flush_completed(struct brcms_c_info *wlc);
 extern void brcms_c_start_station(struct brcms_c_info *wlc, u8 *addr);
+extern void brcms_c_start_ap(struct brcms_c_info *wlc, u8 *addr,
+			     const u8 *bssid, u8 *ssid, size_t ssid_len);
 extern void brcms_c_update_beacon(struct brcms_c_info *wlc);
 extern void brcms_c_set_new_beacon(struct brcms_c_info *wlc,
 				   struct sk_buff *beacon, u16 tim_offset,
-- 
1.7.10.4

