Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:39006 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZDJVFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 17:05:19 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH] rt2x00: prevent double kfree when failing to register hardware
Date: Fri, 10 Apr 2009 18:05:14 -0300
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Message-Id: <200904101805.14986.herton@mandriva.com.br> (sfid-20090410_230524_742831_119F0EC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In a scenario where there isn't any firmware available, we will have a
double kfree of rt2x00dev->spec.channels_info when ieee80211_register_h=
w
returns an error status inside rt2x00lib_probe_hw.

The problem is that if ieee80211_register_hw fails, we call
rt2x00lib_remove_hw twice:
* first inside rt2x00lib_probe_hw upon failure of ieee80211_register_hw
* error status is returned to rt2x00lib_probe_dev, which then sees it a=
nd
  calls in this case rt2x00lib_remove_dev that will again run
  rt2x00lib_remove_hw

Prevent this avoiding calling rt2x00lib_remove_hw inside
rt2x00lib_probe_hw

Problem was detected with CONFIG_DEBUG_PAGEALLOC=3Dy, CONFIG_SLUB_DEBUG=
=3Dy,
CONFIG_SLUB_DEBUG_ON=3Dy, that dumps this with no firmware available:

rt61pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
wmaster0 (rt61pci): not using net_device_ops yet
phy0: Selected rate control algorithm 'pid'
phy0: Failed to initialize wep: -2
phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
BUG kmalloc-128: Object already free
-----------------------------------------------------------------------=
------

INFO: Allocated in rt61pci_probe_hw+0x3e5/0x6e0 [rt61pci] age=3D340 cpu=
=3D0 pid=3D21
INFO: Freed in rt2x00lib_remove_hw+0x59/0x70 [rt2x00lib] age=3D0 cpu=3D=
0 pid=3D21
INFO: Slab 0xc13ac3e0 objects=3D23 used=3D10 fp=3D0xdd59f6e0 flags=3D0x=
400000c3
INFO: Object 0xdd59f6e0 @offset=3D1760 fp=3D0xdd59f790

Bytes b4 0xdd59f6d0:  15 00 00 00 b2 8a fb ff 5a 5a 5a 5a 5a 5a 5a 5a .=
=2E..=B2.=FB=FFZZZZZZZZ
  Object 0xdd59f6e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdd59f6f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdd59f700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdd59f710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdd59f720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdd59f730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdd59f740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b k=
kkkkkkkkkkkkkkk
  Object 0xdd59f750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 k=
kkkkkkkkkkkkkk=A5
 Redzone 0xdd59f760:  bb bb bb bb                                     =BB=
=BB=BB=BB
 Padding 0xdd59f788:  5a 5a 5a 5a 5a 5a 5a 5a                         Z=
ZZZZZZZ
Pid: 21, comm: stage1 Not tainted 2.6.29.1-desktop-1.1mnb #1
Call Trace:
 [<c01abbb3>] print_trailer+0xd3/0x120
 [<c01abd37>] object_err+0x37/0x50
 [<c01acf57>] __slab_free+0xe7/0x2f0
 [<c01ad1de>] kfree+0x7e/0xd0
 [<e0e4a239>] ? rt2x00lib_remove_hw+0x59/0x70 [rt2x00lib]
 [<e0e4a239>] ? rt2x00lib_remove_hw+0x59/0x70 [rt2x00lib]
 [<e0e4a239>] rt2x00lib_remove_hw+0x59/0x70 [rt2x00lib]
 [<e0e4acc7>] rt2x00lib_remove_dev+0x37/0x50 [rt2x00lib]
 [<e0e4b087>] rt2x00lib_probe_dev+0x1a7/0x3b0 [rt2x00lib]
 [<e0eb288f>] rt2x00pci_probe+0xdf/0x1ee [rt2x00pci]
 [<c026b9ee>] local_pci_probe+0xe/0x10
 [<c026c750>] pci_device_probe+0x60/0x80
 [<c02d5c2a>] driver_probe_device+0x9a/0x2e0
 [<c02d5ef9>] __driver_attach+0x89/0x90
 [<c02d541b>] bus_for_each_dev+0x4b/0x70
 [<c026c690>] ? pci_device_remove+0x0/0x40
 [<c02d59d9>] driver_attach+0x19/0x20
 [<c02d5e70>] ? __driver_attach+0x0/0x90
 [<c02d4cef>] bus_add_driver+0x1cf/0x2a0
 [<c026c690>] ? pci_device_remove+0x0/0x40
 [<c02d60c9>] driver_register+0x69/0x140
 [<c026c9b0>] __pci_register_driver+0x40/0x80
 [<e0ecc000>] ? rt61pci_init+0x0/0x19 [rt61pci]
 [<e0ecc017>] rt61pci_init+0x17/0x19 [rt61pci]
 [<c0101116>] do_one_initcall+0x26/0x1c0
 [<c01ab90c>] ? slab_pad_check+0x3c/0x120
 [<c01ab90c>] ? slab_pad_check+0x3c/0x120
 [<c01ac8da>] ? check_object+0xda/0x210
 [<c01b0026>] ? percpu_free+0x46/0x50
 [<c01ad09e>] ? __slab_free+0x22e/0x2f0
 [<c01b0026>] ? percpu_free+0x46/0x50
 [<c01b0026>] ? percpu_free+0x46/0x50
 [<c01b0026>] ? percpu_free+0x46/0x50
 [<c01687ec>] ? stop_machine_destroy+0x3c/0x40
 [<c015e515>] ? load_module+0xa5/0x1c50
 [<e0ec5000>] ? rt61pci_eepromregister_read+0x0/0x40 [rt61pci]
 [<e0eb2000>] ? rt2x00pci_write_tx_data+0x0/0x90 [rt2x00pci]
 [<c03ac2fb>] ? mutex_lock+0xb/0x20
 [<c03ac2fb>] ? mutex_lock+0xb/0x20
 [<c017ad16>] ? tracepoint_update_probe_range+0x76/0xa0
 [<c017ad6f>] ? tracepoint_module_notify+0x2f/0x40
 [<c03b02ed>] ? notifier_call_chain+0x2d/0x70
 [<c014f0ed>] ? __blocking_notifier_call_chain+0x4d/0x60
 [<c014f11a>] ? blocking_notifier_call_chain+0x1a/0x20
 [<c0160156>] sys_init_module+0x96/0x1d0
 [<c019dad6>] ? sys_munmap+0x46/0x60
 [<c0105546>] syscall_call+0x7/0xb
=46IX kmalloc-128: Object at 0xdd59f6e0 not freed
rt61pci 0000:00:07.0: PCI INT A disabled
rt61pci: probe of 0000:00:07.0 failed with error -2

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wire=
less/rt2x00/rt2x00dev.c
index 05f94e2..5752aaa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -646,10 +646,8 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *r=
t2x00dev)
 	 * Register HW.
 	 */
 	status =3D ieee80211_register_hw(rt2x00dev->hw);
-	if (status) {
-		rt2x00lib_remove_hw(rt2x00dev);
+	if (status)
 		return status;
-	}
=20
 	set_bit(DEVICE_STATE_REGISTERED_HW, &rt2x00dev->flags);
=20
--=20
1.6.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
