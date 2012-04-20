Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12617 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2DTCjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 22:39:09 -0400
Date: Thu, 19 Apr 2012 21:39:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: airlied@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix oops on unload
Message-ID: <4f90cc4a.rpF7zrtm/TPzcrJH%Larry.Finger@lwfinger.net> (sfid-20120420_043913_557996_621E86AC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under some circumstances, a PCI-based driver reports the following OOPs:

Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Oops: 0000 [#1] SMP
--snip--
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Pid: 19627, comm: rmmod
Not tainted 3.2.9-2.fc16.x86_64 #1 LENOVO 05962RU/05962RU
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] RIP:
0010:[<ffffffffa0418d39>]  [<ffffffffa0418d39>]
rtl92ce_get_desc+0x19/0xd0 [rtl8192ce]
--snip--
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Process rmmod (pid:
19627, threadinfo ffff880050262000, task ffff8801156d5cc0)
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Stack:
Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  0000000000000002
ffff8801176c2540 ffff880050263ca8 ffffffffa03348e7
Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  0000000000000282
0000000180150014 ffff880050263fd8 ffff8801176c2810
Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  ffff880050263bc8
ffffffff810550e2 00000000000002c0 ffff8801176c0d40
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Call Trace:
Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  [<ffffffffa03348e7>]
_rtl_pci_rx_interrupt+0x187/0x650 [rtlwifi]
--snip--
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] Code: ff 09 d0 89 07 48
83 c4 08 5b 5d c3 66 0f 1f 44 00 00 55 48 89 e5 53 48 83 ec 08 66 66
66 66 90 40 84 f6 89 d3 74 13 84 d2 75 57 <8b> 07 48 83 c4 08 5b 5d c1
e8 1f c3 0f 1f 00 84 d2 74 ed 80 fa
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] RIP
[<ffffffffa0418d39>] rtl92ce_get_desc+0x19/0xd0 [rtl8192ce]
Mar 19 08:14:35 kvothe kernel: [ 6584.626011]  RSP <ffff880050263b58>
Mar 19 08:14:35 kvothe kernel: [ 6584.626011] CR2: 00000000000006e0
Mar 19 08:14:35 kvothe kernel: [ 6584.646491] ---[ end trace
8636c766dcfbe0e6 ]---

This oops is due to interrupts not being disabled in this particular path.

Reported-by: Dave Airlie <airlied@gmail.com>
Tested-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

John,

This patch is for V3.4.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1943,6 +1943,7 @@ void rtl_pci_disconnect(struct pci_dev *
 		rtl_deinit_deferred_work(hw);
 		rtlpriv->intf_ops->adapter_stop(hw);
 	}
+	rtlpriv->cfg->ops->disable_interrupt(hw);
 
 	/*deinit rfkill */
 	rtl_deinit_rfkill(hw);
