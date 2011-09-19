Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14914 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab1ISQQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:16:30 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 8/9] ath6kl: Update BSS information after connection
Date: Mon, 19 Sep 2011 19:15:06 +0300
Message-ID: <1316448907-10166-9-git-send-email-jouni@qca.qualcomm.com> (sfid-20110919_181632_301464_938BFA4B)
In-Reply-To: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
References: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we may end up using a dummy BSS entry when roaming, allow one Beacon
frame -based bssinfo from the current BSS to be processed prior to starting
to filter all bssinfo events. This allows cfg80211 BSS table to be filled
with proper data in the roaming case where the full Beacon data may not
have been present at the time of roamed event.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 ++
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/main.c     |   10 +++++++---
 drivers/net/wireless/ath/ath6kl/wmi.c      |    6 ++++++
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b328437..0bdd837 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -360,6 +360,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (!ar->usr_bss_filter) {
+		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag);
 		if (ath6kl_wmi_bssfilter_cmd(ar->wmi, ALL_BSS_FILTER, 0) != 0) {
 			ath6kl_err("couldn't set bss filtering\n");
 			up(&ar->sem);
@@ -638,6 +639,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	if (!ar->usr_bss_filter) {
+		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag);
 		ret = ath6kl_wmi_bssfilter_cmd(
 			ar->wmi,
 			(test_bit(CONNECTED, &ar->flag) ?
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 9e6abb8..c14bb75 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -394,6 +394,7 @@ struct ath6kl_req_key {
 #define SKIP_SCAN	     11
 #define WLAN_ENABLED	     12
 #define TESTMODE	     13
+#define CLEAR_BSSFILTER_ON_BEACON 14
 
 struct ath6kl {
 	struct device *dev;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 55d3331..30b5a53 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1011,8 +1011,10 @@ void ath6kl_scan_complete_evt(struct ath6kl *ar, int status)
 {
 	ath6kl_cfg80211_scan_complete_event(ar, status);
 
-	if (!ar->usr_bss_filter)
+	if (!ar->usr_bss_filter) {
+		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag);
 		ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
+	}
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_SCAN, "scan complete: %d\n", status);
 }
@@ -1056,8 +1058,10 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 		ar->next_ep_id = ENDPOINT_2;
 	}
 
-	if (!ar->usr_bss_filter)
-		ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
+	if (!ar->usr_bss_filter) {
+		set_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag);
+		ath6kl_wmi_bssfilter_cmd(ar->wmi, CURRENT_BSS_FILTER, 0);
+	}
 }
 
 void ath6kl_tkip_micerr_event(struct ath6kl *ar, u8 keyid, bool ismcast)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 72cf78c..f7dcb56 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -917,6 +917,12 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 	    bih->frame_type != PROBERESP_FTYPE)
 		return 0; /* Only update BSS table for now */
 
+	if (bih->frame_type == BEACON_FTYPE &&
+	    test_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag)) {
+		clear_bit(CLEAR_BSSFILTER_ON_BEACON, &ar->flag);
+		ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
+	}
+
 	channel = ieee80211_get_channel(ar->wdev->wiphy, le16_to_cpu(bih->ch));
 	if (channel == NULL)
 		return -EINVAL;
-- 
1.7.4.1

