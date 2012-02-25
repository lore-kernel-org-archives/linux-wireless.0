Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:55157 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752191Ab2BYFix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 00:38:53 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.3] mwifiex: fix bug in wildcard scan handling
Date: Fri, 24 Feb 2012 21:35:49 -0800
Message-Id: <1330148149-28922-1-git-send-email-bzhao@marvell.com> (sfid-20120225_063856_034955_8526CBA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently if valid SSID list is provided in scan request driver
performs specific SSID scan otherwise wildcard scan is chosen.

When wpa_supplicant provides valid SSID list followed by
zero-length SSID for wildcard scan, only specific SSID scan is
performed by driver. Actually driver is expected to do both type of
scanning in this case.

Also, adding 1 byte to ssid length is redundant. It's removed here.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   11 +++++++++--
 drivers/net/wireless/mwifiex/scan.c     |    7 +++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 2a1fc32..d8ff33a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1107,8 +1107,15 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 	for (i = 0; i < request->n_ssids; i++) {
 		memcpy(priv->user_scan_cfg->ssid_list[i].ssid,
 			request->ssids[i].ssid, request->ssids[i].ssid_len);
-		priv->user_scan_cfg->ssid_list[i].max_len =
-			request->ssids[i].ssid_len;
+
+		/* max_len = 0 tells firmware to perform specific scan for the
+		 * SSID filled, whereas max_len = IEEE80211_MAX_SSID_LEN is for
+		 * wildcard scan */
+		if (request->ssids[i].ssid_len)
+			priv->user_scan_cfg->ssid_list[i].max_len = 0;
+		else
+			priv->user_scan_cfg->ssid_list[i].max_len =
+				IEEE80211_MAX_SSID_LEN;
 	}
 	for (i = 0; i < request->n_channels; i++) {
 		chan = request->channels[i];
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 98f1ca9..813e94d 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -809,7 +809,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		     ssid_idx++) {
 
 			ssid_len = strlen(user_scan_in->ssid_list[ssid_idx].
-					  ssid) + 1;
+					  ssid);
 
 			wildcard_ssid_tlv =
 				(struct mwifiex_ie_types_wildcard_ssid_params *)
@@ -820,9 +820,8 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 				(u16) (ssid_len + sizeof(wildcard_ssid_tlv->
 							 max_ssid_length)));
 
-			/* max_ssid_length = 0 tells firmware to perform
-			   specific scan for the SSID filled */
-			wildcard_ssid_tlv->max_ssid_length = 0;
+			wildcard_ssid_tlv->max_ssid_length =
+				user_scan_in->ssid_list[ssid_idx].max_len;
 
 			memcpy(wildcard_ssid_tlv->ssid,
 			       user_scan_in->ssid_list[ssid_idx].ssid,
-- 
1.7.0.2

