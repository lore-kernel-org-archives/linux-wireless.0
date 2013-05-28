Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46314 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab3E1BiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 21:38:15 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi5so2008778wib.2
        for <linux-wireless@vger.kernel.org>; Mon, 27 May 2013 18:38:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAM05XA78qnrsACiG3CRrGvUkaompbi9Owf-s4uKJDiMunXURGg@mail.gmail.com>
References: <CAM05XA78qnrsACiG3CRrGvUkaompbi9Owf-s4uKJDiMunXURGg@mail.gmail.com>
From: Vamegh Hedayati <vamegh@gmail.com>
Date: Tue, 28 May 2013 02:37:43 +0100
Message-ID: <CAM05XA4qczC5yztdBpnkLwga8vXQYUpPVKh4KNvxdegawb6RmA@mail.gmail.com> (sfid-20130528_033825_127831_6A173CAA)
Subject: Fwd: Issues with Intel Centrino advanced-N 6235
To: ilw@linux.intel.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I recently bought A Dell XPS 13 Developer edition (Ubuntu Based Laptop)

I had major problem with the wireless. After a while, the  wireless
interface randomly drops and only a reboot will bring back the
wireless interface.

This issue was pretty bad using the default installation provided by
Dell (12.04). I then upgrade to 12.10 to see the same sort of issue,
currently I am running Ubuntu 13.04 running KDE and kernel 3.10

root@fl1ght:~# uname -a && lshw -class network
Linux fl1ght 3.10.0-999-generic #201305240428 SMP Fri May 24 08:28:59
UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
  *-network
       description: Wireless interface
       product: Centrino Advanced-N 6235
       vendor: Intel Corporation
       physical id: 0
       bus info: pci@0000:01:00.0
       logical name: wlan0
       version: 24
       serial: ************
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress cap_list ethernet physical wireless
       configuration: broadcast=yes driver=iwlwifi
driverversion=3.10.0-999-generic firmware=18.168.6.1 latency=0 link=no
multicast=yes wireless=IEEE 802.11abgn
       resources: irq:44 memory:***********
  *-network
       description: Ethernet interface
       physical id: 2
       logical name: eth0
       serial: ***************
       size: 1Gbit/s
       capacity: 1Gbit/s
       capabilities: ethernet physical tp mii 10bt 10bt-fd 100bt
100bt-fd 1000bt 1000bt-fd autonegotiation
       configuration: autonegotiation=on broadcast=yes driver=asix
driverversion=22-Dec-2011 duplex=full firmware=ASIX AX88178 USB 2.0
Ethernet ip=10.0.5.100 link=yes multicast=yes port=MII speed=1Gbit/s

root@fl1ght:/var/log# lsmod |grep iwl
iwldvm                249110  0
mac80211              615800  1 iwldvm
iwlwifi               181947  1 iwldvm
cfg80211              495341  3 iwlwifi,mac80211,iwldvm

I currently have a usb Gigabit Ethernet Adaptor attached, hence why
the the Ethernet interface (the laptop is an ultrabook with no
ethernet ports as standard)

I have downloaded the latest intel firmware  from
http://wireless.kernel.org/en/users/Drivers/iwlwifi hoping it could be
firmware related or atleast different than whats provided with Ubuntu
and unfortunately no difference:

