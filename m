Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbXFLDuf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 23:50:35 -0400
Subject: Re: Please pull libertas-2.6
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070611221325.GL10397@tuxdriver.com>
References: <1181102122.18061.8.camel@xo-28-0B-88.localdomain>
	 <1181396495.23205.0.camel@xo-28-0B-88.localdomain>
	 <20070611201222.GI10397@tuxdriver.com>
	 <1181597511.6131.2.camel@xo-28-0B-88.localdomain>
	 <20070611221325.GL10397@tuxdriver.com>
Content-Type: multipart/mixed; boundary="=-wQ5rKNKZSmd9UCWSKAwL"
Date: Mon, 11 Jun 2007 23:54:26 -0400
Message-Id: <1181620466.10328.66.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wQ5rKNKZSmd9UCWSKAwL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-06-11 at 18:13 -0400, John W. Linville wrote:
> On Mon, Jun 11, 2007 at 05:31:51PM -0400, Dan Williams wrote:
> > On Mon, 2007-06-11 at 16:12 -0400, John W. Linville wrote:
> 
> > > Jeff had expressed a willingness to accept the previous batch
> > > of libertas patches and pass them to Linus for 2.6.22.  However,
> > > judging by the titles above this patch looks more like clean-ups and
> > > new development.  Any objection to this batch being targeted at 2.6.23?
> > 
> > Some are pretty important (the 3 from Luis and the bottom 2 from me, and
> > the "anycast mask" patch from HEAD, for example).  I guess if Jeff
> > wouldn't mind accepting this set, I'd prefer to push them all for 2.6.22
> > and be be done with 2.6.22 except for bugfixes.  Otherwise I can give
> > you a list of commit IDs to cherry-pick or something like that.
> 
> Best if you sent me a cherry-pick list, I think...

6274aed3227aacb9527f394b8245381adafc1a04
bddb59e23e65a4cb11cfde88fee43d509b96b727
524ce9039aeb3dbe0a39badc3ae8218c81b5ab95
7ed8aab030afad1eda3ea7c844ecddd3ed528b2d

The last one will probably take a small bit of touch-up, but the top 3
apply as-is to the 'libertas' branch of wireless-2.6.  The last one just
needs some fixup to deal with my upper-casing of the mesh commands
before this commit, which wireless-2.6 doesn't have.  I attached my
cleanup of the last commit as a patch; I'm not entirely sure how git
will treat it when you cherry-pick it, but you can use the attached as a
quick guide if you like.  Ping me on devserv tomorrow or something if
you have any problems.

Thanks!
Dan


--=-wQ5rKNKZSmd9UCWSKAwL
Content-Disposition: attachment; filename=commit-d6a9720
Content-Type: text/plain; name=commit-d6a9720; charset=utf-8
Content-Transfer-Encoding: 7bit

commit d6a97206e38af6f987bf9318f8511c6ae7bda9af
Author: Dan Williams <dcbw@redhat.com>
Date:   Mon Jun 11 23:38:23 2007 -0400

    Merge 7ed8aab030afad1eda3ea7c844ecddd3ed528b2d

diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index cedf1db..7509cc1 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -310,8 +310,8 @@ enum cmd_mesh_access_opts {
 	cmd_act_mesh_get_ttl = 1,
 	cmd_act_mesh_set_ttl,
 	cmd_act_mesh_get_stats,
-	cmd_act_mesh_get_mpp,
-	cmd_act_mesh_set_mpp,
+	cmd_act_mesh_get_anycast,
+	cmd_act_mesh_set_anycast,
 };
 
 /** Card Event definition */
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 20ac7e1..623ab4b 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -178,45 +178,45 @@ u16 libertas_region_code_to_index[MRVDRV_MAX_REGION_CODE] =
  */
 
 /**
- * @brief Get function for sysfs attribute libertas_mpp
+ * @brief Get function for sysfs attribute anycast_mask
  */
-static ssize_t libertas_mpp_get(struct device * dev,
+static ssize_t libertas_anycast_get(struct device * dev,
 		struct device_attribute *attr, char * buf) {
 	struct cmd_ds_mesh_access mesh_access;
 
 	memset(&mesh_access, 0, sizeof(mesh_access));
 	libertas_prepare_and_send_command(to_net_dev(dev)->priv,
 			cmd_mesh_access,
-			cmd_act_mesh_get_mpp,
+			cmd_act_mesh_get_anycast,
 			cmd_option_waitforrsp, 0, (void *)&mesh_access);
 
-	return snprintf(buf, 3, "%d\n", le32_to_cpu(mesh_access.data[0]));
+	return snprintf(buf, 12, "0x%X\n", le32_to_cpu(mesh_access.data[0]));
 }
 
 /**
- * @brief Set function for sysfs attribute libertas_mpp
+ * @brief Set function for sysfs attribute anycast_mask
  */
-static ssize_t libertas_mpp_set(struct device * dev,
+static ssize_t libertas_anycast_set(struct device * dev,
 		struct device_attribute *attr, const char * buf, size_t count) {
 	struct cmd_ds_mesh_access mesh_access;
 	uint32_t datum;
 
 	memset(&mesh_access, 0, sizeof(mesh_access));
-	sscanf(buf, "%d", &datum);
+	sscanf(buf, "%x", &datum);
 	mesh_access.data[0] = cpu_to_le32(datum);
 
 	libertas_prepare_and_send_command((to_net_dev(dev))->priv,
 			cmd_mesh_access,
-			cmd_act_mesh_set_mpp,
+			cmd_act_mesh_set_anycast,
 			cmd_option_waitforrsp, 0, (void *)&mesh_access);
 	return strlen(buf);
 }
 
 /**
- * libertas_mpp attribute to be exported per mshX interface
- * through sysfs (/sys/class/net/mshX/libertas-mpp)
+ * anycast_mask attribute to be exported per mshX interface
+ * through sysfs (/sys/class/net/mshX/anycast_mask)
  */
-static DEVICE_ATTR(libertas_mpp, 0644, libertas_mpp_get, libertas_mpp_set );
+static DEVICE_ATTR(anycast_mask, 0644, libertas_anycast_get, libertas_anycast_set);
 
 /**
  *  @brief Check if the device can be open and wait if necessary.
@@ -939,7 +939,7 @@ int libertas_add_mesh(wlan_private *priv, struct device *dev)
 		goto err_free;
 	}
 
-	ret = device_create_file(&(mesh_dev->dev), &dev_attr_libertas_mpp);
+	ret = device_create_file(&(mesh_dev->dev), &dev_attr_anycast_mask);
 	if (ret)
 		goto err_unregister;
 
@@ -1049,7 +1049,7 @@ void libertas_remove_mesh(wlan_private *priv)
 	netif_stop_queue(mesh_dev);
 	netif_carrier_off(priv->mesh_dev);
 
-	device_remove_file(&(mesh_dev->dev), &dev_attr_libertas_mpp);
+	device_remove_file(&(mesh_dev->dev), &dev_attr_anycast_mask);
 	unregister_netdev(mesh_dev);
 
 	priv->mesh_dev = NULL ;

--=-wQ5rKNKZSmd9UCWSKAwL--

