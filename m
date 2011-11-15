Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:41891 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1KOSkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 13:40:51 -0500
Subject: [PATCH wireless-next] Convert some still compiled drivers .get_drvinfo routines to use the preferred strlcpy routine
To: <linux-wireless@vger.kernel.org>, "Jouni Malinen" <j@w1.fi>,
	"Dan Williams" <dcbw@redhat.com>,
	"Luis Rodriguez" <mcgrof@gmail.com>
Message-Id: <20111115184050.0C1552900404@tardy> (sfid-20111115_194055_339487_51A0AB67)
Date: Tue, 15 Nov 2011 10:40:49 -0800 (PST)
From: raj@tardy.cup.hp.com (Rick Jones)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rick Jones <rick.jones2@hp.com>

Convert various seemingly still compiled wireless drivers' .get_drvinfo
routines to use the preferred strlcpy() routine.

Signed-off-by: Rick Jones <rick.jones2@hp.com>

---

Compile tested only.

 drivers/net/wireless/hostap/hostap_ioctl.c |    4 ++--
 drivers/net/wireless/ipw2x00/ipw2100.c     |    7 ++++---
 drivers/net/wireless/ipw2x00/ipw2200.c     |    7 ++++---
 drivers/net/wireless/libertas/ethtool.c    |    7 ++++---
 drivers/net/wireless/prism54/islpci_dev.c  |    4 ++--
 5 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 12de464..46a8c29 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -3871,8 +3871,8 @@ static void prism2_get_drvinfo(struct net_device *dev,
 	iface = netdev_priv(dev);
 	local = iface->local;
 
-	strncpy(info->driver, "hostap", sizeof(info->driver) - 1);
-	snprintf(info->fw_version, sizeof(info->fw_version) - 1,
+	strlcpy(info->driver, "hostap", sizeof(info->driver));
+	snprintf(info->fw_version, sizeof(info->fw_version),
 		 "%d.%d.%d", (local->sta_fw_ver >> 16) & 0xff,
 		 (local->sta_fw_ver >> 8) & 0xff,
 		 local->sta_fw_ver & 0xff);
diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 127e9c6..a0e5c21 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -5981,8 +5981,8 @@ static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 	struct ipw2100_priv *priv = libipw_priv(dev);
 	char fw_ver[64], ucode_ver[64];
 
-	strcpy(info->driver, DRV_NAME);
-	strcpy(info->version, DRV_VERSION);
+	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 
 	ipw2100_get_fwversion(priv, fw_ver, sizeof(fw_ver));
 	ipw2100_get_ucodeversion(priv, ucode_ver, sizeof(ucode_ver));
@@ -5990,7 +5990,8 @@ static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 	snprintf(info->fw_version, sizeof(info->fw_version), "%s:%d:%s",
 		 fw_ver, priv->eeprom_version, ucode_ver);
 
-	strcpy(info->bus_info, pci_name(priv->pci_dev));
+	strlcpy(info->bus_info, pci_name(priv->pci_dev),
+		sizeof(info->bus_info));
 }
 
 static u32 ipw2100_ethtool_get_link(struct net_device *dev)
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 9957588..018a8de 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -10548,8 +10548,8 @@ static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 	char date[32];
 	u32 len;
 
-	strcpy(info->driver, DRV_NAME);
-	strcpy(info->version, DRV_VERSION);
+	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 
 	len = sizeof(vers);
 	ipw_get_ordinal(p, IPW_ORD_STAT_FW_VERSION, vers, &len);
@@ -10558,7 +10558,8 @@ static void ipw_ethtool_get_drvinfo(struct net_device *dev,
 
 	snprintf(info->fw_version, sizeof(info->fw_version), "%s (%s)",
 		 vers, date);
-	strcpy(info->bus_info, pci_name(p->pci_dev));
+	strlcpy(info->bus_info, pci_name(p->pci_dev),
+		sizeof(info->bus_info));
 	info->eedump_len = IPW_EEPROM_IMAGE_SIZE;
 }
 
diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index 885ddc1..f955b2d 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -13,13 +13,14 @@ static void lbs_ethtool_get_drvinfo(struct net_device *dev,
 {
 	struct lbs_private *priv = dev->ml_priv;
 
-	snprintf(info->fw_version, 32, "%u.%u.%u.p%u",
+	snprintf(info->fw_version, sizeof(info->fw_version),
+		"%u.%u.%u.p%u",
 		priv->fwrelease >> 24 & 0xff,
 		priv->fwrelease >> 16 & 0xff,
 		priv->fwrelease >>  8 & 0xff,
 		priv->fwrelease       & 0xff);
-	strcpy(info->driver, "libertas");
-	strcpy(info->version, lbs_driver_version);
+	strlcpy(info->driver, "libertas", sizeof(info->driver));
+	strlcpy(info->version, lbs_driver_version, sizeof(info->version));
 }
 
 /*
diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 5d0f615..8a3cf4f 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -793,8 +793,8 @@ islpci_set_multicast_list(struct net_device *dev)
 static void islpci_ethtool_get_drvinfo(struct net_device *dev,
                                        struct ethtool_drvinfo *info)
 {
-	strcpy(info->driver, DRV_NAME);
-	strcpy(info->version, DRV_VERSION);
+	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static const struct ethtool_ops islpci_ethtool_ops = {
