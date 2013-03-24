Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55636 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3CXAsg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 20:48:36 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 13/15] brcmsmac: deactivate ucode sending probe responses
Date: Sun, 24 Mar 2013 01:46:01 +0100
Message-Id: <1364085963-25940-14-git-send-email-hauke@hauke-m.de> (sfid-20130324_014839_303242_E304620C)
In-Reply-To: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is possible to configure the ucode to automatically send the probe
responses to the clients after they send a probe request. At least for
WPS the userspace needs to answer the probe requests and we do not know
a way to say to the ucode to just handle the normal probe requests, so
for now no probe requests should be handled by the ucode.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |   13 ++++++++++++-
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |   11 +++++++++++
 drivers/net/wireless/brcm80211/brcmsmac/pub.h         |    1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index d4a51f0..4b3d46a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -552,6 +552,12 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		/* Beaconing should be enabled/disabled (beaconing modes) */
 		brcms_err(core, "%s: Beacon enabled: %s\n", __func__,
 			  info->enable_beacon ? "true" : "false");
+		if (info->enable_beacon &&
+		    hw->wiphy->flags & WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD) {
+			brcms_c_enable_probe_resp(wl->wlc, true);
+		} else {
+			brcms_c_enable_probe_resp(wl->wlc, false);
+		}
 	}
 
 	if (changed & BSS_CHANGED_CQM) {
@@ -1047,7 +1053,12 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	hw->channel_change_time = 7 * 1000;
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
-	hw->wiphy->flags |= WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+	/*
+	 * deactivate sending probe responses by ucude, because this will
+	 * cause problems when WPS is used.
+	 *
+	 * hw->wiphy->flags |= WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+	 */
 
 	hw->rate_control_algorithm = "minstrel_ht";
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 04192ed..63fb9fd 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7480,6 +7480,17 @@ void brcms_c_set_new_probe_resp(struct brcms_c_info *wlc,
 	brcms_c_update_probe_resp(wlc, false);
 }
 
+void brcms_c_enable_probe_resp(struct brcms_c_info *wlc, bool enable)
+{
+	/*
+	 * prevent ucode from sending probe responses by setting the timeout
+	 * to 1, it can not send it in that time frame.
+	 */
+	wlc->prb_resp_timeout = enable ? BRCMS_PRB_RESP_TIMEOUT : 1;
+	brcms_b_write_shm(wlc->hw, M_PRS_MAXTIME, wlc->prb_resp_timeout);
+	/* TODO: if (enable) => also deactivate receiving of probe request */
+}
+
 /* Write ssid into shared memory */
 static void
 brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_bss_cfg *cfg)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 5e6db62..6fa746e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -338,6 +338,7 @@ extern void brcms_c_set_new_beacon(struct brcms_c_info *wlc,
 				   u16 dtim_period);
 extern void brcms_c_set_new_probe_resp(struct brcms_c_info *wlc,
 				       struct sk_buff *probe_resp);
+extern void brcms_c_enable_probe_resp(struct brcms_c_info *wlc, bool enable);
 extern void brcms_c_set_ssid(struct brcms_c_info *wlc, u8 *ssid,
 			     size_t ssid_len);
 
-- 
1.7.10.4

