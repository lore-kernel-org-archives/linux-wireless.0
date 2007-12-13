Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56003 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762413AbXLMHAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 02:00:09 -0500
Subject: [PATCH 92/48] libertas: add ethtool support for wake-on-lan configuration
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i3K-0005uX-2j@shinybook.infradead.org> (sfid-20071213_070626_151238_0F2D593C)
Date: Thu, 13 Dec 2007 02:00:14 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 12 Dec 2007 20:06:06 -0500

Also, check that suspend is refused if HOST_SLEEP_CFG hasn't been done.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   14 +++++----
 drivers/net/wireless/libertas/cmd.h     |    3 +-
 drivers/net/wireless/libertas/dev.h     |    5 +++
 drivers/net/wireless/libertas/ethtool.c |   47 +++++++++++++++++++++++++++++++
 drivers/net/wireless/libertas/if_usb.c  |    6 ++--
 drivers/net/wireless/libertas/main.c    |    8 +++++
 6 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index f87cecb..ddf1527 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -111,21 +111,23 @@ out:
 	return ret;
 }
 
-int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
-		       uint8_t gpio, uint8_t gap)
+int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria)
 {
 	struct cmd_ds_host_sleep cmd_config;
 	int ret;
 
 	cmd_config.criteria = cpu_to_le32(criteria);
-	cmd_config.gpio = gpio;
-	cmd_config.gap = gap;
+	cmd_config.gpio = priv->wol_gpio;
+	cmd_config.gap = priv->wol_gap;
 
 	ret = lbs_cmd_with_response(priv, CMD_802_11_HOST_SLEEP_CFG, &cmd_config);
-	if (ret) {
+	if (!ret) {
+		lbs_deb_cmd("Set WOL criteria to %x\n", criteria);
+		priv->wol_criteria = criteria;
+	} else {
 		lbs_pr_info("HOST_SLEEP_CFG failed %d\n", ret);
-		return ret;
 	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(lbs_host_sleep_cfg);
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index e44a0db..55f2436 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -33,8 +33,7 @@ int lbs_set_channel(struct lbs_private *priv, u8 channel);
 
 int lbs_mesh_config(struct lbs_private *priv, int enable);
 
-int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
-		       uint8_t gpio, uint8_t gap);
+int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria);
 int lbs_suspend(struct lbs_private *priv);
 int lbs_resume(struct lbs_private *priv);
 
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 86b45a4..60a6a51 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -153,6 +153,11 @@ struct lbs_private {
 	int (*hw_get_int_status) (struct lbs_private *priv, u8 *);
 	int (*hw_read_event_cause) (struct lbs_private *);
 
+	/* Wake On LAN */
+	uint32_t wol_criteria;
+	uint8_t wol_gpio;
+	uint8_t wol_gap;
+
 	/* was struct lbs_adapter from here... */
 
 	/** Wlan adapter data structure*/
diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index a54b4f4..21e6f98 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -8,6 +8,8 @@
 #include "dev.h"
 #include "join.h"
 #include "wext.h"
+#include "cmd.h"
+
 static const char * mesh_stat_strings[]= {
 			"drop_duplicate_bcast",
 			"drop_ttl_zero",
@@ -172,6 +174,49 @@ static void lbs_ethtool_get_strings(struct net_device *dev,
 	lbs_deb_enter(LBS_DEB_ETHTOOL);
 }
 
+static void lbs_ethtool_get_wol(struct net_device *dev,
+				struct ethtool_wolinfo *wol)
+{
+	struct lbs_private *priv = dev->priv;
+
+	if (priv->wol_criteria == 0xffffffff) {
+		/* Interface driver didn't configure wake */
+		wol->supported = wol->wolopts = 0;
+		return;
+	}
+
+	wol->supported = WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY;
+
+	if (priv->wol_criteria & EHS_WAKE_ON_UNICAST_DATA)
+		wol->wolopts |= WAKE_UCAST;
+	if (priv->wol_criteria & EHS_WAKE_ON_MULTICAST_DATA)
+		wol->wolopts |= WAKE_MCAST;
+	if (priv->wol_criteria & EHS_WAKE_ON_BROADCAST_DATA)
+		wol->wolopts |= WAKE_BCAST;
+	if (priv->wol_criteria & EHS_WAKE_ON_MAC_EVENT)
+		wol->wolopts |= WAKE_PHY;
+}
+
+static int lbs_ethtool_set_wol(struct net_device *dev,
+			       struct ethtool_wolinfo *wol)
+{
+	struct lbs_private *priv = dev->priv;
+	uint32_t criteria = 0;
+
+	if (priv->wol_criteria == 0xffffffff && wol->wolopts)
+		return -EOPNOTSUPP;
+
+	if (wol->wolopts & ~(WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY))
+		return -EOPNOTSUPP;
+
+	if (wol->wolopts & WAKE_UCAST) criteria |= EHS_WAKE_ON_UNICAST_DATA;
+	if (wol->wolopts & WAKE_MCAST) criteria |= EHS_WAKE_ON_MULTICAST_DATA;
+	if (wol->wolopts & WAKE_BCAST) criteria |= EHS_WAKE_ON_BROADCAST_DATA;
+	if (wol->wolopts & WAKE_PHY)   criteria |= EHS_WAKE_ON_MAC_EVENT;
+
+	return lbs_host_sleep_cfg(priv, criteria);
+}
+
 struct ethtool_ops lbs_ethtool_ops = {
 	.get_drvinfo = lbs_ethtool_get_drvinfo,
 	.get_eeprom =  lbs_ethtool_get_eeprom,
@@ -179,5 +224,7 @@ struct ethtool_ops lbs_ethtool_ops = {
 	.get_sset_count = lbs_ethtool_get_sset_count,
 	.get_ethtool_stats = lbs_ethtool_get_stats,
 	.get_strings = lbs_ethtool_get_strings,
+	.get_wol = lbs_ethtool_get_wol,
+	.set_wol = lbs_ethtool_set_wol,
 };
 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 15715a6..8191416 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -242,9 +242,9 @@ static int if_usb_probe(struct usb_interface *intf,
 
 	if_usb_set_boot2_ver(priv);
 
-	/* Set suspend/resume configuration:
-	   wake via GPIO2 after a 20ms delay */
-	lbs_host_sleep_cfg(priv, EHS_WAKE_ON_UNICAST_DATA, 2, 20);
+	priv->wol_gpio = 2; /* Wake via GPIO2... */
+	priv->wol_gap = 20; /* ... after 20ms    */
+	lbs_host_sleep_cfg(priv, EHS_WAKE_ON_UNICAST_DATA);
 
 	usb_get_dev(udev);
 	usb_set_intfdata(intf, cardp);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 1ea119e..5e2f329 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -839,6 +839,11 @@ int lbs_suspend(struct lbs_private *priv)
 	struct cmd_header cmd;
 	int ret;
 
+	if (priv->wol_criteria == 0xffffffff) {
+		lbs_pr_info("Suspend attempt without configuring wake params!\n");
+		return -EINVAL;
+	}
+
 	memset(&cmd, 0, sizeof(cmd));
 	
 	ret = __lbs_cmd(priv, CMD_802_11_HOST_SLEEP_ACTIVATE, &cmd,
@@ -1088,6 +1093,9 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 	sprintf(priv->mesh_ssid, "mesh");
 	priv->mesh_ssid_len = 4;
 
+	priv->wol_criteria = 0xffffffff;
+	priv->wol_gpio = 0xff;
+
 	goto done;
 
 err_init_adapter:
-- 
1.5.3.4

