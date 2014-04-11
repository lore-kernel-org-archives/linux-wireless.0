Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35953 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaDKTzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 15:55:51 -0400
Received: by mail-ig0-f171.google.com with SMTP id c1so1233831igq.10
        for <linux-wireless@vger.kernel.org>; Fri, 11 Apr 2014 12:55:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2710039777.20140411192110@eikelenboom.it>
References: <1397219374-3280-1-git-send-email-janusz.dziedzic@tieto.com>
	<2710039777.20140411192110@eikelenboom.it>
Date: Fri, 11 Apr 2014 21:55:50 +0200
Message-ID: <CAFED-jkPtXU8moGrb4XiriU-c7WokgSiXq6g0jCLOhk3dJnoLg@mail.gmail.com> (sfid-20140411_215618_725651_B0793D9B)
Subject: Re: [RFC/RFT] cfg80211: reg: track crda request
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>, collen@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-04-11 19:21 GMT+02:00 Sander Eikelenboom <linux@eikelenboom.it>:
>
> Friday, April 11, 2014, 2:29:34 PM, you wrote:
>
>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>> ---
>> This is instead of:
>> cfg80211: fix processing world regdomain when non modular
>
>> @Sander @Colleen - could you chec this one?
>
> I applied this as a single patch onto 3.15-mergewindow and this one doesn't work
> for me (Luis patchset does work for me), somehow it doesn't seem to be able to set the initial domain:
>
> [    8.492292] libipw: 802.11 data/management/control stack, git-1.1.13
> [    8.492293] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
> [    8.492293] Intel(R) Wireless WiFi driver for Linux, in-tree:
> [    8.492293] Copyright(c) 2003- 2014 Intel Corporation
> [    8.656243] iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:
> [    8.656244] iwl4965: Copyright(c) 2003-2011 Intel Corporation
> [    8.656267] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
> [    8.656268] iwl3945: Copyright(c) 2003-2011 Intel Corporation
> [    8.656282] xen_netfront: Initialising Xen virtual ethernet driver
> [    8.656768] iwlwifi 0000:00:05.0: loaded firmware version 18.168.6.1 op_mode iwldvm
> [    8.656781] iwlwifi 0000:00:05.0: CONFIG_IWLWIFI_DEBUG disabled
> [    8.656783] iwlwifi 0000:00:05.0: CONFIG_IWLWIFI_DEBUGFS disabled
> [    8.656784] iwlwifi 0000:00:05.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> [    8.656786] iwlwifi 0000:00:05.0: Detected Intel(R) Centrino(R) Advanced-N 6235 AGN, REV=0xB0
> [    8.657277] iwlwifi 0000:00:05.0: L1 Disabled; Enabling L0S
> [    8.748141] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    8.748142] ehci-pci: EHCI PCI platform driver
> [    8.748168] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    8.748177] ohci-pci: OHCI PCI platform driver
> [    8.748193] ohci-platform: OHCI generic platform driver
> [    8.748208] uhci_hcd: USB Universal Host Controller Interface driver
> [    8.851536] usbcore: registered new interface driver usb-storage
> [    8.851582] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> [    8.857493] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    8.857500] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    8.857587] hv_vmbus: registering driver hyperv_keyboard
> [    8.857689] mousedev: PS/2 mouse device common for all mice
> [    8.860082] input: AT Raw Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
> [    8.861546] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
> [    8.861634] rtc_cmos 00:04: alarms up to one day, 114 bytes nvram, hpet irqs
> [    8.861839] i2c /dev entries driver
> [    8.862186] piix4_smbus 0000:00:01.3: SMBus Host Controller not enabled!
> [    8.862241] pps_ldisc: PPS line discipline registered
> [    8.865539] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
> [    8.865600] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [    8.865609] iTCO_vendor_support: vendor-support=0
> [    8.865610] xen_wdt: Xen WatchDog Timer Driver v0.01
> [    8.865692] xen_wdt: initialized (timeout=60s, nowayout=0)
> [    8.865701] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
> [    8.865702] watchdog: Software Watchdog: a legacy watchdog module is probably present.
> [    8.865742] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
> [    9.207187] device-mapper: uevent: version 1.0.3
> [    9.488036] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
> [    9.887271] device-mapper: multipath: version 1.7.0 loaded
> [    9.887274] device-mapper: multipath round-robin: version 1.0.0 loaded
> [   10.179352] leds_ss4200: no LED devices found
> [   10.179378] hidraw: raw HID events driver (C) Jiri Kosina
> [   10.179529] usbcore: registered new interface driver usbhid
> [   10.179529] usbhid: USB HID core driver
> [   10.179534] hv_utils: Registering HyperV Utility Driver
> [   10.179536] hv_vmbus: registering driver hv_util
> [   10.179612] usbcore: registered new interface driver snd-usb-audio
> [   10.179626] usbcore: registered new interface driver snd-ua101
> [   10.179641] usbcore: registered new interface driver snd-usb-usx2y
> [   10.179657] usbcore: registered new interface driver snd-usb-us122l
> [   10.179674] usbcore: registered new interface driver snd-usb-caiaq
> [   10.179696] usbcore: registered new interface driver snd-usb-6fire
> [   10.179713] usbcore: registered new interface driver snd-usb-hiface
> [   10.179721] drop_monitor: Initializing network drop monitor service
> [   10.179745] GACT probability on
> [   10.179746] Mirror/redirect action on
> [   10.179748] Simple TC action Loaded
> [   10.179877] netem: version 1.3
> [   10.179878] u32 classifier
> [   10.179879]     Performance counters on
> [   10.179879]     input device check on
> [   10.179879]     Actions configured
> [   10.179883] Netfilter messages via NETLINK v0.30.
> [   10.179886] nfnl_acct: registering with nfnetlink.
> [   10.179895] nf_conntrack version 0.5.0 (3812 buckets, 15248 max)
> [   10.363970] ctnetlink v0.93: registering with nfnetlink.
> [   10.721587] xt_time: kernel timezone is -0000
> [   10.721589] ip_set: protocol 6
> [   10.721595] IPVS: Registered protocols (TCP, UDP, SCTP, AH, ESP)
> [   10.815483] IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
> [   10.815524] IPVS: Creating netns size=2048 id=0
> [   10.815536] IPVS: ipvs loaded.
> [   10.815537] IPVS: [rr] scheduler registered.
> [   10.815538] IPVS: [wrr] scheduler registered.
> [   10.815539] IPVS: [lc] scheduler registered.
> [   10.815539] IPVS: [wlc] scheduler registered.
> [   10.815543] IPVS: [lblc] scheduler registered.
> [   10.815545] IPVS: [lblcr] scheduler registered.
> [   10.815546] IPVS: [dh] scheduler registered.
> [   10.815546] IPVS: [sh] scheduler registered.
> [   10.815547] IPVS: [sed] scheduler registered.
> [   10.815547] IPVS: [nq] scheduler registered.
> [   10.815639] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   10.815699] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
> [   10.815714] arp_tables: (C) 2002 David S. Miller
> [   10.815732] TCP: cubic registered
> [   10.815733] Initializing XFRM netlink socket
> [   10.815738] NET: Registered protocol family 17
> [   10.815744] NET: Registered protocol family 15
> [   10.903989] Ebtables v2.0 registered
> [   16.972127] random: nonblocking pool is initialized
> [   18.164092] [sched_delayed] sched: RT throttling activated
> [   18.219157] cfg80211: Calling CRDA to update world regulatory domain
> [   18.300211] NET: Registered protocol family 33
> [   18.369824] Key type rxrpc registered
> [   18.422370] Key type rxrpc_s registered
> [   18.473663] 8021q: 802.1Q VLAN Support v1.8
> [   18.523017] lib80211: common routines for IEEE802.11 drivers
> [   18.574402] Key type dns_resolver registered
> [   18.622013] openvswitch: Open vSwitch switching datapath
> [   18.674762] registered taskstats version 1
> [   18.732965] Btrfs loaded
> [   18.791101] xenbus_probe_frontend: Device with no driver: device/vkbd/0
> [   18.852883] xenbus_probe_frontend: Device with no driver: device/pci/0
> [   18.905176] console [netcon0] enabled
> [   18.958757] netconsole: network logging started
> [   19.026602] rtc_cmos 00:04: setting system clock to 2014-04-11 19:11:51 UTC (1397243511)
> [   19.148159] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [   19.221561] EDD information not available.
> [   19.297754] ALSA device list:
> [   19.367650]   No soundcards found.
> [   19.437876] Freeing unused kernel memory: 1140K (ffffffff81f2b000 - ffffffff82048000)
> [   19.576458] Write protecting the kernel read-only data: 14336k
> [   19.654147] Freeing unused kernel memory: 844K (ffff88000192d000 - ffff880001a00000)
> [   19.808901] Freeing unused kernel memory: 296K (ffff880001db6000 - ffff880001e00000)
> Loading, please wait...
> [   19.974135] udevd[181]: starting version 175
> Begin: Loading essential drivers ... done.
> Begin: Running /scripts/init-premount ... done.
> Begin: Mounting root file system ... Begin: Running /scripts/local-top ...   Volume group "creabox" not found
>   Skipping volume group creabox
> Unable to find LVM volume creabox/creabox_swap
> done.
> Begin: Running /scripts/local-premount ... done.
> [   20.259586] EXT4-fs (xvda2): warning: mounting unchecked fs, running e2fsck is recommended
> [   20.425150] EXT4-fs (xvda2): mounted filesystem without journal. Opts: (null)
> Begin: Running /scripts/local-bottom ... done.
> done.
> Begin: Running /scripts/init-bottom ... done.
> procd: Console is alive
> procd: - watchdog -
> procd: - preinit -
> Press the [f] key and hit [enter] to enter failsafe mode
> Press the [1], [2], [3] or [4] key and hit [enter] to select the debug level
> [   21.428177] cfg80211: Calling CRDA to update world regulatory domain
> mount_root: mounting /dev/root
> [   23.681772] EXT4-fs (xvda2): re-mounted. Opts: (null)
> mount: mounting 1 on /mnt failed: No such file or directory
> mv: can't rename '/mnt/sysupgrade.tgz': No such file or directory
> umount: can't umount /mnt: Invalid argument
> procd: - early -
> procd: - watchdog -
> procd: - ubus -
> procd: - init -
> Please press Enter to activate this console.
> [   24.676227] cfg80211: Calling CRDA to update world regulatory domain
> procd: - init complete -
> [   25.743753] device eth0 entered promiscuous mode
> [   25.837701] br-lan: port 1(eth0) entered forwarding state
> [   25.927344] br-lan: port 1(eth0) entered forwarding state
> [   27.112645] iwlwifi 0000:00:05.0: L1 Disabled; Enabling L0S
> [   27.213610] iwlwifi 0000:00:05.0: Radio type=0x2-0x1-0x0
> [   27.588361] iwlwifi 0000:00:05.0: L1 Disabled; Enabling L0S
> [   27.704274] iwlwifi 0000:00:05.0: Radio type=0x2-0x1-0x0
> [   27.882909] device wlan0 entered promiscuous mode
> [   27.988091] cfg80211: Calling CRDA to update world regulatory domain
> [   29.094996] br-lan: port 2(wlan0) entered forwarding state
> [   29.208669] br-lan: port 2(wlan0) entered forwarding state
> [   31.228267] cfg80211: Calling CRDA to update world regulatory domain
> [   34.468228] cfg80211: Calling CRDA to update world regulatory domain
> [   37.724294] cfg80211: Calling CRDA to update world regulatory domain
> [   40.956212] br-lan: port 1(eth0) entered forwarding state
> [   40.972164] cfg80211: Calling CRDA to update world regulatory domain
> [   44.124328] cfg80211: Calling CRDA to update world regulatory domain
> [   44.252127] br-lan: port 2(wlan0) entered forwarding state
> [   47.364252] cfg80211: Calling CRDA to update world regulatory domain
> [   50.604271] cfg80211: Calling CRDA to update world regulatory domain
> [   53.836240] cfg80211: Calling CRDA to update world regulatory domain
>
> <big snip>
>
> [  221.132223] cfg80211: Calling CRDA to update world regulatory domain
> [  224.332269] cfg80211: Calling CRDA to update world regulatory domain
> [  227.532277] cfg80211: Calling CRDA to update world regulatory domain
> [  230.748282] cfg80211: Calling CRDA to update world regulatory domain
>
>
Thanks for test :)
Are you using CONFIG_CFG80211_INTERNAL_REGDB?
I will check this option also (could be I miss cancel timeout in case
of internal regdb or 00 wasn't set correctly in db.txt).
Could you also send db.txt from net/wireless if INTERNAL_REGDB?

In case you don't use internal regdb, are you sure you choose/install
crda from menuconfig? It looks like you don't have /(s)bin/crda? Could
you confirm you have crda command installed and could be executed (I
could reproduce exactly same messages when remove +x from crda).

In case you don't use internal_regdb + db.txt nor crda I think Luis
patch could just hide problem while remove "Pending regulatory ..."
print.

With Luis patch what you see after:
iw reg set PL
iw reg get

BR
Janusz
