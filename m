Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1791 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997Ab2IWSXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2012 14:23:17 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 1/2] rt2x00: Deprecate max_sta_intf field of struct rt2x00_ops.
Date: Sun, 23 Sep 2012 20:22:53 +0200
Message-Id: <1348424574-1573-1-git-send-email-gwingerde@gmail.com> (sfid-20120923_202323_450578_F70DA879)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All drivers set this value to 1, so there is no need (currently) to let
drivers set this.
Therefor, remove the field; we can always add it back when it is needed.

Inspired by an earlier patch from Paul Fertser.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Paul Fertser <fercerpav@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c | 1 -
 drivers/net/wireless/rt2x00/rt2500pci.c | 1 -
 drivers/net/wireless/rt2x00/rt2500usb.c | 1 -
 drivers/net/wireless/rt2x00/rt2800pci.c | 1 -
 drivers/net/wireless/rt2x00/rt2800usb.c | 1 -
 drivers/net/wireless/rt2x00/rt2x00.h    | 1 -
 drivers/net/wireless/rt2x00/rt2x00mac.c | 5 ++---
 drivers/net/wireless/rt2x00/rt61pci.c   | 1 -
 drivers/net/wireless/rt2x00/rt73usb.c   | 1 -
 9 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 6458ab8..e3a2d90 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1789,7 +1789,6 @@ static const struct data_queue_desc rt2400pci_queue_atim = {
 
 static const struct rt2x00_ops rt2400pci_ops = {
 	.name			= KBUILD_MODNAME,
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 1,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 68bca14..479d756 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -2081,7 +2081,6 @@ static const struct data_queue_desc rt2500pci_queue_atim = {
 
 static const struct rt2x00_ops rt2500pci_ops = {
 	.name			= KBUILD_MODNAME,
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 1,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index f95b551..a12e84f 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1896,7 +1896,6 @@ static const struct data_queue_desc rt2500usb_queue_atim = {
 
 static const struct rt2x00_ops rt2500usb_ops = {
 	.name			= KBUILD_MODNAME,
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 1,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 391e08f..27829e1 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1088,7 +1088,6 @@ static const struct data_queue_desc rt2800pci_queue_bcn = {
 static const struct rt2x00_ops rt2800pci_ops = {
 	.name			= KBUILD_MODNAME,
 	.drv_data_size		= sizeof(struct rt2800_drv_data),
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 8,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 603b65d..c9e9370 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -870,7 +870,6 @@ static const struct data_queue_desc rt2800usb_queue_bcn = {
 static const struct rt2x00_ops rt2800usb_ops = {
 	.name			= KBUILD_MODNAME,
 	.drv_data_size		= sizeof(struct rt2800_drv_data),
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 8,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 49375c8..09bf01c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -656,7 +656,6 @@ struct rt2x00lib_ops {
 struct rt2x00_ops {
 	const char *name;
 	const unsigned int drv_data_size;
-	const unsigned int max_sta_intf;
 	const unsigned int max_ap_intf;
 	const unsigned int eeprom_size;
 	const unsigned int rf_size;
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index c3d0f2f..2f98d3d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -243,10 +243,9 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 			return -ENOBUFS;
 
 		/*
-		 * Check if we exceeded the maximum amount
-		 * of supported interfaces.
+		 * We don't support multiple STA interfaces.
 		 */
-		if (rt2x00dev->intf_sta_count >= rt2x00dev->ops->max_sta_intf)
+		if (rt2x00dev->intf_sta_count)
 			return -ENOBUFS;
 
 		break;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 2673e05..d6582a2 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -3045,7 +3045,6 @@ static const struct data_queue_desc rt61pci_queue_bcn = {
 
 static const struct rt2x00_ops rt61pci_ops = {
 	.name			= KBUILD_MODNAME,
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 4,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index cfa9f37..e5eb43b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2382,7 +2382,6 @@ static const struct data_queue_desc rt73usb_queue_bcn = {
 
 static const struct rt2x00_ops rt73usb_ops = {
 	.name			= KBUILD_MODNAME,
-	.max_sta_intf		= 1,
 	.max_ap_intf		= 4,
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
-- 
1.7.12.1

