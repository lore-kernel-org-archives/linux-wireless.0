Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2975 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935808Ab1JGAva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 20:51:30 -0400
From: Kevin Fang <chienf@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>,
	Kevin Fang <chienf@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH 1/1] ath6kl: Add WSC IE on the associate message
Date: Fri, 7 Oct 2011 08:51:19 +0800
Message-ID: <1317948679-10299-1-git-send-email-kevin.fang@qca.qualcomm.com> (sfid-20111007_025134_110537_2D8D5C89)
In-Reply-To: <Y>
References: <Y>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some WPS test items, such as item "5.1.14"
STAUT must include the WSC IE in the 802.11 Association Request frame.
Therefore, add the corresponding IE in association message.

Signed-off-by: Kevin Fang <kevin.fang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   53 ++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2dae5d8..3dad73c 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -237,6 +237,53 @@ static bool ath6kl_cfg80211_ready(struct ath6kl *ar)
 	return true;
 }
 
+static bool ath6kl_is_wpa_ie(const u8 *pos)
+{
+	return pos[0] == WLAN_EID_WPA && pos[1] >= 4 &&
+		pos[2] == 0x00 && pos[3] == 0x50 &&
+		pos[4] == 0xf2 && pos[5] == 0x01;
+}
+
+static bool ath6kl_is_rsn_ie(const u8 *pos)
+{
+	return pos[0] == WLAN_EID_RSN;
+}
+
+static int ath6kl_set_assoc_req_ies(struct ath6kl *ar, const u8 *ies,
+					size_t ies_len)
+{
+	const u8 *pos;
+	u8 *buf = NULL;
+	size_t len = 0;
+	int ret;
+
+	/*
+	 * Filter out RSN/WPA IE(s)
+	 */
+
+	if (ies && ies_len) {
+		buf = kmalloc(ies_len, GFP_KERNEL);
+		if (buf == NULL)
+			return -ENOMEM;
+		pos = ies;
+
+		while (pos + 1 < ies + ies_len) {
+			if (pos + 2 + pos[1] > ies + ies_len)
+				break;
+			if (!(ath6kl_is_wpa_ie(pos) || ath6kl_is_rsn_ie(pos))) {
+				memcpy(buf + len, pos, 2 + pos[1]);
+				len += 2 + pos[1];
+			}
+			pos += 2 + pos[1];
+		}
+	}
+
+	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_ASSOC_REQ,
+				       buf, len);
+	kfree(buf);
+	return ret;
+}
+
 static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 				   struct cfg80211_connect_params *sme)
 {
@@ -285,6 +332,12 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
+	if (sme->ie && (sme->ie_len > 0)) {
+		status = ath6kl_set_assoc_req_ies(ar, sme->ie, sme->ie_len);
+		if (status)
+			return status;
+	}
+
 	if (test_bit(CONNECTED, &ar->flag) &&
 	    ar->ssid_len == sme->ssid_len &&
 	    !memcmp(ar->ssid, sme->ssid, ar->ssid_len)) {
-- 
1.7.0.4

