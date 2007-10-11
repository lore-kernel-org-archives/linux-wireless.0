Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:23052 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbXJKKRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 06:17:23 -0400
Received: from lin01.mn-solutions.de (pD95F89A3.dip0.t-ipconnect.de [217.95.137.163])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 00C5B5E46AB
	for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2007 12:17:22 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 113821E002B
	for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2007 12:14:25 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] janitorial: fix all double includes in drivers/net/wireless
Date: Thu, 11 Oct 2007 12:17:41 +0200
References: <200710091430.11043.hs4233@mail.mn-solutions.de> <200710091438.13738.hs4233@mail.mn-solutions.de> <1191960608.4013.58.camel@johannes.berg>
In-Reply-To: <1191960608.4013.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710111217.41651.hs4233@mail.mn-solutions.de> (sfid-20071011_111741_945251_9E368FEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes all double includes of the same file. This
makes scripts/checkincludes.pl happy.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

Note: as I don't have most of the hardware, I wasn't able to 
check the functionality of the patch. However, all drivers 
survived a compile check.

And, after all, it's a quite trivial patch ...


Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-10-11 
13:08:37.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-10-11 
13:08:42.000000000 +0200
@@ -49,7 +49,6 @@
 #include "pio.h"
 #include "sysfs.h"
 #include "xmit.h"
-#include "sysfs.h"
 #include "lo.h"
 #include "pcmcia.h"
 
Index: wireless-2.6/drivers/net/wireless/ipw2200.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/ipw2200.h	2007-10-11 
13:05:20.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/ipw2200.h	2007-10-11 
13:05:24.000000000 +0200
@@ -45,7 +45,6 @@
 
 #include <linux/firmware.h>
 #include <linux/wireless.h>
-#include <linux/dma-mapping.h>
 #include <linux/jiffies.h>
 #include <asm/io.h>
 
Index: wireless-2.6/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	
2007-10-11 13:07:13.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	
2007-10-11 13:07:43.000000000 +0200
@@ -37,9 +37,6 @@
 
 #include <linux/workqueue.h>
 
-#include <net/mac80211.h>
-#include <linux/wireless.h>
-
 #define IWL 3945
 
 #include "../net/mac80211/ieee80211_rate.h"
Index: wireless-2.6/drivers/net/wireless/iwlwifi/iwl-3945.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	
2007-10-11 13:05:57.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/iwlwifi/iwl-3945.c	
2007-10-11 13:06:01.000000000 +0200
@@ -38,7 +38,6 @@
 #include <net/mac80211.h>
 
 #include <linux/etherdevice.h>
-#include <linux/delay.h>
 
 #define IWL 3945
 
Index: wireless-2.6/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	
2007-10-11 13:08:19.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	
2007-10-11 13:08:29.000000000 +0200
@@ -36,9 +36,6 @@
 
 #include <linux/workqueue.h>
 
-#include <net/mac80211.h>
-#include <linux/wireless.h>
-
 #define IWL 4965
 
 #include "../net/mac80211/ieee80211_rate.h"
Index: wireless-2.6/drivers/net/wireless/iwlwifi/iwl-4965.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965.c	
2007-10-11 13:08:03.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/iwlwifi/iwl-4965.c	
2007-10-11 13:08:09.000000000 +0200
@@ -35,9 +35,7 @@
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <net/mac80211.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/delay.h>
 
 #define IWL 4965
 
Index: wireless-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	
2007-10-11 13:07:49.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c	
2007-10-11 13:07:56.000000000 +0200
@@ -48,8 +48,6 @@
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <linux/firmware.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
Index: wireless-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	
2007-10-11 13:06:08.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c	
2007-10-11 13:06:37.000000000 +0200
@@ -48,8 +48,6 @@
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <linux/firmware.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
Index: wireless-2.6/drivers/net/wireless/iwlwifi/iwlwifi.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/iwlwifi/iwlwifi.h	
2007-10-11 13:04:25.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/iwlwifi/iwlwifi.h	
2007-10-11 13:09:53.000000000 +0200
@@ -39,18 +39,13 @@ struct iwl_priv;
 /* Hardware specific file defines the PCI IDs table for that 
hardware module */
 extern struct pci_device_id iwl_hw_card_ids[];
 
+#include "iwl-hw.h"
 #if IWL == 3945
-
 #define DRV_NAME	"iwl3945"
-#include "iwl-hw.h"
 #include "iwl-3945-hw.h"
-
 #elif IWL == 4965
-
 #define DRV_NAME        "iwl4965"
-#include "iwl-hw.h"
 #include "iwl-4965-hw.h"
-
 #endif
 
 #include "iwl-prph.h"
Index: 
wireless-2.6/drivers/net/wireless/zd1211rw-mac80211/zd_def.h
===================================================================
--- 
wireless-2.6.orig/drivers/net/wireless/zd1211rw-mac80211/zd_def.h	
2007-10-11 13:04:56.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/zd1211rw-mac80211/zd_def.h	
2007-10-11 13:05:06.000000000 +0200
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/stringify.h>
 #include <linux/device.h>
-#include <linux/kernel.h>
 
 typedef u16 __nocast zd_addr_t;
 
Index: wireless-2.6/drivers/net/wireless/zd1211rw/zd_def.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/zd1211rw/zd_def.h	
2007-10-11 13:05:37.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/zd1211rw/zd_def.h	
2007-10-11 13:05:40.000000000 +0200
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/stringify.h>
 #include <linux/device.h>
-#include <linux/kernel.h>
 
 typedef u16 __nocast zd_addr_t;
 

