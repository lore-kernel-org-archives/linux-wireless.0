Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:43378 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab1KCJyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 05:54:06 -0400
Subject: [PATCH] ath6kl: don't power down hardware when interface is down
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 Nov 2011 11:53:57 +0200
Message-ID: <20111103095357.10733.85983.stgit@localhost6.localdomain6> (sfid-20111103_105410_349290_5FEF77D9)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni reported that my patch "ath6kl: power down hardware when interface
is down" caused a regression on his x86 boxes and scan didn't work anymore.
I was able to reproduce the problem by disabling all debug messages.

So there has to be a race condition somewhere in the code and disable the
functionality until the race is fixed. Now hardware is powered from the
point where module is loaded until it's removed.

Reported-by: Jouni Malinen <jouni@qca.qualcomm.com>
Tested-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    6 ------
 drivers/net/wireless/ath/ath6kl/main.c |   12 ------------
 2 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 909e2e9..363fb3d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1612,12 +1612,6 @@ int ath6kl_core_init(struct ath6kl *ar)
 	 */
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
 
-	ret = ath6kl_init_hw_stop(ar);
-	if (ret) {
-		ath6kl_err("Failed to stop hardware: %d\n", ret);
-		goto err_htc_cleanup;
-	}
-
 	return ret;
 
 err_rxbuf_cleanup:
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index f9410e4..021b2f6 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1062,12 +1062,6 @@ struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar)
 static int ath6kl_open(struct net_device *dev)
 {
 	struct ath6kl_vif *vif = netdev_priv(dev);
-	int ret;
-
-	/* FIXME: how to handle multi vif support? */
-	ret = ath6kl_init_hw_start(vif->ar);
-	if (ret)
-		return ret;
 
 	set_bit(WLAN_ENABLED, &vif->flags);
 
@@ -1084,7 +1078,6 @@ static int ath6kl_close(struct net_device *dev)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
-	int ret;
 
 	netif_stop_queue(dev);
 
@@ -1099,11 +1092,6 @@ static int ath6kl_close(struct net_device *dev)
 
 	ath6kl_cfg80211_scan_complete_event(vif, true);
 
-	/* FIXME: how to handle multi vif support? */
-	ret = ath6kl_init_hw_stop(ar);
-	if (ret)
-		return ret;
-
 	clear_bit(WLAN_ENABLED, &vif->flags);
 
 	return 0;

