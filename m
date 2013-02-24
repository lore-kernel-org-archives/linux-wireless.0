Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53935 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758968Ab3BXBGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 20:06:44 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 02/13] brcmsmac: add interface type to brcms_bss_cfg
Date: Sun, 24 Feb 2013 02:06:00 +0100
Message-Id: <1361667972-22909-3-git-send-email-hauke@hauke-m.de> (sfid-20130224_020657_334097_30432A7D)
In-Reply-To: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it possible to easily check in which mode the device is
currently running. This also adds a function to start station mode.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    3 ++-
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |    6 ++++++
 drivers/net/wireless/brcm80211/brcmsmac/main.h        |    8 ++++++++
 drivers/net/wireless/brcm80211/brcmsmac/pub.h         |    1 +
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index ab678ae..577df22 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -364,9 +364,10 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_bh(&wl->lock);
-	memcpy(wl->pub->cur_etheraddr, vif->addr, sizeof(vif->addr));
 	wl->mute_tx = false;
 	brcms_c_mute(wl->wlc, false);
+	if (vif->type == NL80211_IFTYPE_STATION)
+		brcms_c_start_station(wl->wlc, vif->addr);
 	spin_unlock_bh(&wl->lock);
 
 	return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 5f455ba..5696257 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2163,6 +2163,12 @@ void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode)
 	}
 }
 
+void brcms_c_start_station(struct brcms_c_info *wlc, u8 *addr)
+{
+	memcpy(wlc->pub->cur_etheraddr, addr, sizeof(wlc->pub->cur_etheraddr));
+	wlc->bsscfg->type = BRCMS_TYPE_STATION;
+}
+
 /* Initialize GPIOs that are controlled by D11 core */
 static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index fb44774..dbf027c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -576,10 +576,17 @@ struct antsel_info {
 	struct brcms_antselcfg antcfg_cur; /* current antenna config (auto) */
 };
 
+enum brcms_bss_type {
+	BRCMS_TYPE_STATION,
+	BRCMS_TYPE_AP,
+	BRCMS_TYPE_ADHOC,
+};
+
 /*
  * BSS configuration state
  *
  * wlc: wlc to which this bsscfg belongs to.
+ * type: interface type
  * up: is this configuration up operational
  * enable: is this configuration enabled
  * associated: is BSS in ASSOCIATED state
@@ -599,6 +606,7 @@ struct antsel_info {
  */
 struct brcms_bss_cfg {
 	struct brcms_c_info *wlc;
+	enum brcms_bss_type type;
 	bool up;
 	bool enable;
 	bool associated;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 382fb09..aa8580f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -333,5 +333,6 @@ extern int brcms_c_get_tx_power(struct brcms_c_info *wlc);
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
 extern void brcms_c_mute(struct brcms_c_info *wlc, bool on);
 extern bool brcms_c_tx_flush_completed(struct brcms_c_info *wlc);
+extern void brcms_c_start_station(struct brcms_c_info *wlc, u8 *addr);
 
 #endif				/* _BRCM_PUB_H_ */
-- 
1.7.10.4

