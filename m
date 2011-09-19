Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14914 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab1ISQQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:16:34 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 9/9] ath6kl: Export beacon interval and DTIM period through STA info
Date: Mon, 19 Sep 2011 19:15:07 +0300
Message-ID: <1316448907-10166-10-git-send-email-jouni@qca.qualcomm.com> (sfid-20110919_181637_600560_576FD9C9)
In-Reply-To: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
References: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we allow the first Beacon frame after each connection to
be processed at the host, we can figure out the DTIM period and
expose it with Beacon interval through STA info BSS parameters
to user space.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    3 +++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   11 +++++++++++
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0bdd837..c3540bb 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -483,6 +483,13 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 	assoc_req_len -= assoc_req_ie_offset;
 	assoc_resp_len -= assoc_resp_ie_offset;
 
+	/*
+	 * Store Beacon interval here; DTIM period will be available only once
+	 * a Beacon frame from the AP is seen.
+	 */
+	ar->assoc_bss_beacon_int = beacon_intvl;
+	clear_bit(DTIM_PERIOD_AVAIL, &ar->flag);
+
 	if (nw_type & ADHOC_NETWORK) {
 		if (ar->wdev->iftype != NL80211_IFTYPE_ADHOC) {
 			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
@@ -1366,6 +1373,15 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	sinfo->filled |= STATION_INFO_TX_BITRATE;
 
+	if (test_bit(CONNECTED, &ar->flag) &&
+	    test_bit(DTIM_PERIOD_AVAIL, &ar->flag) &&
+	    ar->nw_type == INFRA_NETWORK) {
+		sinfo->filled |= STATION_INFO_BSS_PARAM;
+		sinfo->bss_param.flags = 0;
+		sinfo->bss_param.dtim_period = ar->assoc_bss_dtim_period;
+		sinfo->bss_param.beacon_interval = ar->assoc_bss_beacon_int;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c14bb75..82be42f 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -395,6 +395,7 @@ struct ath6kl_req_key {
 #define WLAN_ENABLED	     12
 #define TESTMODE	     13
 #define CLEAR_BSSFILTER_ON_BEACON 14
+#define DTIM_PERIOD_AVAIL    15
 
 struct ath6kl {
 	struct device *dev;
@@ -511,6 +512,8 @@ struct ath6kl {
 	u16 next_chan;
 
 	bool p2p;
+	u16 assoc_bss_beacon_int;
+	u8 assoc_bss_dtim_period;
 
 #ifdef CONFIG_ATH6KL_DEBUG
 	struct {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index f7dcb56..b90d116 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -930,6 +930,17 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 	if (len < 8 + 2 + 2)
 		return -EINVAL;
 
+	if (bih->frame_type == BEACON_FTYPE && test_bit(CONNECTED, &ar->flag) &&
+	    memcmp(bih->bssid, ar->bssid, ETH_ALEN) == 0) {
+		const u8 *tim;
+		tim = cfg80211_find_ie(WLAN_EID_TIM, buf + 8 + 2 + 2,
+				       len - 8 - 2 - 2);
+		if (tim && tim[1] >= 2) {
+			ar->assoc_bss_dtim_period = tim[3];
+			set_bit(DTIM_PERIOD_AVAIL, &ar->flag);
+		}
+	}
+
 	/*
 	 * In theory, use of cfg80211_inform_bss() would be more natural here
 	 * since we do not have the full frame. However, at least for now,
-- 
1.7.4.1

