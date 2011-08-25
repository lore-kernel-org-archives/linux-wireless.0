Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:60622 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1HYDwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 23:52:25 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, Walter Harms <wharms@bfs.de>
Subject: [PATCH] mwifiex: replace kmalloc & memcpy sequences with kmemdup
Date: Wed, 24 Aug 2011 20:52:30 -0700
Message-Id: <1314244350-13347-1-git-send-email-bzhao@marvell.com> (sfid-20110825_055228_160026_B5A8D2B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Sequences of kmalloc/kzalloc and memcpy are replaced with
kmemdups.

Cc: Walter Harms <wharms@bfs.de>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c      |    5 ++---
 drivers/net/wireless/mwifiex/scan.c      |   17 ++++++++++-------
 drivers/net/wireless/mwifiex/sta_ioctl.c |    9 +++++----
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 5cdad92..303858e 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -147,13 +147,12 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv, u8 *rate1,
 	u8 *ptr = rate1, *tmp;
 	u32 i, j;
 
-	tmp = kmalloc(rate1_size, GFP_KERNEL);
+	tmp = kmemdup(rate1, rate1_size, GFP_KERNEL);
 	if (!tmp) {
-		dev_err(priv->adapter->dev, "failed to alloc tmp buf\n");
+		dev_err(priv->adapter->dev, "failed to duplicate rate buf\n");
 		return -ENOMEM;
 	}
 
-	memcpy(tmp, rate1, rate1_size);
 	memset(rate1, 0, rate1_size);
 
 	for (i = 0; rate2[i] && i < rate2_size; i++) {
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 37ca2f9..84cb059 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1479,12 +1479,12 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
 		dev_err(priv->adapter->dev, " failed to alloc bss_desc\n");
 		return -ENOMEM;
 	}
-	beacon_ie = kzalloc(ie_len, GFP_KERNEL);
+
+	beacon_ie = kmemdup(ie_buf, ie_len, GFP_KERNEL);
 	if (!beacon_ie) {
-		dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
+		dev_err(priv->adapter->dev, " failed to duplicate beacon_ie\n");
 		return -ENOMEM;
 	}
-	memcpy(beacon_ie, ie_buf, ie_len);
 
 	ret = mwifiex_fill_new_bss_desc(priv, bssid, rssi, beacon_ie,
 					ie_len, beacon_period,
@@ -1986,17 +1986,20 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 		priv->curr_bcn_size = curr_bss->beacon_buf_size;
 
 		kfree(priv->curr_bcn_buf);
-		priv->curr_bcn_buf = kzalloc(curr_bss->beacon_buf_size,
+
+		priv->curr_bcn_buf = kmemdup(curr_bss->beacon_buf,
+						curr_bss->beacon_buf_size,
 						GFP_KERNEL);
 		if (!priv->curr_bcn_buf) {
 			dev_err(priv->adapter->dev,
-					"failed to alloc curr_bcn_buf\n");
+					"failed to mem dup curr_bcn_buf\n");
 			return;
 		}
+	} else {
+		memcpy(priv->curr_bcn_buf, curr_bss->beacon_buf,
+			curr_bss->beacon_buf_size);
 	}
 
-	memcpy(priv->curr_bcn_buf, curr_bss->beacon_buf,
-		curr_bss->beacon_buf_size);
 	dev_dbg(priv->adapter->dev, "info: current beacon saved %d\n",
 		priv->curr_bcn_size);
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 3fca219..16b2363 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -199,13 +199,14 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 			dev_err(priv->adapter->dev, " failed to alloc bss_desc\n");
 			return -ENOMEM;
 		}
-		beacon_ie = kzalloc(bss->len_beacon_ies, GFP_KERNEL);
+
+		beacon_ie = kmemdup(bss->information_elements,
+					bss->len_beacon_ies, GFP_KERNEL);
 		if (!beacon_ie) {
-			dev_err(priv->adapter->dev, " failed to alloc bss_desc\n");
+			dev_err(priv->adapter->dev, "failed to memdup IEs\n");
 			return -ENOMEM;
 		}
-		memcpy(beacon_ie, bss->information_elements,
-		       bss->len_beacon_ies);
+
 		ret = mwifiex_fill_new_bss_desc(priv, bss->bssid, bss->signal,
 						beacon_ie, bss->len_beacon_ies,
 						bss->beacon_interval,
-- 
1.7.0.2

