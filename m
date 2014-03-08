Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50659 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbaCHDmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 22:42:11 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/6] mwifiex: use VHT MCS mask in set bitrate mask handler
Date: Fri, 7 Mar 2014 19:41:28 -0800
Message-ID: <1394250091-18477-3-git-send-email-bzhao@marvell.com> (sfid-20140308_044216_730811_5F4988F3)
In-Reply-To: <1394250091-18477-1-git-send-email-bzhao@marvell.com>
References: <1394250091-18477-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

As V15 firmware supports VHT rate configuration, we can use this
information received in set bitrate mask handler.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 51ce99c..ee45d62 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1158,9 +1158,10 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
 	enum ieee80211_band band;
+	struct mwifiex_adapter *adapter = priv->adapter;
 
 	if (!priv->media_connected) {
-		dev_err(priv->adapter->dev,
+		dev_err(adapter->dev,
 			"Can not set Tx data rate in disconnected state\n");
 		return -EINVAL;
 	}
@@ -1181,9 +1182,16 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 
 	/* Fill HT MCS rates */
 	bitmap_rates[2] = mask->control[band].ht_mcs[0];
-	if (priv->adapter->hw_dev_mcs_support == HT_STREAM_2X2)
+	if (adapter->hw_dev_mcs_support == HT_STREAM_2X2)
 		bitmap_rates[2] |= mask->control[band].ht_mcs[1] << 8;
 
+       /* Fill VHT MCS rates */
+	if (adapter->fw_api_ver == MWIFIEX_FW_V15) {
+		bitmap_rates[10] = mask->control[band].vht_mcs[0];
+		if (adapter->hw_dev_mcs_support == HT_STREAM_2X2)
+			bitmap_rates[11] = mask->control[band].vht_mcs[1];
+	}
+
 	return mwifiex_send_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
 				HostCmd_ACT_GEN_SET, 0, bitmap_rates, true);
 }
-- 
1.8.2.3

