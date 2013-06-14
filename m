Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.laptop.org ([18.85.2.166]:57590 "EHLO swan.laptop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab3FNT3L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 15:29:11 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com, bzhao@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mwifiex: fix memory corruption when unsetting multicast list
Message-Id: <20130614192424.9463CFAAC8@dev.laptop.org> (sfid-20130614_212914_879050_095BB740)
Date: Fri, 14 Jun 2013 15:24:24 -0400 (EDT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to unset a previously-set multicast list (i.e. the new list
has 0 entries), mwifiex_set_multicast_list() was calling down to
mwifiex_request_set_multicast_list() while leaving
mcast_list.num_multicast_addr as an uninitialized value.

We were arriving at mwifiex_cmd_mac_multicast_adr() which would then
proceed to do an often huge memcpy of
mcast_list.num_multicast_addr*ETH_ALEN bytes, causing memory corruption
and hard to debug crashes.

Fix this by setting mcast_list.num_multicast_addr to 0 when no multicast
list is provided. Similarly, fix up the logic in
mwifiex_request_set_multicast_list() to unset the multicast list that
was previously sent to the hardware in such cases.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/mwifiex/main.c      |  5 ++---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 18 ++++++++----------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 2eb88ea..4f5c37a 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -573,9 +573,8 @@ static void mwifiex_set_multicast_list(struct net_device *dev)
 		mcast_list.mode = MWIFIEX_ALL_MULTI_MODE;
 	} else {
 		mcast_list.mode = MWIFIEX_MULTICAST_MODE;
-		if (netdev_mc_count(dev))
-			mcast_list.num_multicast_addr =
-				mwifiex_copy_mcast_addr(&mcast_list, dev);
+		mcast_list.num_multicast_addr =
+			mwifiex_copy_mcast_addr(&mcast_list, dev);
 	}
 	mwifiex_request_set_multicast_list(priv, &mcast_list);
 }
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 1a8a19d..23aa910 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -104,16 +104,14 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 		} else {
 			priv->curr_pkt_filter &=
 				~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
-			if (mcast_list->num_multicast_addr) {
-				dev_dbg(priv->adapter->dev,
-					"info: Set multicast list=%d\n",
-				       mcast_list->num_multicast_addr);
-				/* Send multicast addresses to firmware */
-				ret = mwifiex_send_cmd_async(priv,
-					HostCmd_CMD_MAC_MULTICAST_ADR,
-					HostCmd_ACT_GEN_SET, 0,
-					mcast_list);
-			}
+			dev_dbg(priv->adapter->dev,
+				"info: Set multicast list=%d\n",
+				mcast_list->num_multicast_addr);
+			/* Send multicast addresses to firmware */
+			ret = mwifiex_send_cmd_async(priv,
+				HostCmd_CMD_MAC_MULTICAST_ADR,
+				HostCmd_ACT_GEN_SET, 0,
+				mcast_list);
 		}
 	}
 	dev_dbg(priv->adapter->dev,
-- 
1.8.1.4

