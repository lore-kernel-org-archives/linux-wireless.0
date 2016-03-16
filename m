Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59906 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964900AbcCPOvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 10:51:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u2GEg2CN026333
	for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 07:51:23 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 21mkgn4xde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 07:51:22 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: fix Tx timeout issue during suspend test
Date: Wed, 16 Mar 2016 07:46:16 -0700
Message-ID: <1458139576-4702-1-git-send-email-akarwar@marvell.com> (sfid-20160316_155127_618344_B0439665)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Call netif_carrier_off/on while stoping/starting netdev queues.
This fixes netdev watchdog warning and ->ndo_tx_timeout() invocation
during suspend resume stress test.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Fixes: 54f008497b9f09f ('mwifiex: Empty Tx queue during suspend')
Tested-by: Wei-Ning Huang <wnhuang@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index bb7235e..b0663bd 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3272,8 +3272,11 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
-		if (priv && priv->netdev)
+		if (priv && priv->netdev) {
 			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+			if (netif_carrier_ok(priv->netdev))
+				netif_carrier_off(priv->netdev);
+		}
 	}
 
 	for (i = 0; i < retry_num; i++) {
@@ -3344,8 +3347,11 @@ static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
-		if (priv && priv->netdev)
+		if (priv && priv->netdev) {
+			if (!netif_carrier_ok(priv->netdev))
+				netif_carrier_on(priv->netdev);
 			mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
+		}
 	}
 
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
-- 
1.8.1.4

