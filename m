Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61573 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1CQRBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 13:01:36 -0400
Received: by vxi39 with SMTP id 39so2786365vxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 10:01:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201103171316.02636.helmut.schaa@googlemail.com>
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
	<201103171316.02636.helmut.schaa@googlemail.com>
Date: Thu, 17 Mar 2011 18:01:34 +0100
Message-ID: <AANLkTi=Gm-apOyop22UgFMgoQE_+maEQgrMDdH-kTxZq@mail.gmail.com>
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers in
 AP and IBSS
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

On Thu, Mar 17, 2011 at 1:16 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Mittwoch, 16. März 2011 schrieb Juan Carlos Garza:
>> When configured as ad-hoc mode, it won't allow to turn off power
>> savings (iwconfig wlan5 power off <-- fails)
>
> AdHoc powersave is not supported and as such is never enabled.
>
>> What else can I do? How can I get more debug information about what's happening?
>
> Build rt2x00 with CONFIG_RT2X00_DEBUG and attach your kernel log here
> after reproducing this issue please.

The log...
I basically connect the Ralink dongle (or power it), configure its IP,
start DHCP server and HostAPD without authentication and then  on the
client side, I connect via a stick (Atheros AR9170) to a windows
machine and try to transfer a 508 MByte file from the Access Point to
the Windows machine via drag and drop in a shared folder in Samba
Server. The huge bunch of warnings come before it completely stops
transmitting. Then some time later I shut down HostAPD.


Mar 17 16:52:30 LS817 kernel: usb 1-3: new high speed USB device using
ehci_hcd and address 6
Mar 17 16:52:30 LS817 kernel: usb 1-3: configuration #1 chosen from 1 choice
Mar 17 16:52:30 LS817 kernel: phy0 -> rt2x00_set_chip: Info - Chipset
detected - rt: 3070, rf: 0005, rev: 0201.
Mar 17 16:52:30 LS817 kernel: ieee80211 phy0: Selected rate control
algorithm 'minstrel_ht'
Mar 17 16:54:59 LS817 kernel: usbcore: deregistering interface driver rt2800usb
Mar 17 16:55:00 LS817 kernel: pm_qos_param: cpu_dma_latency deinit failed
Mar 17 16:55:02 LS817 kernel: sysfs: duplicate filename
'cpu_dma_latency' can not be created
Mar 17 16:55:02 LS817 kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Mar 17 16:55:02 LS817 kernel: Pid: 2708, comm: insmod Tainted: P
 2.6.24_atom-atom-x86_586 #29
Mar 17 16:55:02 LS817 kernel:  [<c01b19c8>] sysfs_add_one+0x54/0xb8
Mar 17 16:55:02 LS817 kernel:  [<c01b1e9b>] create_dir+0x3c/0x6c
Mar 17 16:55:02 LS817 kernel:  [<c01b1ef8>] sysfs_create_dir+0x2d/0x40
Mar 17 16:55:02 LS817 kernel:  [<c0245c55>] kobject_add+0xe9/0x190
Mar 17 16:55:02 LS817 kernel:  [<c0245b59>] kobject_set_name+0x81/0x94
Mar 17 16:55:02 LS817 kernel:  [<c02ae39e>] device_add+0x91/0x540
Mar 17 16:55:02 LS817 kernel:  [<c0245944>] kobject_init+0x29/0x37
Mar 17 16:55:02 LS817 kernel:  [<c02aebb7>] device_create+0x7a/0x9a
Mar 17 16:55:02 LS817 kernel:  [<c029cbca>] misc_register+0xc5/0xfe
Mar 17 16:55:02 LS817 kernel:  [<e0a6512b>]
compat_pm_qos_power_init+0xe/0x70 [compat]
Mar 17 16:55:02 LS817 kernel:  [<e0869008>] compat_init+0x8/0x24 [compat]
Mar 17 16:55:02 LS817 kernel:  [<c014642b>] sys_init_module+0x17c4/0x189f
Mar 17 16:55:02 LS817 kernel:  [<c0178355>] do_sync_read+0xc7/0x10a
Mar 17 16:55:02 LS817 kernel:  [<c0244c41>] _atomic_dec_and_lock+0x2d/0x4c
Mar 17 16:55:02 LS817 kernel:  [<c0179549>] __fput+0x11a/0x144
Mar 17 16:55:02 LS817 kernel:  [<c0104ff2>] syscall_call+0x7/0xb
Mar 17 16:55:02 LS817 kernel:  =======================
Mar 17 16:55:02 LS817 kernel: kobject_add failed for cpu_dma_latency
with -EEXIST, don't try to register things with the same name in the
same directory.
Mar 17 16:55:02 LS817 kernel: Pid: 2708, comm: insmod Tainted: P
 2.6.24_atom-atom-x86_586 #29
