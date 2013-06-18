Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:58645 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763Ab3FRXmG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 19:42:06 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: code rearrangement for better readability
Date: Tue, 18 Jun 2013 16:36:56 -0700
Message-ID: <1371598618-26593-1-git-send-email-bzhao@marvell.com> (sfid-20130619_014208_745055_BA573B08)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Use negative check (if(!bss_desc)) and return failure
instead of failing a NULL check later in
mwifiex_check_network_compatibility() routine.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 23aa910..15b5457 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -255,25 +255,24 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 	}
 
 	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
+		u8 config_bands;
+
 		/* Infra mode */
 		ret = mwifiex_deauthenticate(priv, NULL);
 		if (ret)
 			goto done;
 
-		if (bss_desc) {
-			u8 config_bands = 0;
+		if (!bss_desc)
+			return -1;
 
-			if (mwifiex_band_to_radio_type((u8) bss_desc->bss_band)
-			    == HostCmd_SCAN_RADIO_TYPE_BG)
-				config_bands = BAND_B | BAND_G | BAND_GN |
-					       BAND_GAC;
-			else
-				config_bands = BAND_A | BAND_AN | BAND_AAC;
+		if (mwifiex_band_to_radio_type(bss_desc->bss_band) ==
+						HostCmd_SCAN_RADIO_TYPE_BG)
+			config_bands = BAND_B | BAND_G | BAND_GN | BAND_GAC;
+		else
+			config_bands = BAND_A | BAND_AN | BAND_AAC;
 
-			if (!((config_bands | adapter->fw_bands) &
-			      ~adapter->fw_bands))
-				adapter->config_bands = config_bands;
-		}
+		if (!((config_bands | adapter->fw_bands) & ~adapter->fw_bands))
+			adapter->config_bands = config_bands;
 
 		ret = mwifiex_check_network_compatibility(priv, bss_desc);
 		if (ret)
-- 
1.8.2.3

