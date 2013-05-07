Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:45543 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758590Ab3EGCvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 22:51:20 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	Tim Shepard <shep@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.10] mwifiex: fix memory leak issue when driver unload
Date: Mon, 6 May 2013 19:46:54 -0700
Message-ID: <1367894814-6677-2-git-send-email-bzhao@marvell.com> (sfid-20130507_045123_930474_49267029)
In-Reply-To: <1367894814-6677-1-git-send-email-bzhao@marvell.com>
References: <1367894814-6677-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

After unregister_netdevice() call the request is queued and
reg_state is changed to NETREG_UNREGISTERING.
As we check for NETREG_UNREGISTERED state, free_netdev() never
gets executed causing memory leak.

Initialize "dev->destructor" to free_netdev() to free device
data after unregistration.

Cc: <stable@vger.kernel.org>
Reported-by: Daniel Drake <dsd@laptop.org>
Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    3 ---
 drivers/net/wireless/mwifiex/main.c     |    1 +
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index a0cb077..636145d 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2234,9 +2234,6 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	if (wdev->netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdevice(wdev->netdev);
 
-	if (wdev->netdev->reg_state == NETREG_UNREGISTERED)
-		free_netdev(wdev->netdev);
-
 	/* Clear the priv in adapter */
 	priv->netdev = NULL;
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 121443a..2eb88ea 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -655,6 +655,7 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 						struct net_device *dev)
 {
 	dev->netdev_ops = &mwifiex_netdev_ops;
+	dev->destructor = free_netdev;
 	/* Initialize private structure */
 	priv->current_key_index = 0;
 	priv->media_connected = false;
-- 
1.7.0.2

