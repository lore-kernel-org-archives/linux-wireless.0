Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52248 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab2FFTKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 15:10:14 -0400
Received: by qcro28 with SMTP id o28so3538421qcr.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 12:10:13 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 21:10:13 +0200
Message-ID: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com> (sfid-20120606_211036_695360_C0AB150F)
Subject: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
From: Andre Heider <a.heider@gmail.com>
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	johannes.berg@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the wlan daughterboard on a nintendo wii stopped working with current master.
Building from the v3.4 tag gives me a working device.

I bisected this to:

commit 3a25a8c8b75b430c4f4022918e26fa51d557ecde
Author: Johannes Berg <johannes.berg@intel.com>

The hw queues fail the check in ieee80211_check_queues(). When I hack
that function to always "return 0;" wlan works again.

These 2 printk()s:

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d4c19a7..246fc04 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -154,7 +154,9 @@ static int ieee80211_check_queues(struct
ieee80211_sub_if_data *sdata)
    int n_queues = sdata->local->hw.queues;
    int i;

+   printk("n_queues=%d\n", n_queues);
    for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+       printk("sdata->vif.hw_queue[%d]=%d\n", i, sdata->vif.hw_queue[i]);
        if (WARN_ON_ONCE(sdata->vif.hw_queue[i] ==
                 IEEE80211_INVAL_HW_QUEUE))
            return -EINVAL;

end in:
[   11.873077] n_queues=1
[   11.897066] sdata->vif.hw_queue[0]=0
[   11.900451] sdata->vif.hw_queue[1]=1

