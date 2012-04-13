Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26794 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab2DMS5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 14:57:25 -0400
Date: Fri, 13 Apr 2012 13:57:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192ce: Remove false positives for kmemleak
Message-ID: <4f887712.nMH3SM0iiiaFD9lP%Larry.Finger@lwfinger.net> (sfid-20120413_205729_651671_EBA0D5D4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rtl8192ce is in operation, kmemleak indicates a number of leaks, yet
when the driver is removed all are gone. These false positives happen
in two locations:

unreferenced object 0xffff880041124000 (size 9536):
  comm "work_for_cpu", pid 9295, jiffies 4295037203 (age 20596.320s)
  hex dump (first 32 bytes):
    33 00 00 01 01 6d 00 00 00 00 b1 0e 21 0b 00 00  3....m......!...
    01 01 6d 00 00 00 00 8b 20 c0 e9 00 00 01 01 6d  ..m..... ......m
  backtrace:
    [<ffffffff8137a1b1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8138d01f>] kmalloc_large_node+0x9a/0xa6
    [<ffffffff811335a5>] __kmalloc_node_track_caller+0x175/0x3b0
    [<ffffffff812ddfe3>] __alloc_skb+0x73/0x230
    [<ffffffff812de1b8>] dev_alloc_skb+0x18/0x30
    [<ffffffffa091a3b7>] rtl_pci_probe+0x10e0/0x17d2 [rtlwifi]
-- snip --
unreferenced object 0xffff8800b4d3f600 (size 256):
  comm "kworker/u:2", pid 13221, jiffies 4297830173 (age 9424.568s)
  hex dump (first 32 bytes):
    1c d6 45 b1 00 88 ff ff 1c d6 45 b1 00 88 ff ff  ..E.......E.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8137a1b1>] kmemleak_alloc+0x21/0x50
    [<ffffffff81130f43>] kmem_cache_alloc_node+0x153/0x270
    [<ffffffff812ddfb6>] __alloc_skb+0x46/0x230
    [<ffffffff812de1b8>] dev_alloc_skb+0x18/0x30
    [<ffffffffa093264a>] rtl92c_set_fw_rsvdpagepkt+0x22a/0x5c0 [rtl8192c_common]
-- snip --

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Another patch for 3.5.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -34,6 +34,7 @@
 #include "ps.h"
 #include "efuse.h"
 #include <linux/export.h>
+#include <linux/kmemleak.h>
 
 static const u16 pcibridge_vendors[PCI_BRIDGE_VENDOR_MAX] = {
 	PCI_VENDOR_ID_INTEL,
@@ -1099,6 +1100,7 @@ static int _rtl_pci_init_rx_ring(struct
 			u32 bufferaddress;
 			if (!skb)
 				return 0;
+			kmemleak_not_leak(skb);
 			entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
 
 			/*skb->dev = dev; */
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -34,6 +34,7 @@
 #include "../rtl8192ce/def.h"
 #include "fw_common.h"
 #include <linux/export.h>
+#include <linux/kmemleak.h>
 
 static void _rtl92c_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 {
@@ -776,6 +777,8 @@ void rtl92c_set_fw_rsvdpagepkt(struct ie
 	skb = dev_alloc_skb(totalpacketlen);
 	if (!skb)
 		return;
+	kmemleak_not_leak(skb);
+
 	memcpy((u8 *) skb_put(skb, totalpacketlen),
 	       &reserved_page_packet, totalpacketlen);
 
