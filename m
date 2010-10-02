Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41875 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab0JBJfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:43 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658555wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:43 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/20] rt2x00: Fix oops caused by error path in rt2x00lib_start
Date: Sat, 2 Oct 2010 11:34:05 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021133.18211.IvDoorn@gmail.com> <201010021133.43033.IvDoorn@gmail.com>
In-Reply-To: <201010021133.43033.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021134.06174.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

When rt2x00lib_enable_radio fails to enable the radio, rt2x00lib_start
will call rt2x00queue_uninitialize to uninitialize the queues. Since,
the queues are not initialized here but already in rt2x00lib_initialize
we shouldn't uninitialize the queues here. Otherwise, a consecutive call
to rt2x00lib_start will oops (see below) because it assumes the queues
are already initialized.

BUG: unable to handle kernel NULL pointer dereference at 00000010
IP: [<f8d2d901>] :rt2800pci:rt2800pci_clear_entry+0x1/0x40
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: ... rt2800pci ...

Pid: 5995, comm: hostapd Not tainted (2.6.27.8 #1)
EIP: 0060:[<f8d2d901>] EFLAGS: 00210246 CPU: 3
EIP is at rt2800pci_clear_entry+0x1/0x40 [rt2800pci]
EAX: 00000000 EBX: f698863c ECX: 00200296 EDX: f8d2dee0
ESI: f6988600 EDI: f5b6f000 EBP: 00000000 ESP: f6d75e4c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process hostapd (pid: 5995, ti=f6d74000 task=f6ce2300 task.ti=f6d74000)
Stack: f698863c fa00eaec 00000000 f5b6f000 00000000 f7b67000 f5b6e280 fa00c629
      f5b6f000 00000000 fa00ca3d f7b67480 00000001 fa177d4c 01b6e890 f7b67000
      00000000 f7b67000 00000001 00001003 00001002 c066c366 f7b67000 c0668ad0
Call Trace:
 [<fa00eaec>] rt2x00queue_init_queues+0x5c/0x90 [rt2x00lib]
 [<fa00c629>] rt2x00lib_enable_radio+0x29/0xa0 [rt2x00lib]
 [<fa00ca3d>] rt2x00lib_start+0x5d/0xd0 [rt2x00lib]
 [<fa177d4c>] ieee80211_do_open+0x21c/0x510 [mac80211]
 [<c066c366>] dev_open+0x56/0xb0
 [<c0668ad0>] dev_set_rx_mode+0x20/0x40
 [<c066a67f>] dev_change_flags+0x7f/0x190
 [<c06b1495>] devinet_ioctl+0x515/0x690
 [<c0668d24>] __dev_get_by_name+0x74/0x90
 [<c065d3f0>] sock_ioctl+0xd0/0x240
 [<c065d320>] sock_ioctl+0x0/0x240
 [<c018179b>] vfs_ioctl+0x2b/0x90
 [<c0181a5b>] do_vfs_ioctl+0x25b/0x2a0
 [<c0181af6>] sys_ioctl+0x56/0x70
 [<c0103262>] syscall_call+0x7/0xb
 [<c0700000>] add_card+0xad0/0xba0
 =======================
Code: 83 78 08 0e 74 14 8b 02 8b 48 04 85 c9 0f 99 c0 0f b6 c0 c3 8d b6
      00 00 00 00 8b 02 8b 40 04 85 c0 0f 99 c0 0f b6 c0 c3 66 90 53 <8b>
      48 10 8b 58 08 8b 40 04 83 78 08 0e 74 15 8b 11 83 c2 04 8b
EIP: [<f8d2d901>] rt2800pci_clear_entry+0x1/0x40 [rt2800pci] SS:ESP 0068:f6d75e4c
---[ end trace cff9a5c094bb8837 ]---

Reported-by: Joshua Smith <jesmith@kaon.com>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b03e6e4..6f442b0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -933,10 +933,8 @@ int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
 
 	/* Enable the radio */
 	retval = rt2x00lib_enable_radio(rt2x00dev);
-	if (retval) {
-		rt2x00queue_uninitialize(rt2x00dev);
+	if (retval)
 		return retval;
-	}
 
 	set_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags);
 
-- 
1.7.2.3

