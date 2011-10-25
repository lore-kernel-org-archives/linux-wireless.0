Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36832 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab1JYS0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 14:26:24 -0400
From: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH] ath6kl: add support for WPS
Date: Tue, 25 Oct 2011 11:25:52 -0700
Message-ID: <1319567152-19789-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com> (sfid-20111025_202635_030335_ADCAF81A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add control flag CONNECT_WPS_FLAG if a WPS IE is present in the
Association Request IEs. This flag is needed when the station must
connect to a WPS-enabled AP.

Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   18 ++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    1 +
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0680d2b..11dd401 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -256,6 +256,14 @@ static bool ath6kl_is_rsn_ie(const u8 *pos)
 	return pos[0] == WLAN_EID_RSN;
 }
 
+static bool ath6kl_is_wps_ie(const u8 *pos)
+{
+	return (pos[0] == WLAN_EID_VENDOR_SPECIFIC &&
+		pos[1] >= 4 &&
+		pos[2] == 0x00 && pos[3] == 0x50 && pos[4] == 0xf2 &&
+		pos[5] == 0x04);
+}
+
 static int ath6kl_set_assoc_req_ies(struct ath6kl *ar, const u8 *ies,
 					size_t ies_len)
 {
@@ -265,6 +273,12 @@ static int ath6kl_set_assoc_req_ies(struct ath6kl *ar, const u8 *ies,
 	int ret;
 
 	/*
+	 * Clear previously set flag
+	 */
+
+	ar->connect_ctrl_flags &= ~CONNECT_WPS_FLAG;
+
+	/*
 	 * Filter out RSN/WPA IE(s)
 	 */
 
@@ -281,6 +295,10 @@ static int ath6kl_set_assoc_req_ies(struct ath6kl *ar, const u8 *ies,
 				memcpy(buf + len, pos, 2 + pos[1]);
 				len += 2 + pos[1];
 			}
+
+			if (ath6kl_is_wps_ie(pos))
+				ar->connect_ctrl_flags |= CONNECT_WPS_FLAG;
+
 			pos += 2 + pos[1];
 		}
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index f0ca899..37847cf 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -606,6 +606,7 @@ enum wmi_connect_ctrl_flags_bits {
 	CONNECT_CSA_FOLLOW_BSS = 0x0020,
 	CONNECT_DO_WPA_OFFLOAD = 0x0040,
 	CONNECT_DO_NOT_DEAUTH = 0x0080,
+	CONNECT_WPS_FLAG = 0x0100,
 };
 
 struct wmi_connect_cmd {
-- 
1.7.0.4

