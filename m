Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47089 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbbBOMDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 07:03:12 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 8/9] wil6210: track privacy connection attribute
Date: Sun, 15 Feb 2015 14:02:37 +0200
Message-Id: <1424001758-29529-9-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150215_130319_819259_9A5CFE9B)
In-Reply-To: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the STA interface, track 'privacy'.
Refactor safety checks to:
- always print connection params
- always check IE size validity
- require RSN IE for secure connection

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 30 +++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 38bd294..4bd708c 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -387,11 +387,25 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	int ch;
 	int rc = 0;
 
+	wil_print_connect_params(wil, sme);
+
 	if (test_bit(wil_status_fwconnecting, wil->status) ||
 	    test_bit(wil_status_fwconnected, wil->status))
 		return -EALREADY;
 
-	wil_print_connect_params(wil, sme);
+	if (sme->ie_len > WMI_MAX_IE_LEN) {
+		wil_err(wil, "IE too large (%td bytes)\n", sme->ie_len);
+		return -ERANGE;
+	}
+
+	rsn_eid = sme->ie ?
+			cfg80211_find_ie(WLAN_EID_RSN, sme->ie, sme->ie_len) :
+			NULL;
+
+	if (sme->privacy && !rsn_eid) {
+		wil_err(wil, "Missing RSN IE for secure connection\n");
+		return -EINVAL;
+	}
 
 	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
 			       sme->ssid, sme->ssid_len,
@@ -407,17 +421,9 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 		rc = -ENOENT;
 		goto out;
 	}
+	wil->privacy = sme->privacy;
 
-	rsn_eid = sme->ie ?
-			cfg80211_find_ie(WLAN_EID_RSN, sme->ie, sme->ie_len) :
-			NULL;
-	if (rsn_eid) {
-		if (sme->ie_len > WMI_MAX_IE_LEN) {
-			rc = -ERANGE;
-			wil_err(wil, "IE too large (%td bytes)\n",
-				sme->ie_len);
-			goto out;
-		}
+	if (wil->privacy) {
 		/* For secure assoc, send WMI_DELETE_CIPHER_KEY_CMD */
 		rc = wmi_del_cipher_key(wil, 0, bss->bssid);
 		if (rc) {
@@ -450,7 +456,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 			bss->capability);
 		goto out;
 	}
-	if (rsn_eid) {
+	if (wil->privacy) {
 		conn.dot11_auth_mode = WMI_AUTH11_SHARED;
 		conn.auth_mode = WMI_AUTH_WPA2_PSK;
 		conn.pairwise_crypto_type = WMI_CRYPT_AES_GCMP;
-- 
2.1.0

