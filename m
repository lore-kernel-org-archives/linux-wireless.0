Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:60161 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758134Ab2BJCc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 21:32:57 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.3] mwifiex: clear previous security setting during association
Date: Thu,  9 Feb 2012 18:32:22 -0800
Message-Id: <1328841142-4065-1-git-send-email-bzhao@marvell.com> (sfid-20120210_033301_350137_B56997C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Driver maintains different flags for WEP, WPA, WPA2 security modes.
Appropriate flag is set using security information provided in
connect request. mwifiex_is_network_compatible() routine uses them
to check if driver's setting is compatible with AP. Association is
aborted if the routine fails.

For some corner cases, it is observed that association is failed
even for valid security information based on association history.
This patch fixes the problem by clearing previous security setting
during each association.

We should set WEP key provided in connect request as default tx key.
This missing change is also added here.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 478d2f1..8d8ee63 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -867,7 +867,12 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 		ret = mwifiex_set_rf_channel(priv, channel,
 						priv->adapter->channel_type);
 
-	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);	/* Disable keys */
+	/* As this is new association, clear locally stored
+	 * keys and security related flags */
+	priv->sec_info.wpa_enabled = false;
+	priv->sec_info.wpa2_enabled = false;
+	priv->wep_key_curr_index = 0;
+	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);
 
 	if (mode == NL80211_IFTYPE_ADHOC) {
 		/* "privacy" is set only for ad-hoc mode */
@@ -912,6 +917,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 			dev_dbg(priv->adapter->dev,
 				"info: setting wep encryption"
 				" with key len %d\n", sme->key_len);
+			priv->wep_key_curr_index = sme->key_idx;
 			ret = mwifiex_set_encode(priv, sme->key, sme->key_len,
 							sme->key_idx, 0);
 		}
-- 
1.7.0.2

