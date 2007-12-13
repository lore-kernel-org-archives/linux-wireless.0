Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762750AbXLMG7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:42 -0500
Subject: [PATCH 76/48] libertas: kill references to mesh autostart
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2y-0005t8-QZ@shinybook.infradead.org> (sfid-20071213_070005_791054_42DDE663)
Date: Thu, 13 Dec 2007 01:59:52 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 18:57:49 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |   21 ------------
 drivers/net/wireless/libertas/main.c   |   54 --------------------------------
 2 files changed, 0 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 351c7ea..b19a6c9 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -978,17 +978,6 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	if (priv->psstate != PS_STATE_FULL_POWER)
 		return -1;
 
-	if (priv->mesh_dev && !priv->mesh_autostart_enabled) {
-		/* Mesh autostart must be activated while sleeping
-		 * On resume it will go back to the current state
-		 */
-		struct cmd_ds_mesh_access mesh_access;
-		memset(&mesh_access, 0, sizeof(mesh_access));
-
-		mesh_access.data[0] = cpu_to_le32(1);
-		lbs_mesh_access(priv, CMD_ACT_MESH_SET_AUTOSTART_ENABLED, &mesh_access);
-	}
-
 	netif_device_detach(cardp->eth_dev);
 	netif_device_detach(priv->mesh_dev);
 
@@ -1016,16 +1005,6 @@ static int if_usb_resume(struct usb_interface *intf)
 	netif_device_attach(cardp->eth_dev);
 	netif_device_attach(priv->mesh_dev);
 
-	if (priv->mesh_dev && !priv->mesh_autostart_enabled) {
-		/* Mesh autostart was activated while sleeping
-		 * Disable it if appropriate
-		 */
-		struct cmd_ds_mesh_access mesh_access;
-		memset(&mesh_access, 0, sizeof(mesh_access));
-		mesh_access.data[0] = cpu_to_le32(0);
-		lbs_mesh_access(priv, CMD_ACT_MESH_SET_AUTOSTART_ENABLED, &mesh_access);
-	}
-
 	lbs_deb_leave(LBS_DEB_USB);
 	return 0;
 }
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index fd76c46..bb685ac 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -369,46 +369,8 @@ static DEVICE_ATTR(lbs_mesh, 0644, lbs_mesh_get, lbs_mesh_set);
  */
 static DEVICE_ATTR(anycast_mask, 0644, lbs_anycast_get, lbs_anycast_set);
 
-static ssize_t lbs_autostart_enabled_get(struct device *dev,
-		struct device_attribute *attr, char * buf)
-{
-	struct lbs_private *priv = to_net_dev(dev)->priv;
-	struct cmd_ds_mesh_access mesh_access;
-	int ret;
-
-	memset(&mesh_access, 0, sizeof(mesh_access));
-
-	ret = lbs_mesh_access(priv, CMD_ACT_MESH_GET_AUTOSTART_ENABLED, &mesh_access);
-	if (ret)
-		return ret;
-	return sprintf(buf, "%d\n", le32_to_cpu(mesh_access.data[0]));
-}
-
-static ssize_t lbs_autostart_enabled_set(struct device *dev,
-		struct device_attribute *attr, const char * buf, size_t count)
-{
-	struct cmd_ds_mesh_access mesh_access;
-	uint32_t datum;
-	struct lbs_private *priv = (to_net_dev(dev))->priv;
-	int ret;
-
-	memset(&mesh_access, 0, sizeof(mesh_access));
-	sscanf(buf, "%d", &datum);
-	mesh_access.data[0] = cpu_to_le32(datum);
-
-	ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_AUTOSTART_ENABLED, &mesh_access);
-	if (ret == 0)
-		priv->mesh_autostart_enabled = datum ? 1 : 0;
-
-	return strlen(buf);
-}
-
-static DEVICE_ATTR(autostart_enabled, 0644,
-		lbs_autostart_enabled_get, lbs_autostart_enabled_set);
-
 static struct attribute *lbs_mesh_sysfs_entries[] = {
 	&dev_attr_anycast_mask.attr,
-	&dev_attr_autostart_enabled.attr,
 	NULL,
 };
 
@@ -883,7 +845,6 @@ static int lbs_thread(void *data)
 static int lbs_setup_firmware(struct lbs_private *priv)
 {
 	int ret = -1;
-	struct cmd_ds_mesh_access mesh_access;
 
 	lbs_deb_enter(LBS_DEB_FW);
 
@@ -905,21 +866,6 @@ static int lbs_setup_firmware(struct lbs_private *priv)
 		goto done;
 	}
 
-	/* Disable mesh autostart */
-	if (priv->mesh_dev) {
-		memset(&mesh_access, 0, sizeof(mesh_access));
-		mesh_access.data[0] = cpu_to_le32(0);
-		ret = lbs_mesh_access(priv, CMD_ACT_MESH_SET_AUTOSTART_ENABLED,
-				      &mesh_access);
-		if (ret) {
-			printk("Mesh autostart set failed\n");
-			ret = 0;
-			//ret = -1;
-			goto done;
-		}
-		priv->mesh_autostart_enabled = 0;
-	}
-
 	ret = 0;
 done:
 	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
-- 
1.5.3.4

