Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1579 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab1H2I4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 04:56:52 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <jouni@qca.qualcomm.com>
CC: <hostap@lists.shmoo.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] wpa_supplicant: Modify bgscan based roaming behaviour.
Date: Mon, 29 Aug 2011 14:26:45 +0530
Message-ID: <1314608205-4995-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20110829_105655_571554_23D37D69)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cancel background scan based roaming behavior if the driver
is capable of handling roaming in the firmware. For fullmac
drivers like ath6kl, the roaming logic is handled in the
firmware and for supplicant to initiate roam, the station
has to disconnect completely and then reconnect with the
new AP which takes a longer time without preauth.

Currently, if the supplicant also tries to roam, all requests
are rejected by cfg80211 resulting in a spam of log.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 src/drivers/driver.h         |    2 ++
 src/drivers/driver_nl80211.c |    9 +++++++++
 src/drivers/nl80211_copy.h   |    1 +
 wpa_supplicant/events.c      |    7 +++++++
 4 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 67c5631..804ce93 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -675,6 +675,8 @@ struct wpa_driver_capa {
 #define WPA_DRIVER_FLAGS_EAPOL_TX_STATUS		0x00010000
 /* Driver indicates TX status events for Deauth/Disassoc frames */
 #define WPA_DRIVER_FLAGS_DEAUTH_TX_STATUS		0x00020000
+/* Driver supports roaming in firmware */
+#define WPA_DRIVER_FLAGS_FW_ROAMING			0x00040000
 	unsigned int flags;
 
 	int max_scan_ssids;
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index e49e714..5fbf46b 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -1640,6 +1640,7 @@ struct wiphy_info_data {
 	int connect_supported;
 	int offchan_tx_supported;
 	int max_remain_on_chan;
+	int fw_roam;
 };
 
 
@@ -1695,6 +1696,9 @@ static int wiphy_info_handler(struct nl_msg *msg, void *arg)
 	if (tb[NL80211_ATTR_OFFCHANNEL_TX_OK])
 		info->offchan_tx_supported = 1;
 
+	if (tb[NL80211_ATTR_ROAM_SUPPORT])
+		info->fw_roam = 1;
+
 	if (tb[NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION])
 		info->max_remain_on_chan =
 			nla_get_u32(tb[NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION]);
@@ -1768,6 +1772,11 @@ static int wpa_driver_nl80211_capa(struct wpa_driver_nl80211_data *drv)
 		drv->capa.flags |= WPA_DRIVER_FLAGS_OFFCHANNEL_TX;
 	}
 
+	if (info.fw_roam) {
+		wpa_printf(MSG_DEBUG, "nl80211: Using driver-based roaming");
+		drv->capa.flags |= WPA_DRIVER_FLAGS_FW_ROAMING;
+	}
+
 	drv->capa.flags |= WPA_DRIVER_FLAGS_SANE_ERROR_CODES;
 	drv->capa.flags |= WPA_DRIVER_FLAGS_SET_KEYS_AFTER_ASSOC_DONE;
 	if (info.p2p_supported)
diff --git a/src/drivers/nl80211_copy.h b/src/drivers/nl80211_copy.h
index 3769303..ca05807 100644
--- a/src/drivers/nl80211_copy.h
+++ b/src/drivers/nl80211_copy.h
@@ -1252,6 +1252,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_IE_PROBE_RESP,
 	NL80211_ATTR_IE_ASSOC_RESP,
 
+	NL80211_ATTR_ROAM_SUPPORT,
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/wpa_supplicant/events.c b/wpa_supplicant/events.c
index a307eda..57c987b 100644
--- a/wpa_supplicant/events.c
+++ b/wpa_supplicant/events.c
@@ -718,6 +718,13 @@ void wpa_supplicant_connect(struct wpa_supplicant *wpa_s,
 		return;
 	}
 
+	if ((wpa_s->current_ssid == ssid) &&
+	    (wpa_s->drv_flags & WPA_DRIVER_FLAGS_FW_ROAMING)) {
+		wpa_dbg(wpa_s, MSG_DEBUG, "Cancel supplicant roaming as "
+				"driver has the capability");
+		return;
+	}
+
 	/*
 	 * Do not trigger new association unless the BSSID has changed or if
 	 * reassociation is requested. If we are in process of associating with
-- 
1.7.1

