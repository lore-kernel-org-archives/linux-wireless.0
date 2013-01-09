Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:50827 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756386Ab3AIB6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 20:58:17 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.8] mwifiex: update config_bands during infra association
Date: Tue,  8 Jan 2013 17:53:10 -0800
Message-Id: <1357696391-9396-1-git-send-email-bzhao@marvell.com> (sfid-20130109_025820_908412_97D6849F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently "adapter->config_bands" is updated during infra
association only if channel is provided by user in "iw connect"
command. config_bands is used while preparing association
request to calculate supported rates by intersecting our rates
with the rates advertised by AP.

There is corner case in which we include zero rates in
supported rates TLV based on previous IBSS network history,
which leads to association failure.

This patch fixes the problem by correctly updating config_bands.

Cc: "3.7.y" <stable@vger.kernel.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   15 +--------------
 drivers/net/wireless/mwifiex/sta_ioctl.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index a1f7fe0..b4dbe22 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1460,7 +1460,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	struct cfg80211_ssid req_ssid;
 	int ret, auth_type = 0;
 	struct cfg80211_bss *bss = NULL;
-	u8 is_scanning_required = 0, config_bands = 0;
+	u8 is_scanning_required = 0;
 
 	memset(&req_ssid, 0, sizeof(struct cfg80211_ssid));
 
@@ -1479,19 +1479,6 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	/* disconnect before try to associate */
 	mwifiex_deauthenticate(priv, NULL);
 
-	if (channel) {
-		if (mode == NL80211_IFTYPE_STATION) {
-			if (channel->band == IEEE80211_BAND_2GHZ)
-				config_bands = BAND_B | BAND_G | BAND_GN;
-			else
-				config_bands = BAND_A | BAND_AN;
-
-			if (!((config_bands | priv->adapter->fw_bands) &
-			      ~priv->adapter->fw_bands))
-				priv->adapter->config_bands = config_bands;
-		}
-	}
-
 	/* As this is new association, clear locally stored
 	 * keys and security related flags */
 	priv->sec_info.wpa_enabled = false;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 60e88b5..f542bb8 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -283,6 +283,20 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		if (ret)
 			goto done;
 
+		if (bss_desc) {
+			u8 config_bands = 0;
+
+			if (mwifiex_band_to_radio_type((u8) bss_desc->bss_band)
+			    == HostCmd_SCAN_RADIO_TYPE_BG)
+				config_bands = BAND_B | BAND_G | BAND_GN;
+			else
+				config_bands = BAND_A | BAND_AN;
+
+			if (!((config_bands | adapter->fw_bands) &
+			      ~adapter->fw_bands))
+				adapter->config_bands = config_bands;
+		}
+
 		ret = mwifiex_check_network_compatibility(priv, bss_desc);
 		if (ret)
 			goto done;
-- 
1.7.0.2