root@fl1ght:/var/log# ls -al /lib/firmware/|grep iwl
-rw-r--r--  1 root root  335056 May 25 02:30 iwlwifi-1000-3.ucode
-rw-r--r--  1 root root  337520 May 25 02:30 iwlwifi-1000-5.ucode
-rw-r--r--  1 root root  337572 May 25 02:30 iwlwifi-100-5.ucode
-rw-r--r--  1 root root  689680 May 25 02:30 iwlwifi-105-6.ucode
-rw-r--r--  1 root root  701228 May 25 02:30 iwlwifi-135-6.ucode
-rw-r--r--  1 root root  695876 May 25 02:30 iwlwifi-2000-6.ucode
-rw-r--r--  1 root root  707392 May 25 02:30 iwlwifi-2030-6.ucode
-rw-r--r--  1 root root  150100 May 25 02:30 iwlwifi-3945-2.ucode
-rw-r--r--  1 root root  187972 May 25 02:30 iwlwifi-4965-2.ucode
-rw-r--r--  1 root root  345008 May 25 02:30 iwlwifi-5000-1.ucode
-rw-r--r--  1 root root  353240 May 25 02:30 iwlwifi-5000-2.ucode
-rw-r--r--  1 root root  340696 May 25 02:30 iwlwifi-5000-5.ucode
-rw-r--r--  1 root root  337400 May 25 02:30 iwlwifi-5150-2.ucode
-rw-r--r--  1 root root  454608 May 25 02:30 iwlwifi-6000-4.ucode
-rw-r--r--  1 root root  444128 May 25 02:30 iwlwifi-6000g2a-5.ucode
-rw-r--r--  1 root root  677296 May 25 02:30 iwlwifi-6000g2a-6.ucode
-rw-r--r--  1 root root  460236 May 25 02:30 iwlwifi-6000g2b-5.ucode
-rw-r--r--  1 root root  679436 May 25 02:30 iwlwifi-6000g2b-6.ucode
-rw-r--r--  1 root root  463692 May 25 02:30 iwlwifi-6050-4.ucode
-rw-r--r--  1 root root  469780 May 25 02:30 iwlwifi-6050-5.ucode




I have tried enabling the following module parameters:

root@fl1ght:~# cat /etc/modprobe.d/iwlwifi.conf |grep option
#options iwlwifi 11n_disable=1 swcrypto=2 power_save=0

I had the exact same issue. Suddenly the interface just drops. Looking
in dmesg I get the following output:

May 27 05:26:49 fl1ght kernel: [17458.429125] iwlwifi 0000:01:00.0: Q
18 is active and mapped to fifo 2 ra_tid 0xa5a5 [90,1515870810]
May 27 05:26:49 fl1ght kernel: [17458.466540] ------------[ cut here
]------------
May 27 05:26:49 fl1ght kernel: [17458.466559] WARNING: at
/home/apw/COD/linux/drivers/net/wireless/iwlwifi/iwl-trans.h:757
iwl_trans_pcie_wait_txq_empty+0x36f/0x3e0 [iwlwifi]()
May 27 05:26:49 fl1ght kernel: [17458.466561] Modules linked in:
joydev uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core
videodev btusb snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_
hwdep snd_pcm snd_page_alloc dell_wmi sparse_keymap snd_seq_midi
snd_seq_midi_event snd_rawmidi snd_seq dell_laptop arc4 dcdbas
snd_seq_device snd_timer iwldvm intel_powerclamp mac80211 coretemp
kvm_intel snd kvm iwlwif
i cfg80211 psmouse serio_raw soundcore lpc_ich bnep rfcomm bluetooth
parport_pc ppdev mac_hid nfsd auth_rpcgss nfs_acl nfs lockd
binfmt_misc sunrpc fscache lp parport dm_crypt crc32_pclmul
ghash_clmulni_intel i915 aesni
_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper i2c_algo_bit
cryptd drm_kms_helper microcode drm ahci libahci wmi video [last
unloaded: ipmi_msghandler]
May 27 05:26:49 fl1ght kernel: [17458.466599] CPU: 0 PID: 9760 Comm:
kworker/u16:1 Tainted: G        W    3.10.0-999-generic #201305240428
May 27 05:26:49 fl1ght kernel: [17458.466601] Hardware name: Dell Inc.
         Dell System XPS L322X/0PJHXN, BIOS A08 04/18/2013
