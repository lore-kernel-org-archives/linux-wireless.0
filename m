Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:27880 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422895AbbD2Lpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 07:45:47 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 7/7] wil6210: support WSC for STA mode
Date: Wed, 29 Apr 2015 14:45:06 +0300
Message-Id: <1430307906-28393-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150429_134602_554554_3E5A52CD)
In-Reply-To: <1430307906-28393-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1430307906-28393-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WSC connection is secure (privacy bit set in various frames)
but authentication suite, keys etc. are absent.

Support this mode in the connect WMI command. Detect WSC by
having 'sme->privacy' and no RSN IE. Inform firmware about WSC
session by setting dot11_auth_mode to WMI_AUTH11_WSC.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 1b02b73..dbfcdd1 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -402,11 +402,8 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	rsn_eid = sme->ie ?
 			cfg80211_find_ie(WLAN_EID_RSN, sme->ie, sme->ie_len) :
 			NULL;
-
-	if (sme->privacy && !rsn_eid) {
-		wil_err(wil, "Missing RSN IE for secure connection\n");
-		return -EINVAL;
-	}
+	if (sme->privacy && !rsn_eid)
+		wil_info(wil, "WSC connection\n");
 
 	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
 			       sme->ssid, sme->ssid_len,
@@ -465,13 +462,18 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 		goto out;
 	}
 	if (wil->privacy) {
-		conn.dot11_auth_mode = WMI_AUTH11_SHARED;
-		conn.auth_mode = WMI_AUTH_WPA2_PSK;
-		conn.pairwise_crypto_type = WMI_CRYPT_AES_GCMP;
-		conn.pairwise_crypto_len = 16;
-		conn.group_crypto_type = WMI_CRYPT_AES_GCMP;
-		conn.group_crypto_len = 16;
-	} else {
+		if (rsn_eid) { /* regular secure connection */
+			conn.dot11_auth_mode = WMI_AUTH11_SHARED;
+			conn.auth_mode = WMI_AUTH_WPA2_PSK;
+			conn.pairwise_crypto_type = WMI_CRYPT_AES_GCMP;
+			conn.pairwise_crypto_len = 16;
+			conn.group_crypto_type = WMI_CRYPT_AES_GCMP;
+			conn.group_crypto_len = 16;
+		} else { /* WSC */
+			conn.dot11_auth_mode = WMI_AUTH11_WSC;
+			conn.auth_mode = WMI_AUTH_NONE;
+		}
+	} else { /* insecure connection */
 		conn.dot11_auth_mode = WMI_AUTH11_OPEN;
 		conn.auth_mode = WMI_AUTH_NONE;
 	}
-- 
2.1.0

