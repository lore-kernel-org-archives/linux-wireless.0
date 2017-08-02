Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39447 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751991AbdHBUIV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 16:08:21 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: replace netif_carrier_on/off by netif_device_attach/dettach
Date: Thu, 3 Aug 2017 01:34:46 +0530
Message-ID: <1501704286-3908-1-git-send-email-gbhat@marvell.com> (sfid-20170802_220825_016825_1C004670)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver is doing netif_carrier_off during suspend, which will set
the IFF_LOWER_UP flag to 0. As a result certain applications
will think this as a real carrier down and behave accordingly.
This will cause issues like loss of IP address, for example. To
fix this use netif_device_dettach during suspend.

Fixes: 0026b32d723e ('mwifiex: fix Tx timeout issue during suspend test')

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 2be7817..83605a2 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3391,11 +3391,8 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
-		if (priv && priv->netdev) {
-			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
-			if (netif_carrier_ok(priv->netdev))
-				netif_carrier_off(priv->netdev);
-		}
+		if (priv && priv->netdev)
+			netif_device_detach(priv->netdev);
 	}
 
 	for (i = 0; i < retry_num; i++) {
@@ -3466,11 +3463,8 @@ static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
-		if (priv && priv->netdev) {
-			if (!netif_carrier_ok(priv->netdev))
-				netif_carrier_on(priv->netdev);
-			mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
-		}
+		if (priv && priv->netdev)
+			netif_device_attach(priv->netdev);
 	}
 
 	if (!wiphy->wowlan_config)
-- 
1.9.1