May 27 05:26:49 fl1ght kernel: [17458.466616] Workqueue: phy0
ieee80211_iface_work [mac80211]
May 27 05:26:49 fl1ght kernel: [17458.466618]  ffffffffa030d6b8
ffff88017398fa58 ffffffff816c1fc8 ffff88017398fa98
May 27 05:26:49 fl1ght kernel: [17458.466621]  ffffffff81044c70
ffff8802301b4000 ffff88023142b000 ffff8802301b4000
May 27 05:26:49 fl1ght kernel: [17458.466623]  0000000000000013
0000000000a02e80 0000000000000806 ffff88017398faa8
May 27 05:26:49 fl1ght kernel: [17458.466626] Call Trace:
May 27 05:26:49 fl1ght kernel: [17458.466634]  [<ffffffff816c1fc8>]
dump_stack+0x19/0x1b
May 27 05:26:49 fl1ght kernel: [17458.466638]  [<ffffffff81044c70>]
warn_slowpath_common+0x70/0xa0
May 27 05:26:49 fl1ght kernel: [17458.466641]  [<ffffffff81044cba>]
warn_slowpath_null+0x1a/0x20
May 27 05:26:49 fl1ght kernel: [17458.466648]  [<ffffffffa02fc03f>]
iwl_trans_pcie_wait_txq_empty+0x36f/0x3e0 [iwlwifi]
May 27 05:26:49 fl1ght kernel: [17458.466656]  [<ffffffffa0457b7e>]
iwlagn_mac_flush+0xae/0x1b0 [iwldvm]
May 27 05:26:49 fl1ght kernel: [17458.466668]  [<ffffffffa053eca2>]
ieee80211_flush_queues+0xc2/0x180 [mac80211]
May 27 05:26:49 fl1ght kernel: [17458.466677]  [<ffffffffa05278d6>]
__ieee80211_recalc_idle+0xf6/0x130 [mac80211]
May 27 05:26:49 fl1ght kernel: [17458.466687]  [<ffffffffa0528078>]
ieee80211_recalc_idle+0x18/0x30 [mac80211]
May 27 05:26:49 fl1ght kernel: [17458.466698]  [<ffffffffa0542802>]
ieee80211_free_chanctx+0xe2/0x210 [mac80211]
May 27 05:26:49 fl1ght kernel: [17458.466708]  [<ffffffffa05437ab>]
__ieee80211_vif_release_channel+0x5b/0x70 [mac80211]
May 27 05:26:49 fl1ght kernel: [17458.466718]  [<ffffffffa0543b31>]
ieee80211_vif_release_channel+0x51/0x70 [mac80211]
May 27 05:26:49 fl1ght kernel: [17458.466732]  [<ffffffffa05561c7>]
ieee80211_set_disassoc+0x267/0x3c0 [mac80211]
May 27 05:26:49 fl1ght kernel: [17458.466748]  [<ffffffffa055720e>]
ieee80211_sta_connection_lost.isra.25.constprop.26+0x3e/0x80
[mac80211]
May 27 05:26:49 fl1ght kernel: [17458.466765]  [<ffffffffa055899a>]
ieee80211_sta_work+0x47a/0x490 [mac80211]
May 27 05:26:49 fl1ght kernel: [17458.466780]  [<ffffffffa05276e8>]
ieee80211_iface_work+0x2b8/0x350 [mac80211]
May 27 05:26:49 fl1ght kernel: [17458.466786]  [<ffffffff81064114>]
process_one_work+0x174/0x490
May 27 05:26:49 fl1ght kernel: [17458.466789]  [<ffffffff8106513b>]
worker_thread+0x11b/0x370
May 27 05:26:49 fl1ght kernel: [17458.466792]  [<ffffffff81065020>] ?
manage_workers.isra.20+0x160/0x160
May 27 05:26:49 fl1ght kernel: [17458.466796]  [<ffffffff8106b890>]
kthread+0xc0/0xd0
May 27 05:26:49 fl1ght kernel: [17458.466799]  [<ffffffff8106b7d0>] ?
flush_kthread_worker+0xb0/0xb0
May 27 05:26:49 fl1ght kernel: [17458.466803]  [<ffffffff816d5adc>]
ret_from_fork+0x7c/0xb0
May 27 05:26:49 fl1ght kernel: [17458.466807]  [<ffffffff8106b7d0>] ?
flush_kthread_worker+0xb0/0xb0
May 27 05:26:49 fl1ght kernel: [17458.466808] ---[ end trace
e108a1b1cb4883b9 ]---

