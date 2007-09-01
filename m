Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61850 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbXIAEgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:36:44 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 9E567618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:36:43 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 26/35] Improve dump of MAC_ADDR
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:36:43 -0400
Message-ID: <20070901043643.2498.81365.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't require DEBUG to be defined.  Dump each group address separately,
next to the status.  Rename MIB_MAC_ADD to MIB_MAC_ADDR.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   34 ++++++++++++++++++----------------
 drivers/net/wireless/at76_usb.h |    2 +-
 2 files changed, 19 insertions(+), 17 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index b586522..e469d66 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -979,7 +979,7 @@ static int at76_add_mac_address(struct at76_priv *priv, void *addr)
 	int ret = 0;
 
 	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
-	priv->mib_buf.type = MIB_MAC_ADD;
+	priv->mib_buf.type = MIB_MAC_ADDR;
 	priv->mib_buf.size = ETH_ALEN;
 	priv->mib_buf.index = offsetof(struct mib_mac_addr, mac_addr);
 	memcpy(priv->mib_buf.data, addr, ETH_ALEN);
@@ -999,26 +999,26 @@ static int at76_set_group_address(struct at76_priv *priv, u8 *addr, int n)
 	int ret = 0;
 
 	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
-	priv->mib_buf.type = MIB_MAC_ADD;
+	priv->mib_buf.type = MIB_MAC_ADDR;
 	priv->mib_buf.size = ETH_ALEN;
 	priv->mib_buf.index =
 	    offsetof(struct mib_mac_addr, group_addr) + n * ETH_ALEN;
 	memcpy(priv->mib_buf.data, addr, ETH_ALEN);
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (MIB_MAC_ADD, group_addr) failed: %d",
+		err("%s: set_mib (MIB_MAC_ADDR, group_addr) failed: %d",
 		    priv->netdev->name, ret);
 
 	/* I do not know anything about the group_addr_status field... (oku) */
 	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
-	priv->mib_buf.type = MIB_MAC_ADD;
+	priv->mib_buf.type = MIB_MAC_ADDR;
 	priv->mib_buf.size = 1;
 	priv->mib_buf.index =
 	    offsetof(struct mib_mac_addr, group_addr_status) + n;
 	priv->mib_buf.data[0] = 1;
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (MIB_MAC_ADD, group_addr_status) failed: %d",
+		err("%s: set_mib (MIB_MAC_ADDR, group_addr_status) failed: %d",
 		    priv->netdev->name, ret);
 
 	return ret;
@@ -1027,32 +1027,34 @@ static int at76_set_group_address(struct at76_priv *priv, u8 *addr, int n)
 
 static int at76_dump_mib_mac_addr(struct at76_priv *priv)
 {
+	int i;
 	int ret = 0;
-	struct mib_mac_addr *mac_addr =
+	struct mib_mac_addr *m =
 	    kmalloc(sizeof(struct mib_mac_addr), GFP_KERNEL);
 
-	if (!mac_addr) {
+	if (!m) {
 		ret = -ENOMEM;
 		goto exit;
 	}
 
-	ret = at76_get_mib(priv->udev, MIB_MAC_ADD,
-			   mac_addr, sizeof(struct mib_mac_addr));
+	ret = at76_get_mib(priv->udev, MIB_MAC_ADDR,
+			   m, sizeof(struct mib_mac_addr));
 	if (ret < 0) {
 		err("%s: at76_get_mib (MAC_ADDR) failed: %d",
 		    priv->netdev->name, ret);
 		goto error;
 	}
 
-	dbg("%s: MIB MAC_ADDR: mac_addr %s res 0x%x 0x%x group_addr %s status "
-	    "%d %d %d %d", priv->netdev->name, mac2str(mac_addr->mac_addr),
-	    mac_addr->res[0], mac_addr->res[1],
-	    hex2str(mac_addr->group_addr, 4 * ETH_ALEN),
-	    mac_addr->group_addr_status[0], mac_addr->group_addr_status[1],
-	    mac_addr->group_addr_status[2], mac_addr->group_addr_status[3]);
+	at76_dbg(DBG_MIB, "%s: MIB MAC_ADDR: mac_addr %s res 0x%x 0x%x",
+		 priv->netdev->name,
+		 mac2str(m->mac_addr), m->res[0], m->res[1]);
+	for (i = 0; i < ARRAY_SIZE(m->group_addr); i++)
+		at76_dbg(DBG_MIB, "%s: MIB MAC_ADDR: group addr %d: %s, "
+			 "status %d", priv->netdev->name, i,
+			 mac2str(m->group_addr[i]), m->group_addr_status[i]);
 
 error:
-	kfree(mac_addr);
+	kfree(m);
 exit:
 	return ret;
 }
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 6c4ebf2..65f56c7 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -86,7 +86,7 @@ enum board_type {
 #define CMD_GETOPMODE		0x33
 
 #define MIB_LOCAL		0x01
-#define MIB_MAC_ADD		0x02
+#define MIB_MAC_ADDR		0x02
 #define MIB_MAC			0x03
 #define MIB_MAC_MGMT		0x05
 #define MIB_MAC_WEP		0x06
