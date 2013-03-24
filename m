Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55615 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3CXAsZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 20:48:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 11/15] brcmsmac: react on changing SSID
Date: Sun, 24 Mar 2013 01:45:59 +0100
Message-Id: <1364085963-25940-12-git-send-email-hauke@hauke-m.de> (sfid-20130324_014828_284053_2B305FBF)
In-Reply-To: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To send the correct probe response the hardware needs to know the SSID
when it changed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    6 ++++++
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |    9 +++++++++
 drivers/net/wireless/brcm80211/brcmsmac/pub.h         |    2 ++
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 591e262..1d0d0f6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -521,6 +521,12 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		brcms_c_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET, info->bssid);
 		spin_unlock_bh(&wl->lock);
 	}
+	if (changed & BSS_CHANGED_SSID) {
+		/* BSSID changed, for whatever reason (IBSS and managed mode) */
+		spin_lock_bh(&wl->lock);
+		brcms_c_set_ssid(wl->wlc, info->ssid, info->ssid_len);
+		spin_unlock_bh(&wl->lock);
+	}
 	if (changed & BSS_CHANGED_BEACON) {
 		/* Beacon data changed, retrieve new beacon (beaconing modes) */
 		struct sk_buff *beacon;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 60dc2c4..cf11d894 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3783,6 +3783,15 @@ static void brcms_c_set_bssid(struct brcms_bss_cfg *bsscfg)
 	brcms_c_set_addrmatch(bsscfg->wlc, RCM_BSSID_OFFSET, bsscfg->BSSID);
 }
 
+void brcms_c_set_ssid(struct brcms_c_info *wlc, u8 *ssid, size_t ssid_len)
+{
+	u8 len = min_t(u8, sizeof(wlc->bsscfg->SSID), ssid_len);
+	memset(wlc->bsscfg->SSID, 0, sizeof(wlc->bsscfg->SSID));
+
+	memcpy(wlc->bsscfg->SSID, ssid, len);
+	wlc->bsscfg->SSID_len = len;
+}
+
 static void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
 {
 	wlc_hw->shortslot = shortslot;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 8a3071f..6ed0a20 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -336,5 +336,7 @@ extern void brcms_c_update_beacon(struct brcms_c_info *wlc);
 extern void brcms_c_set_new_beacon(struct brcms_c_info *wlc,
 				   struct sk_buff *beacon, u16 tim_offset,
 				   u16 dtim_period);
+extern void brcms_c_set_ssid(struct brcms_c_info *wlc, u8 *ssid,
+			     size_t ssid_len);
 
 #endif				/* _BRCM_PUB_H_ */
-- 
1.7.10.4