May 27 05:26:49 fl1ght kernel: [17458.504367] iwlwifi 0000:01:00.0: Q
19 is active and mapped to fifo 2 ra_tid 0xa5a5 [90,1515870810]
May 27 05:26:51 fl1ght kernel: [17460.502865] iwlwifi 0000:01:00.0:
Error sending POWER_TABLE_CMD: time out after 2000ms.
May 27 05:26:51 fl1ght kernel: [17460.502882] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 204
May 27 05:26:51 fl1ght kernel: [17460.502890] iwlwifi 0000:01:00.0:
set power fail, ret = -110
May 27 05:26:53 fl1ght kernel: [17462.505175] iwlwifi 0000:01:00.0:
Error sending REPLY_RXON: time out after 2000ms.
May 27 05:26:53 fl1ght kernel: [17462.505198] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 205
May 27 05:26:53 fl1ght kernel: [17462.505215] iwlwifi 0000:01:00.0:
Error clearing ASSOC_MSK on BSS (-110)
May 27 05:26:55 fl1ght kernel: [17464.535431] iwlwifi 0000:01:00.0:
Error sending REPLY_ADD_STA: time out after 2000ms.
May 27 05:26:55 fl1ght kernel: [17464.535443] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 206
May 27 05:26:55 fl1ght kernel: [17464.535454] wlan0: failed to remove
key (1, ff:ff:ff:ff:ff:ff) from hardware (-110)
May 27 05:26:57 fl1ght kernel: [17466.537735] iwlwifi 0000:01:00.0:
Error sending REPLY_ADD_STA: time out after 2000ms.
May 27 05:26:57 fl1ght kernel: [17466.537749] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 207
May 27 05:26:57 fl1ght kernel: [17466.537760] wlan0: failed to remove
key (2, ff:ff:ff:ff:ff:ff) from hardware (-110)
May 27 05:26:57 fl1ght kernel: [17466.537986] cfg80211: Calling CRDA
to update world regulatory domain
May 27 05:26:59 fl1ght kernel: [17468.540019] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:26:59 fl1ght kernel: [17468.540042] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 208
May 27 05:26:59 fl1ght kernel: [17468.540868] cfg80211: World
regulatory domain updated:
May 27 05:26:59 fl1ght kernel: [17468.540884] cfg80211:   (start_freq
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 27 05:26:59 fl1ght kernel: [17468.540895] cfg80211:   (2402000 KHz
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 27 05:26:59 fl1ght kernel: [17468.540906] cfg80211:   (2457000 KHz
- 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 27 05:26:59 fl1ght kernel: [17468.540914] cfg80211:   (2474000 KHz
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 27 05:26:59 fl1ght kernel: [17468.540922] cfg80211:   (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 27 05:26:59 fl1ght kernel: [17468.540931] cfg80211:   (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 27 05:27:02 fl1ght kernel: [17471.543442] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:27:02 fl1ght kernel: [17471.543457] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 209
May 27 05:27:05 fl1ght kernel: [17474.546839] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:27:05 fl1ght kernel: [17474.546861] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 210
May 27 05:27:08 fl1ght kernel: [17477.550214] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:27:08 fl1ght kernel: [17477.550226] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 211
May 27 05:27:11 fl1ght kernel: [17480.553636] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:27:11 fl1ght kernel: [17480.553649] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 212
May 27 05:27:14 fl1ght kernel: [17483.556987] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:27:14 fl1ght kernel: [17483.556993] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 213
May 27 05:27:16 fl1ght kernel: [17485.623380] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:27:16 fl1ght kernel: [17485.623398] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 214
May 27 05:27:19 fl1ght kernel: [17488.378470] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:27:19 fl1ght kernel: [17488.378500] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 215
May 27 05:27:42 fl1ght kernel: [17511.404648] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:27:42 fl1ght kernel: [17511.404663] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 217
May 27 05:28:15 fl1ght kernel: [17544.442184] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:28:15 fl1ght kernel: [17544.442197] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 218
May 27 05:28:58 fl1ght kernel: [17587.495041] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:28:58 fl1ght kernel: [17587.495054] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 219
May 27 05:29:51 fl1ght kernel: [17640.551248] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:29:51 fl1ght kernel: [17640.551261] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 220
May 27 05:30:54 fl1ght kernel: [17703.626831] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:30:54 fl1ght kernel: [17703.626845] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 221
May 27 05:31:57 fl1ght kernel: [17766.694371] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:31:57 fl1ght kernel: [17766.694395] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 222
May 27 05:33:00 fl1ght kernel: [17829.766005] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:33:00 fl1ght kernel: [17829.766018] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 223
May 27 05:34:03 fl1ght kernel: [17892.837530] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:34:03 fl1ght kernel: [17892.837543] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 224
May 27 05:35:06 fl1ght kernel: [17955.909130] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: time out after 2000ms.
May 27 05:35:06 fl1ght kernel: [17955.909143] iwlwifi 0000:01:00.0:
Current CMD queue read_ptr 195 write_ptr 225

May 27 05:36:07 fl1ght kernel: [18016.983211] iwlwifi 0000:01:00.0: No
space in command queue
May 27 05:36:07 fl1ght kernel: [18016.983229] iwlwifi 0000:01:00.0:
Restarting adapter queue is full
May 27 05:36:07 fl1ght kernel: [18016.983256] iwlwifi 0000:01:00.0:
Error sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
May 27 05:36:14 fl1ght kernel: [18018.876449] iwlwifi 0000:01:00.0:
Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 27 05:36:14 fl1ght kernel: [18020.787884] iwlwifi 0000:01:00.0:
Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 27 05:36:14 fl1ght kernel: [18022.735845] iwlwifi 0000:01:00.0:
Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 27 05:36:14 fl1ght kernel: [18024.647588] iwlwifi 0000:01:00.0:
Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 27 05:36:16 fl1ght kernel: [18026.525552] ieee80211 phy0: Hardware
restart was requested
May 27 05:36:16 fl1ght kernel: [18026.525631] iwlwifi 0000:01:00.0: L1
Disabled; Enabling L0S
May 27 05:36:16 fl1ght kernel: [18026.580811] iwlwifi 0000:01:00.0:
Radio type=0x2-0x1-0x0
May 27 05:36:30 fl1ght kernel: [18032.307919] iwlwifi 0000:01:00.0:
Failed to load firmware chunk!
May 27 05:36:30 fl1ght kernel: [18032.307932] iwlwifi 0000:01:00.0:
Could not load the [0] uCode section
May 27 05:36:30 fl1ght kernel: [18032.307943] iwlwifi 0000:01:00.0:
Failed to start RT ucode: -110
May 27 05:36:30 fl1ght kernel: [18034.200860] iwlwifi 0000:01:00.0:
Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 27 05:36:30 fl1ght kernel: [18036.119354] iwlwifi 0000:01:00.0:
Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 27 05:36:30 fl1ght kernel: [18038.079627] iwlwifi 0000:01:00.0:
Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 27 05:36:30 fl1ght kernel: [18040.001556] iwlwifi 0000:01:00.0:
Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 27 05:36:31 fl1ght kernel: [18041.888305] iwlwifi 0000:01:00.0:
Unable to initialize device.


At the end you will notice Failed to load firmware chunk. I do an
rmmod iwldvm and iwlwifi and the modules are successfully removed and
I can then reinsert both modules but the wireless interface completely
disappears and dmesg says that it could not load the firmware.

root@fl1ght:/var/log# dmesg |grep -i firmware
[    0.143458] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[   44.270456] iwlwifi 0000:01:00.0: loaded firmware version
18.168.6.1 op_mode iwldvm
[26486.356816] iwlwifi 0000:01:00.0: Failed to load firmware chunk!

Ive also noticed the onboard touchpad acts extremely weird and I end
up being forced to do a reboot (if I have external / mice keyboard and
usb ethernet adaptor everything is fine it runs normally -- when the
laptop has nothing plugged in and the wireless dies the laptop begins
to stall and needs to be rebooted - not sure why this other than the
kernel module crashing. )

The wireless usually works fine for at least a few hours, before this
happens. I can suspend and resume just fine everything works, but left
on  and using wireless for a few hours it suddenly does this, in fact
the time it takes is completely random as well.

I am not sure at this point if it is a faulty wireless card or driver
/ firmware related.

The dell laptop itself has had the latest firmware installed (A08)
downloaded and installed from the dell support site.

Any help you could provide I would greatly appreciate, I can provide
you with any further information you require.

Thank you in advance,

Kind Regards,

Vamegh Hedayati