Mar 17 16:55:02 LS817 kernel:  [<c0245cca>] kobject_add+0x15e/0x190
Mar 17 16:55:02 LS817 kernel:  [<c0245b59>] kobject_set_name+0x81/0x94
Mar 17 16:55:02 LS817 kernel:  [<c02ae39e>] device_add+0x91/0x540
Mar 17 16:55:02 LS817 kernel:  [<c0245944>] kobject_init+0x29/0x37
Mar 17 16:55:02 LS817 kernel:  [<c02aebb7>] device_create+0x7a/0x9a
Mar 17 16:55:02 LS817 kernel:  [<c029cbca>] misc_register+0xc5/0xfe
Mar 17 16:55:02 LS817 kernel:  [<e0a6512b>]
compat_pm_qos_power_init+0xe/0x70 [compat]
Mar 17 16:55:02 LS817 kernel:  [<e0869008>] compat_init+0x8/0x24 [compat]
Mar 17 16:55:02 LS817 kernel:  [<c014642b>] sys_init_module+0x17c4/0x189f
Mar 17 16:55:02 LS817 kernel:  [<c0178355>] do_sync_read+0xc7/0x10a
Mar 17 16:55:02 LS817 kernel:  [<c0244c41>] _atomic_dec_and_lock+0x2d/0x4c
Mar 17 16:55:02 LS817 kernel:  [<c0179549>] __fput+0x11a/0x144
Mar 17 16:55:02 LS817 kernel:  [<c0104ff2>] syscall_call+0x7/0xb
Mar 17 16:55:02 LS817 kernel:  =======================
Mar 17 16:55:02 LS817 kernel: pm_qos_param: cpu_dma_latency setup failed
Mar 17 16:55:02 LS817 kernel: Compat-wireless backport release:
compat-wireless-2011-01-31-25-g9d8e201
Mar 17 16:55:02 LS817 kernel: Backport based on linux-next.git next-20110311
Mar 17 16:55:02 LS817 kernel: Calling CRDA to update world regulatory domain
Mar 17 16:55:02 LS817 kernel: phy0 -> rt2x00_set_chip: Info - Chipset
detected - rt: 3070, rf: 0005, rev: 0201.
Mar 17 16:55:02 LS817 kernel: ieee80211 phy0: Selected rate control
algorithm 'minstrel_ht'
Mar 17 16:55:02 LS817 kernel: usbcore: registered new interface driver rt2800usb
Mar 17 16:55:05 LS817 kernel: phy0 -> rt2x00lib_request_firmware: Info
- Loading firmware file 'rt2870.bin'.
Mar 17 16:55:05 LS817 kernel: phy0 -> rt2x00lib_request_firmware: Info
- Firmware detected - version: 0.236.
Mar 17 16:55:06 LS817 kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
Mar 17 16:55:06 LS817 kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
Mar 17 16:55:06 LS817 kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
Mar 17 16:55:06 LS817 kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
Mar 17 16:55:06 LS817 kernel: ADDRCONF(NETDEV_UP): wlan5: link is not ready
Mar 17 16:55:15 LS817 kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
Mar 17 16:55:15 LS817 kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
Mar 17 16:55:15 LS817 kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
Mar 17 16:55:15 LS817 kernel: phy0 -> rt2x00mac_conf_tx: Info -
Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
Mar 17 16:55:25 LS817 kernel: wlan5: no IPv6 routers present
Mar 17 16:57:23 LS817 kernel: phy0 -> rt2x00usb_watchdog_tx_status:
Warning - TX queue 0 status timed out, invoke forced tx handler
Mar 17 16:57:34 LS817 last message repeated 2 times
Mar 17 16:58:37 LS817 last message repeated 6 times
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 7
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 8
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 12
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 55
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 56
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 58
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 59
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 58
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 59
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 55
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 56
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 43
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 44
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 46
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 47
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 49
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 50
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 52
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 53
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 50
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 29
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 49
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 50
Mar 17 16:58:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 52
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 53
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 55
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 56
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 10
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 52
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 53
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 52
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 53
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 16
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 17
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 52
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 53
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 47
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 48
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 52
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 53
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 49
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 50
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 59
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 34
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 35
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 28
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 29
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 41
Mar 17 16:58:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 42
Mar 17 17:10:26 LS817 kernel: phy0 -> rt2x00queue_flush_queue: Warning
- Queue 0 failed to flush
Mar 17 17:10:26 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:10:28 LS817 kernel: phy0 -> rt2x00queue_flush_queue: Warning
- Queue 0 failed to flush

I then repeated the whole process but I connected it to a laptop with
an Intel 3945ABG NIC and the transfer was successful, there I did get
a lot of warning messages, but the difference is that here I got 4
warnings every 2 or 3 seconds, not a whole bunch in just 1 second.

