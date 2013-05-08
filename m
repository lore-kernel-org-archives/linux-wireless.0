Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.laptop.org ([18.85.2.166]:54643 "EHLO swan.laptop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab3EHTn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 15:43:56 -0400
From: Daniel Drake <dsd@laptop.org>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mwifiex: fix setting of multicast filter
Message-Id: <20130508193719.BC51FFA9CF@dev.laptop.org> (sfid-20130508_214400_122956_259B810C)
Date: Wed,  8 May 2013 15:37:19 -0400 (EDT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A small bug in this code was causing the ALLMULTI filter to be set
when in fact we were just wanting to program a selective multicast list
to the hardware.

Fix that bug and remove a redundant if condition in the code that
follows.

This fixes wakeup behaviour when multicast WOL is enabled. Previously,
all multicast packets would wake up the system. Now, only those that the
host intended to receive trigger wakeups.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 311d0b2..1a8a19d 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -96,7 +96,7 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 	} else {
 		/* Multicast */
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
-		if (mcast_list->mode == MWIFIEX_MULTICAST_MODE) {
+		if (mcast_list->mode == MWIFIEX_ALL_MULTI_MODE) {
 			dev_dbg(priv->adapter->dev,
 				"info: Enabling All Multicast!\n");
 			priv->curr_pkt_filter |=
@@ -108,20 +108,11 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 				dev_dbg(priv->adapter->dev,
 					"info: Set multicast list=%d\n",
 				       mcast_list->num_multicast_addr);
-				/* Set multicast addresses to firmware */
-				if (old_pkt_filter == priv->curr_pkt_filter) {
-					/* Send request to firmware */
-					ret = mwifiex_send_cmd_async(priv,
-						HostCmd_CMD_MAC_MULTICAST_ADR,
-						HostCmd_ACT_GEN_SET, 0,
-						mcast_list);
-				} else {
-					/* Send request to firmware */
-					ret = mwifiex_send_cmd_async(priv,
-						HostCmd_CMD_MAC_MULTICAST_ADR,
-						HostCmd_ACT_GEN_SET, 0,
-						mcast_list);
-				}
+				/* Send multicast addresses to firmware */
+				ret = mwifiex_send_cmd_async(priv,
+					HostCmd_CMD_MAC_MULTICAST_ADR,
+					HostCmd_ACT_GEN_SET, 0,
+					mcast_list);
 			}
 		}
 	}
-- 
1.8.1.4

