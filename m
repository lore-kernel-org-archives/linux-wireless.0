Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33441 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934884Ab1JEV7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 17:59:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] mwifiex: fix smatch errors
Date: Wed,  5 Oct 2011 14:58:24 -0700
Message-Id: <1317851904-26004-1-git-send-email-bzhao@marvell.com> (sfid-20111005_235916_168456_C9B8A05B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

drivers/net/wireless/mwifiex/main.c +828 mwifiex_remove_card(52)
  error: potential null derefence 'priv'.
drivers/net/wireless/mwifiex/main.c +828 mwifiex_remove_card(52)
  error: we previously assumed 'priv' could be null (see line 820)
drivers/net/wireless/mwifiex/txrx.c +90 mwifiex_process_tx(24)
  error: potential null derefence 'local_tx_pd'.
drivers/net/wireless/mwifiex/sta_ioctl.c +766
mwifiex_rate_ioctl_set_rate_value(30)
  error: buffer overflow 'rate' 14 <= 14

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c      |    4 ++++
 drivers/net/wireless/mwifiex/sta_ioctl.c |    2 +-
 drivers/net/wireless/mwifiex/txrx.c      |    3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 8486451..277ea84 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -825,6 +825,10 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 		rtnl_unlock();
 	}
 
+	priv = adapter->priv[0];
+	if (!priv)
+		goto exit_remove;
+
 	wiphy_unregister(priv->wdev->wiphy);
 	wiphy_free(priv->wdev->wiphy);
 	kfree(priv->wdev);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 520800b..f20550a 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -763,7 +763,7 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 			if ((rate[i] & 0x7f) == (rate_cfg->rate & 0x7f))
 				break;
 		}
-		if (!rate[i] || (i == MWIFIEX_SUPPORTED_RATES)) {
+		if ((i == MWIFIEX_SUPPORTED_RATES) || !rate[i]) {
 			dev_err(adapter->dev, "fixed data rate %#x is out "
 			       "of range\n", rate_cfg->rate);
 			return -1;
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 6190b2f..5d95c4b 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -87,7 +87,8 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 			(adapter->pps_uapsd_mode) &&
 			(adapter->tx_lock_flag)) {
 				priv->adapter->tx_lock_flag = false;
-				local_tx_pd->flags = 0;
+				if (local_tx_pd)
+					local_tx_pd->flags = 0;
 		}
 		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
 		break;
-- 
1.7.0.2

