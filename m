Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62220 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2HFJDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 05:03:25 -0400
Received: by eaac11 with SMTP id c11so739922eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 02:03:24 -0700 (PDT)
From: Paul Fertser <fercerpav@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Paul Fertser <fercerpav@gmail.com>
Subject: [RFC] [PATCHv2] rt2x00: specify iface_combinations to allow for multi-bss operation
Date: Mon,  6 Aug 2012 13:03:10 +0400
Message-Id: <1344243790-30164-1-git-send-email-fercerpav@gmail.com> (sfid-20120806_110345_744549_473A8207)
In-Reply-To: <CAL1gcdM4-mbdDTmopEhZhHysVioxP5+E=DuMRDU_nLxmebN8Nw@mail.gmail.com>
References: <CAL1gcdM4-mbdDTmopEhZhHysVioxP5+E=DuMRDU_nLxmebN8Nw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes all rt2x00 drivers tell mac80211 about possible
interface combinations they support. Only combinations allowed so far
are 4 APs for rt61pci and rt73usb; 8 APs for rt2800{pci,usb}.

The driver-specific code in add_interface is now redudant and thus
removed.

However, real-life testing on RT3052F SoC showed that neither WPA-PSK +
Open nor 2 WPA-PSK APs work properly (though both APs beacon properly).
No other tests were performed.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---

Gertjan, i hope this is what you meant, and thanks for spotting my
mistake.

It would be very nice if one of you rt2x00 developers tried multi-bss
now with this patch to see what might be wrong with the
driver. Testing it is really easy, basically, you just need to add
"bss=wlan0_0" to the end of the hostapd.conf and then to specify all
the other options (ssid, encryption) that are to be different from the
first bss.

 drivers/net/wireless/rt2x00/rt2400pci.c |    1 -
 drivers/net/wireless/rt2x00/rt2500pci.c |    1 -
 drivers/net/wireless/rt2x00/rt2500usb.c |    1 -
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 -
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 -
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 -
 drivers/net/wireless/rt2x00/rt2x00dev.c |   36 +++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00mac.c |   40 -------------------------------
 drivers/net/wireless/rt2x00/rt61pci.c   |    1 -
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 -
 10 files changed, 36 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 8b9dbd7..311145f 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1780,7 +1780,6 @@ static const struct data_queue_desc rt2400pci_queue_atim = {
 
 static const struct rt2x00_ops rt2400pci_ops = {
 	.name			= KBUILD_MODNAME,
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 1,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index d2cf8a4..55fb636 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -2072,7 +2072,6 @@ static const struct data_queue_desc rt2500pci_queue_atim = {
 
 static const struct rt2x00_ops rt2500pci_ops = {
 	.name			= KBUILD_MODNAME,
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 1,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 3aae36b..10b9d32 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1887,7 +1887,6 @@ static const struct data_queue_desc rt2500usb_queue_atim = {
 
 static const struct rt2x00_ops rt2500usb_ops = {
 	.name			= KBUILD_MODNAME,
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 1,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 235376e..1e8c3af 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1214,7 +1214,6 @@ static const struct data_queue_desc rt2800pci_queue_bcn = {
 static const struct rt2x00_ops rt2800pci_ops = {
 	.name			= KBUILD_MODNAME,
 	.drv_data_size		= sizeof(struct rt2800_drv_data),
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 8,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6cf3365..1e065fb 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -892,7 +892,6 @@ static const struct data_queue_desc rt2800usb_queue_bcn = {
 static const struct rt2x00_ops rt2800usb_ops = {
 	.name			= KBUILD_MODNAME,
 	.drv_data_size		= sizeof(struct rt2800_drv_data),
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 8,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 8afb546..8f27002 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -655,7 +655,6 @@ struct rt2x00lib_ops {
 struct rt2x00_ops {
 	const char *name;
 	const unsigned int drv_data_size;
-	const unsigned int max_sta_intf;
 	const unsigned int max_ap_intf;
 	const unsigned int eeprom_size;
 	const unsigned int rf_size;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a6b88bd..9424ef9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -32,6 +32,34 @@
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
+static const struct ieee80211_iface_limit if_limit_ap_4[] = {
+	{
+		.max = 4,
+		.types = BIT(NL80211_IFTYPE_AP),
+	},
+};
+
+static const struct ieee80211_iface_limit if_limit_ap_8[] = {
+	{
+		.max = 8,
+		.types = BIT(NL80211_IFTYPE_AP),
+	},
+};
+
+static const struct ieee80211_iface_combination if_comb_4 = {
+		.limits = if_limit_ap_4,
+		.n_limits = ARRAY_SIZE(if_limit_ap_4),
+		.max_interfaces = 4,
+		.num_different_channels = 1,
+};
+
+static const struct ieee80211_iface_combination if_comb_8 = {
+		.limits = if_limit_ap_8,
+		.n_limits = ARRAY_SIZE(if_limit_ap_8),
+		.max_interfaces = 8,
+		.num_different_channels = 1,
+};
+
 /*
  * Utility functions.
  */
@@ -1125,6 +1153,14 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 {
 	int retval = -ENOMEM;
 
+	if (rt2x00dev->ops->max_ap_intf == 4) {
+		rt2x00dev->hw->wiphy->iface_combinations = &if_comb_4;
+		rt2x00dev->hw->wiphy->n_iface_combinations = 1;
+	} else if (rt2x00dev->ops->max_ap_intf == 8) {
+		rt2x00dev->hw->wiphy->iface_combinations = &if_comb_8;
+		rt2x00dev->hw->wiphy->n_iface_combinations = 1;
+	}
+
 	/*
 	 * Allocate the driver data memory, if necessary.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 4ff26c2..8391b6a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -212,46 +212,6 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	    !test_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags))
 		return -ENODEV;
 
-	switch (vif->type) {
-	case NL80211_IFTYPE_AP:
-		/*
-		 * We don't support mixed combinations of
-		 * sta and ap interfaces.
-		 */
-		if (rt2x00dev->intf_sta_count)
-			return -ENOBUFS;
-
-		/*
-		 * Check if we exceeded the maximum amount
-		 * of supported interfaces.
-		 */
-		if (rt2x00dev->intf_ap_count >= rt2x00dev->ops->max_ap_intf)
-			return -ENOBUFS;
-
-		break;
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
-	case NL80211_IFTYPE_WDS:
-		/*
-		 * We don't support mixed combinations of
-		 * sta and ap interfaces.
-		 */
-		if (rt2x00dev->intf_ap_count)
-			return -ENOBUFS;
-
-		/*
-		 * Check if we exceeded the maximum amount
-		 * of supported interfaces.
-		 */
-		if (rt2x00dev->intf_sta_count >= rt2x00dev->ops->max_sta_intf)
-			return -ENOBUFS;
-
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	/*
 	 * Loop through all beacon queues to find a free
 	 * entry. Since there are as much beacon entries
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f322596..98a5790 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -3037,7 +3037,6 @@ static const struct data_queue_desc rt61pci_queue_bcn = {
 
 static const struct rt2x00_ops rt61pci_ops = {
 	.name			= KBUILD_MODNAME,
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 4,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ba6e434..0196892 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2373,7 +2373,6 @@ static const struct data_queue_desc rt73usb_queue_bcn = {
 
 static const struct rt2x00_ops rt73usb_ops = {
 	.name			= KBUILD_MODNAME,
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 4,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
-- 
1.7.3.4

