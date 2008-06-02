Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:32768 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYFBPn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 11:43:29 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/4] rndis_wlan: cleanup: rename and remove local pointers
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Mon, 02 Jun 2008 18:35:44 +0300
Message-ID: <20080602153544.22793.56932.stgit@nanoha.lan> (sfid-20080602_174341_631003_0F1D7CA9)
In-Reply-To: <20080602153521.22793.4271.stgit@nanoha.lan>
References: <20080602153521.22793.4271.stgit@nanoha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mixed use of 'dev' and 'usbdev' for usbnet pointer can be confusing. So changing all 'usbnet *dev' to 'usbnet *usbdev'.

Also remove 'net_device *net' pointer from 'rndis_wext_bind' as 'usbdev->net' were already used where needed.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   74 +++++++++++++++++++------------------
 1 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index ad46a0b..8505d8b 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2279,9 +2279,9 @@ static void rndis_wext_set_multicast_list(struct net_device *dev)
 	queue_work(priv->workqueue, &priv->work);
 }
 
-static void rndis_wext_link_change(struct usbnet *dev, int state)
+static void rndis_wext_link_change(struct usbnet *usbdev, int state)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(dev);
+	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 
 	/* queue work to avoid recursive calls into rndis_command */
 	set_bit(state ? WORK_LINK_UP : WORK_LINK_DOWN, &priv->work_pending);
@@ -2289,7 +2289,7 @@ static void rndis_wext_link_change(struct usbnet *dev, int state)
 }
 
 
