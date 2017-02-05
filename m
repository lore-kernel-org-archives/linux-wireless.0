Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:34331 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdBEQYl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Feb 2017 11:24:41 -0500
Received: by mail-ot0-f194.google.com with SMTP id 73so7799400otj.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Feb 2017 08:24:41 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Dmitry Osipenko <digetx@gmail.com>
Subject: [PATCH] rtlwifi: rtl8192c-common: Fix "BUG: KASAN:
Date: Sun,  5 Feb 2017 10:24:22 -0600
Message-Id: <20170205162422.26963-1-Larry.Finger@lwfinger.net> (sfid-20170205_172450_879705_EDABE09D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernels built with CONFIG_KASAN=y report the following BUG for rtl8192cu
and rtl8192c-common:

==================================================================
BUG: KASAN: slab-out-of-bounds in rtl92c_dm_bt_coexist+0x858/0x1e40
     [rtl8192c_common] at addr ffff8801c90edb08
Read of size 1 by task kworker/0:1/38
page:ffffea0007243800 count:1 mapcount:0 mapping:          (null)
     index:0x0 compound_mapcount: 0
flags: 0x8000000000004000(head)
page dumped because: kasan: bad access detected
CPU: 0 PID: 38 Comm: kworker/0:1 Not tainted 4.9.7-gentoo #3
Hardware name: Gigabyte Technology Co., Ltd. To be filled by
     O.E.M./Z77-DS3H, BIOS F11a 11/13/2013
Workqueue: rtl92c_usb rtl_watchdog_wq_callback [rtlwifi]
  0000000000000000 ffffffff829eea33 ffff8801d7f0fa30 ffff8801c90edb08
  ffffffff824c0f09 ffff8801d4abee80 0000000000000004 0000000000000297
  ffffffffc070b57c ffff8801c7aa7c48 ffff880100000004 ffffffff000003e8
Call Trace:
  [<ffffffff829eea33>] ? dump_stack+0x5c/0x79
  [<ffffffff824c0f09>] ? kasan_report_error+0x4b9/0x4e0
  [<ffffffffc070b57c>] ? _usb_read_sync+0x15c/0x280 [rtl_usb]
  [<ffffffff824c0f75>] ? __asan_report_load1_noabort+0x45/0x50
  [<ffffffffc06d7a88>] ? rtl92c_dm_bt_coexist+0x858/0x1e40 [rtl8192c_common]
  [<ffffffffc06d7a88>] ? rtl92c_dm_bt_coexist+0x858/0x1e40 [rtl8192c_common]
  [<ffffffffc06d0cbe>] ? rtl92c_dm_rf_saving+0x96e/0x1330 [rtl8192c_common]
...

The problem is due to rtl8192ce and rtl8192cu sharing routines, and having
different layouts of struct rtl_pci_priv, which is used by rtl8192ce, and
struct rtl_usb_priv, which is used by rtl8192cu. The problem was resolved
by placing the struct bt_coexist_info at the head of each of those private
areas.

Reported-and-tested-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> # 4.0+
Cc: Dmitry Osipenko <digetx@gmail.com>
---

Kalle,

This bug has been in the code since kernel 4.0. To my knowledge, it has
never caused a crash, thus I see no particular need to rush the fix to
mainline. Including it in 4.11 should be OK.

I have a better fix in mind that is much more invasive, but that will not
need to be backported to older kernels as this change will fix the bug.
That second fix will be submitted later.

Larry
---
 drivers/net/wireless/realtek/rtlwifi/pci.h | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/usb.h | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.h b/drivers/net/wireless/realtek/rtlwifi/pci.h
index 578b1d9..d9039ea 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.h
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.h
@@ -271,10 +271,10 @@ struct mp_adapter {
 };
 
 struct rtl_pci_priv {
+	struct bt_coexist_info bt_coexist;
+	struct rtl_led_ctl ledctl;
 	struct rtl_pci dev;
 	struct mp_adapter ndis_adapter;
-	struct rtl_led_ctl ledctl;
-	struct bt_coexist_info bt_coexist;
 };
 
 #define rtl_pcipriv(hw)		(((struct rtl_pci_priv *)(rtl_priv(hw))->priv))
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.h b/drivers/net/wireless/realtek/rtlwifi/usb.h
index a6d43d2..cdb9e06 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.h
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.h
@@ -146,8 +146,9 @@ struct rtl_usb {
 };
 
 struct rtl_usb_priv {
-	struct rtl_usb dev;
+	struct bt_coexist_info bt_coexist;
 	struct rtl_led_ctl ledctl;
+	struct rtl_usb dev;
 };
 
 #define rtl_usbpriv(hw)	 (((struct rtl_usb_priv *)(rtl_priv(hw))->priv))
-- 
2.10.2
