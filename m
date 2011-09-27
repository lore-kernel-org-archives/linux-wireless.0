Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:42252 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751979Ab1I0Dhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 23:37:54 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: remove unreachable code
Date: Mon, 26 Sep 2011 20:37:24 -0700
Message-Id: <1317094646-7718-2-git-send-email-bzhao@marvell.com> (sfid-20110927_053757_772149_4E86A447)
In-Reply-To: <1317094646-7718-1-git-send-email-bzhao@marvell.com>
References: <1317094646-7718-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

In disconnected state "iw dev mlan0 link" command will return
from cfg80211 stack itself. We also have an error check in
mwifiex_cfg80211_get_station() routine. Therefore the code
under "if (!priv->media_connected)" condition in
mwifiex_rate_ioctl_get_rate_value() routine becomes unreachable.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   46 +----------------------------
 1 files changed, 2 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 1df5ef6..cee1487 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -717,51 +717,9 @@ done:
 static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
 					     struct mwifiex_rate_cfg *rate_cfg)
 {
-	struct mwifiex_adapter *adapter = priv->adapter;
-
 	rate_cfg->is_rate_auto = priv->is_data_rate_auto;
-	if (!priv->media_connected) {
-		switch (adapter->config_bands) {
-		case BAND_B:
-			/* Return the lowest supported rate for B band */
-			rate_cfg->rate = supported_rates_b[0] & 0x7f;
-			break;
-		case BAND_G:
-		case BAND_G | BAND_GN:
-			/* Return the lowest supported rate for G band */
-			rate_cfg->rate = supported_rates_g[0] & 0x7f;
-			break;
-		case BAND_B | BAND_G:
-		case BAND_A | BAND_B | BAND_G:
-		case BAND_A | BAND_B:
-		case BAND_A | BAND_B | BAND_G | BAND_AN | BAND_GN:
-		case BAND_B | BAND_G | BAND_GN:
-			/* Return the lowest supported rate for BG band */
-			rate_cfg->rate = supported_rates_bg[0] & 0x7f;
-			break;
-		case BAND_A:
-		case BAND_A | BAND_G:
-		case BAND_A | BAND_G | BAND_AN | BAND_GN:
-		case BAND_A | BAND_AN:
-			/* Return the lowest supported rate for A band */
-			rate_cfg->rate = supported_rates_a[0] & 0x7f;
-			break;
-		case BAND_GN:
-			/* Return the lowest supported rate for N band */
-			rate_cfg->rate = supported_rates_n[0] & 0x7f;
-			break;
-		default:
-			dev_warn(adapter->dev, "invalid band %#x\n",
-			       adapter->config_bands);
-			break;
-		}
-	} else {
-		return mwifiex_send_cmd_sync(priv,
-					    HostCmd_CMD_802_11_TX_RATE_QUERY,
-					    HostCmd_ACT_GEN_GET, 0, NULL);
-	}
-
-	return 0;
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_TX_RATE_QUERY,
+				     HostCmd_ACT_GEN_GET, 0, NULL);
 }
 
 /*
-- 
1.7.0.2