Mar 17 17:13:45 LS817 kernel: phy0 -> rt2x00usb_watchdog_tx_status:
Warning - TX queue 0 status timed out, invoke forced tx handler
Mar 17 17:13:56 LS817 last message repeated 10 times
Mar 17 17:17:26 LS817 kernel: phy0 -> rt2x00usb_watchdog_tx_status:
Warning - TX queue 0 status timed out, invoke forced tx handler
Mar 17 17:17:51 LS817 kernel: phy0 -> rt2x00usb_watchdog_tx_status:
Warning - TX queue 0 status timed out, invoke forced tx handler
Mar 17 17:17:59 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 58
Mar 17 17:17:59 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 59
Mar 17 17:17:59 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:17:59 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:17:59 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:17:59 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:18:02 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 1
Mar 17 17:18:02 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 2
Mar 17 17:18:04 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 48
Mar 17 17:18:04 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 49
Mar 17 17:18:04 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 50
Mar 17 17:18:04 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 12
Mar 17 17:18:04 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 13
Mar 17 17:18:04 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:18:04 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:18:04 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:18:17 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 49
Mar 17 17:18:17 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:18:17 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:18:17 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:18:22 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:18:22 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:18:22 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:18:25 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 48
Mar 17 17:18:27 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 63
Mar 17 17:18:27 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:18:27 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:18:27 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:18:27 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:18:30 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 41
Mar 17 17:18:30 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 42
Mar 17 17:18:30 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:18:30 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:18:30 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:18:32 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 47
Mar 17 17:18:32 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 48
Mar 17 17:18:32 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:18:32 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:18:32 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:18:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 44
Mar 17 17:18:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:18:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:18:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:18:51 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:18:51 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:18:51 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:09 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 22
Mar 17 17:19:11 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:19:11 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:19:11 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:15 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 49
Mar 17 17:19:15 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:19:15 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:19:15 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:17 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 45
Mar 17 17:19:17 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 47
Mar 17 17:19:24 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 30
Mar 17 17:19:24 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 58
Mar 17 17:19:24 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 59
Mar 17 17:19:24 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:24 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:19:24 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:19:24 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:26 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:19:26 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:19:26 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:28 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:19:28 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:19:28 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:34 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 46
Mar 17 17:19:37 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 63
Mar 17 17:19:37 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:39 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 11
Mar 17 17:19:39 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 12
Mar 17 17:19:39 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:19:39 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:19:39 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:41 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 12
Mar 17 17:19:41 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 55
Mar 17 17:19:41 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 56
Mar 17 17:19:41 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:41 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 58
Mar 17 17:19:41 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 59
Mar 17 17:19:41 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:41 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:19:41 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:19:41 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 58
Mar 17 17:19:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 59
Mar 17 17:19:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:19:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:19:44 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:19:49 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 44
Mar 17 17:19:49 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 46
Mar 17 17:19:52 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 14
Mar 17 17:19:52 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 15
Mar 17 17:19:52 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:19:52 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:19:52 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:20:03 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 24
Mar 17 17:20:03 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 25
Mar 17 17:20:03 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 27
Mar 17 17:20:03 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 28
Mar 17 17:20:03 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 30
Mar 17 17:20:15 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:20:15 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 1
Mar 17 17:20:15 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 3
Mar 17 17:20:15 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 4
Mar 17 17:20:22 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 54
Mar 17 17:20:22 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 55
Mar 17 17:20:32 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:20:34 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 57
Mar 17 17:20:34 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 58
Mar 17 17:20:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:20:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:20:43 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:20:50 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:20:50 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:20:50 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:20:58 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 56
Mar 17 17:21:10 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 57
Mar 17 17:21:10 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:21:10 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 58
Mar 17 17:21:10 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 59
Mar 17 17:21:10 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:21:10 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 61
Mar 17 17:21:10 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 62
Mar 17 17:21:10 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 0
Mar 17 17:21:12 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 49
Mar 17 17:21:12 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 50
Mar 17 17:21:14 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 46
Mar 17 17:21:14 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 47
Mar 17 17:21:14 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 49
Mar 17 17:21:14 LS817 kernel: phy0 -> rt2800_txdone_entry_check:
Warning - TX status report missed for queue 0 entry 50
Mar 17 17:21:40 LS817 kernel: phy0 -> rt2x00usb_watchdog_tx_status:
Warning - TX queue 0 status timed out, invoke forced tx handler

As it was successful, I did not need to kill HostAPD, and connected
with the Atheros stick again and this time, the transfer lasted a bit
longer, but the warning messages were as frequent as  the first time
and then it stopped.


Best Regards,

Juan Carlos