-static int rndis_wext_get_caps(struct usbnet *dev)
+static int rndis_wext_get_caps(struct usbnet *usbdev)
 {
 	struct {
 		__le32	num_items;
@@ -2297,18 +2297,18 @@ static int rndis_wext_get_caps(struct usbnet *dev)
 	} networks_supported;
 	int len, retval, i, n;
 	__le32 tx_power;
-	struct rndis_wext_private *priv = get_rndis_wext_priv(dev);
+	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 
 	/* determine if supports setting txpower */
 	len = sizeof(tx_power);
-	retval = rndis_query_oid(dev, OID_802_11_TX_POWER_LEVEL, &tx_power,
-								&len);
+	retval = rndis_query_oid(usbdev, OID_802_11_TX_POWER_LEVEL, &tx_power,
+									&len);
 	if (retval == 0 && le32_to_cpu(tx_power) != 0xFF)
 		priv->caps |= CAP_SUPPORT_TXPOWER;
 
 	/* determine supported modes */
 	len = sizeof(networks_supported);
-	retval = rndis_query_oid(dev, OID_802_11_NETWORK_TYPES_SUPPORTED,
+	retval = rndis_query_oid(usbdev, OID_802_11_NETWORK_TYPES_SUPPORTED,
 						&networks_supported, &len);
 	if (retval >= 0) {
 		n = le32_to_cpu(networks_supported.num_items);
@@ -2447,9 +2447,9 @@ end:
 }
 
 
-static int bcm4320_early_init(struct usbnet *dev)
+static int bcm4320_early_init(struct usbnet *usbdev)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(dev);
+	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 	char buf[8];
 
 	/* Early initialization settings, setting these won't have effect
@@ -2497,27 +2497,26 @@ static int bcm4320_early_init(struct usbnet *dev)
 	else
 		priv->param_workaround_interval = modparam_workaround_interval;
 
-	rndis_set_config_parameter_str(dev, "Country", priv->param_country);
-	rndis_set_config_parameter_str(dev, "FrameBursting",
+	rndis_set_config_parameter_str(usbdev, "Country", priv->param_country);
+	rndis_set_config_parameter_str(usbdev, "FrameBursting",
 					priv->param_frameburst ? "1" : "0");
-	rndis_set_config_parameter_str(dev, "Afterburner",
+	rndis_set_config_parameter_str(usbdev, "Afterburner",
 					priv->param_afterburner ? "1" : "0");
 	sprintf(buf, "%d", priv->param_power_save);
-	rndis_set_config_parameter_str(dev, "PowerSaveMode", buf);
+	rndis_set_config_parameter_str(usbdev, "PowerSaveMode", buf);
 	sprintf(buf, "%d", priv->param_power_output);
-	rndis_set_config_parameter_str(dev, "PwrOut", buf);
+	rndis_set_config_parameter_str(usbdev, "PwrOut", buf);
 	sprintf(buf, "%d", priv->param_roamtrigger);
-	rndis_set_config_parameter_str(dev, "RoamTrigger", buf);
+	rndis_set_config_parameter_str(usbdev, "RoamTrigger", buf);
 	sprintf(buf, "%d", priv->param_roamdelta);
-	rndis_set_config_parameter_str(dev, "RoamDelta", buf);
+	rndis_set_config_parameter_str(usbdev, "RoamDelta", buf);
 
 	return 0;
 }
 
 
-static int rndis_wext_bind(struct usbnet *dev, struct usb_interface *intf)
+static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 {
-	struct net_device *net = dev->net;
 	struct rndis_wext_private *priv;
 	int retval, len;
 	__le32 tmp;
@@ -2530,18 +2529,18 @@ static int rndis_wext_bind(struct usbnet *dev, struct usb_interface *intf)
 	/* These have to be initialized before calling generic_rndis_bind().
 	 * Otherwise we'll be in big trouble in rndis_wext_early_init().
 	 */
-	dev->driver_priv = priv;
+	usbdev->driver_priv = priv;
 	memset(priv, 0, sizeof(*priv));
 	memset(priv->name, 0, sizeof(priv->name));
 	strcpy(priv->name, "IEEE802.11");
-	net->wireless_handlers = &rndis_iw_handlers;
-	priv->usbdev = dev;
+	usbdev->net->wireless_handlers = &rndis_iw_handlers;
+	priv->usbdev = usbdev;
 
 	mutex_init(&priv->command_lock);
 	spin_lock_init(&priv->stats_lock);
 
 	/* try bind rndis_host */
-	retval = generic_rndis_bind(dev, intf, FLAG_RNDIS_PHYM_WIRELESS);
+	retval = generic_rndis_bind(usbdev, intf, FLAG_RNDIS_PHYM_WIRELESS);
 	if (retval < 0)
 		goto fail;
 
@@ -2552,20 +2551,21 @@ static int rndis_wext_bind(struct usbnet *dev, struct usb_interface *intf)
 	 * rndis_host wants to avoid all OID as much as possible
 	 * so do promisc/multicast handling in rndis_wext.
 	 */
-	dev->net->set_multicast_list = rndis_wext_set_multicast_list;
+	usbdev->net->set_multicast_list = rndis_wext_set_multicast_list;
 	tmp = RNDIS_PACKET_TYPE_DIRECTED | RNDIS_PACKET_TYPE_BROADCAST;
-	retval = rndis_set_oid(dev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
+	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
 								sizeof(tmp));
 
 	len = sizeof(tmp);
-	retval = rndis_query_oid(dev, OID_802_3_MAXIMUM_LIST_SIZE, &tmp, &len);
+	retval = rndis_query_oid(usbdev, OID_802_3_MAXIMUM_LIST_SIZE, &tmp,
+								&len);
 	priv->multicast_size = le32_to_cpu(tmp);
 	if (retval < 0 || priv->multicast_size < 0)
 		priv->multicast_size = 0;
 	if (priv->multicast_size > 0)
-		dev->net->flags |= IFF_MULTICAST;
+		usbdev->net->flags |= IFF_MULTICAST;
 	else
-		dev->net->flags &= ~IFF_MULTICAST;
+		usbdev->net->flags &= ~IFF_MULTICAST;
 
 	priv->iwstats.qual.qual = 0;
 	priv->iwstats.qual.level = 0;
@@ -2575,13 +2575,13 @@ static int rndis_wext_bind(struct usbnet *dev, struct usb_interface *intf)
 					| IW_QUAL_QUAL_INVALID
 					| IW_QUAL_LEVEL_INVALID;
 
-	rndis_wext_get_caps(dev);
-	set_default_iw_params(dev);
+	rndis_wext_get_caps(usbdev);
+	set_default_iw_params(usbdev);
 
 	/* turn radio on */
 	priv->radio_on = 1;
-	disassociate(dev, 1);
-	netif_carrier_off(dev->net);
+	disassociate(usbdev, 1);
+	netif_carrier_off(usbdev->net);
 
 	/* because rndis_command() sleeps we need to use workqueue */
 	priv->workqueue = create_singlethread_workqueue("rndis_wlan");
@@ -2598,12 +2598,12 @@ fail:
 }
 
 
-static void rndis_wext_unbind(struct usbnet *dev, struct usb_interface *intf)
+static void rndis_wext_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 {
-	struct rndis_wext_private *priv = get_rndis_wext_priv(dev);
+	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 
 	/* turn radio off */
-	disassociate(dev, 0);
+	disassociate(usbdev, 0);
 
 	cancel_delayed_work_sync(&priv->stats_work);
 	cancel_work_sync(&priv->work);
@@ -2614,13 +2614,13 @@ static void rndis_wext_unbind(struct usbnet *dev, struct usb_interface *intf)
 		kfree(priv->wpa_ie);
 	kfree(priv);
 
-	rndis_unbind(dev, intf);
+	rndis_unbind(usbdev, intf);
 }
 
 
-static int rndis_wext_reset(struct usbnet *dev)
+static int rndis_wext_reset(struct usbnet *usbdev)
 {
-	return deauthenticate(dev);
+	return deauthenticate(usbdev);
 }
 
 

