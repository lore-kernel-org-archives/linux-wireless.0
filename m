Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32690 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbXI3Sji (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:39:38 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 09/26] at76_usb: Remove commented out code for multicast  support
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:39:36 -0400
Message-ID: <20070930183936.23921.97223.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If anyone cares to implement it, it should be started anew.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   34 ----------------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 2a9dfb6..e39ca62 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -990,40 +990,6 @@ static int at76_add_mac_address(struct at76_priv *priv, void *addr)
 	return ret;
 }
 
-#if 0
-/* Implemented to get promisc. mode working, but does not help.
-   May still be useful for multicast eventually. */
-static int at76_set_group_address(struct at76_priv *priv, u8 *addr, int n)
-{
-	int ret = 0;
-
-	priv->mib_buf.type = MIB_MAC_ADDR;
-	priv->mib_buf.size = ETH_ALEN;
-	priv->mib_buf.index =
-	    offsetof(struct mib_mac_addr, group_addr) + n * ETH_ALEN;
-	memcpy(priv->mib_buf.data.addr, addr, ETH_ALEN);
-
-	ret = at76_set_mib(priv, &priv->mib_buf);
-	if (ret < 0)
-		printk(KERN_ERR "%s: cannot set group address: %d\n",
-		       priv->netdev->name, ret);
-
-	/* I do not know anything about the group_addr_status field... (oku) */
-	priv->mib_buf.type = MIB_MAC_ADDR;
-	priv->mib_buf.size = 1;
-	priv->mib_buf.index =
-	    offsetof(struct mib_mac_addr, group_addr_status) + n;
-	priv->mib_buf.data.byte = 1;
-
-	ret = at76_set_mib(priv, &priv->mib_buf);
-	if (ret < 0)
-		printk(KERN_ERR "%s: cannot set group address status: %d\n",
-		       priv->netdev->name, ret);
-
-	return ret;
-}
-#endif
-
 static void at76_dump_mib_mac_addr(struct at76_priv *priv)
 {
 	int i;