The surrounding dmesg output is:
[    0.270900] sdhci: Secure Digital Host Controller Interface driver
[    0.274159] sdhci: Copyright(c) Pierre Ossman
[    0.286360] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.318739] mmc0: SDHCI controller on d070000.sd [d070000.sd] using DMA
[    0.358650] mmc1: SDHCI controller on d080000.sdio [d080000.sdio] using DMA
[    0.366951] TCP: cubic registered
[    0.370514] NET: Registered protocol family 17
[    0.374265] Bluetooth: RFCOMM TTY layer initialized
[    0.386710] Bluetooth: RFCOMM socket layer initialized
[    0.390129] Bluetooth: RFCOMM ver 1.11
[    0.393466] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    0.396794] Bluetooth: BNEP filters: protocol multicast
[    0.400096] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    0.403386] initlevel:7=late, 14 registered initcalls
[    0.408372] Waiting for root device /dev/mmcblk0p2...
[    0.425466] mmc0: new high speed SD card at address f181
[    0.429456] mmcblk0: mmc0:f181 SD02G 1.87 GiB
[    0.434311]  mmcblk0: p1 p2 p3
[    0.461667] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    0.467214] mmc1: queuing unknown CIS tuple 0x80 (5 bytes)
[    0.471669] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    0.485751] mmc1: queuing unknown CIS tuple 0x80 (5 bytes)
[    0.493260] mmc1: queuing unknown CIS tuple 0x80 (10 bytes)
[    0.496433] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    0.499543] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    0.502583] mmc1: queuing unknown CIS tuple 0x80 (5 bytes)
[    0.505491] mmc1: queuing unknown CIS tuple 0x80 (4 bytes)
[    0.508130] mmc1: new SDIO card at address 0001
[    0.520378] b43-sdio mmc1:0001:1: Chip ID 14e4:4318
[    0.523595] ssb: Found chip with id 0x4318, rev 0x02 and package 0x02
[    0.557528] ssb: chipcommon status is 0x0
[    0.561271] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
[    0.643432] ssb: Sonics Silicon Backplane found on SDIO device mmc1:0001:1
[    0.770220] EXT4-fs (mmcblk0p2): mounted filesystem with ordered
data mode. Opts: (null)
[    0.786605] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
[    0.795436] Freeing unused kernel memory: 144k freed
[    5.339710] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
[    5.789283] EXT4-fs (mmcblk0p2): re-mounted. Opts: discard,errors=remount-ro
[   10.919815] b43-phy0: Loading OpenSource firmware version 410.31754
[   10.936408] b43-phy0: Hardware crypto acceleration not supported by firmware
[   10.943866] b43-phy0: QoS not supported by firmware
[   11.873077] n_queues=1
[   11.897066] sdata->vif.hw_queue[0]=0
[   11.900451] sdata->vif.hw_queue[1]=1
[   11.903763] ------------[ cut here ]------------
[   11.906987] WARNING: at /home/andre/devel-temp/linux/net/mac80211/iface.c:164
[   11.913314] NIP: c039e248 LR: c039e1f4 CTR: 00000000
[   11.916488] REGS: d3019cb0 TRAP: 0700   Not tainted  (3.5.0-rc1-wii+)
[   11.919674] MSR: 00029032 <EE,ME,IR,DR,RI>  CR: 28888428  XER: 00000000
[   11.926211] TASK = d3020270[1221] 'wpa_supplicant' THREAD: d3018000
[   11.926211] GPR00: 00000001 d3019d60 d3020270 00000018 00001032
d3019c48 ffffffff 00000000
[   11.926211] GPR08: d38e5220 c04f0000 00000000 000000a5 22888428
100f2a98 10015603 00000027
[   11.926211] GPR16: ffffffff 100d8200 100d1bd4 100f0000 100eaa84
100eaa84 bfe0ce1e d3b8bccc
[   11.926211] GPR24: 00000000 d3019e28 00000001 c049ced3 00000001
d3bb3402 00000002 d3bb3400
[   11.957761] NIP [c039e248] ieee80211_check_queues+0xb0/0x188
[   11.961435] LR [c039e1f4] ieee80211_check_queues+0x5c/0x188
[   11.965097] Call Trace:
[   11.968754] [d3019d60] [c039e1f4] ieee80211_check_queues+0x5c/0x188
(unreliable)
[   11.976391] [d3019d80] [c039fef0] ieee80211_do_open+0x548/0xb88
[   11.980396] [d3019db0] [c02c0300] __dev_open+0xc4/0x120
[   11.984400] [d3019dd0] [c02bd0ec] __dev_change_flags+0xe0/0x174
[   11.988397] [d3019df0] [c02c01f0] dev_change_flags+0x24/0x70
[   11.992413] [d3019e10] [c030f618] devinet_ioctl+0x2bc/0x77c
[   11.996500] [d3019e80] [c0310df4] inet_ioctl+0xd8/0x114
[   12.000568] [d3019e90] [c02a9728] sock_ioctl+0x1fc/0x248
[   12.004555] [d3019eb0] [c00d9170] do_vfs_ioctl+0x688/0x730
[   12.008466] [d3019f10] [c00d9268] sys_ioctl+0x50/0x90
[   12.012333] [d3019f40] [c000f668] ret_from_syscall+0x0/0x38
[   12.016134] --- Exception: c01 at 0xfbe0058
[   12.016134]     LR = 0xfbdffbc
[   12.023526] Instruction dump:
[   12.027091] 68000001 0f000000 2f800000 41be00d4 38000001 3d20c04f
9809712f 480000c4
[   12.034244] 41b8002c 3d20c04f 88097130 68000001 <0f000000> 2f800000
41be00a8 38000001
[   12.041393] ---[ end trace 5b1ec0526600d1ae ]---
[   13.343824] b43-phy0: Loading OpenSource firmware version 410.31754
[   13.347591] b43-phy0: Hardware crypto acceleration not supported by firmware
[   13.354286] b43-phy0: QoS not supported by firmware
[   14.299915] n_queues=1
[   14.303012] sdata->vif.hw_queue[0]=0
[   14.306058] sdata->vif.hw_queue[1]=1
[   15.643819] b43-phy0: Loading OpenSource firmware version 410.31754
[   15.647501] b43-phy0: Hardware crypto acceleration not supported by firmware
[   15.654225] b43-phy0: QoS not supported by firmware
[   16.584720] n_queues=1
[   16.587757] sdata->vif.hw_queue[0]=0
[   16.590721] sdata->vif.hw_queue[1]=1

Any ideas?

Thanks,
Andre
