Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43158 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1I3XmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 19:42:18 -0400
Received: by qyk7 with SMTP id 7so2373217qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Sep 2011 16:42:17 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 30 Sep 2011 16:41:57 -0700
Message-ID: <CAB=NE6Ug-wF+UMC3fLkrcb43x94_Pc0DeK51pDnVnDckiyshAQ@mail.gmail.com> (sfid-20111001_014222_997651_D5531705)
Subject: iwlagn rmmod BUG iwlagn_dev_cmd: Objects remaining on kmem_cache_close()
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While I rmmod iwlagn, I get this.

mcgrof@tux ~ $ uname -r
3.1.0-rc5-wl+

[   18.925738] iwlagn 0000:03:00.0: loaded firmware version 9.221.4.1
build 25532
[   18.928240] Registered led device: phy0-led
[   18.928533] cfg80211: Ignoring regulatory request Set by core since
the driver uses its own custom regulatory domain
[   18.929829] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   18.941901] input: ThinkPad Extra Buttons as
/devices/platform/thinkpad_acpi/input/input9
[   19.016856] udev[382]: renamed network interface wlan0 to wlan8
[   19.019627] iwlagn 0000:03:00.0: L1 Disabled; Enabling L0S
[   19.019755] iwlagn 0000:03:00.0: Radio type=0x1-0x3-0x1
[   19.257317] iwlagn 0000:03:00.0: L1 Disabled; Enabling L0S
[   19.257447] iwlagn 0000:03:00.0: Radio type=0x1-0x3-0x1
[   19.352187] ieee80211 phy0: device now idle
[   19.365350] ADDRCONF(NETDEV_UP): wlan8: link is not ready
[   19.429844] ieee80211 phy0: device no longer idle - scanning
[   20.346536] EXT4-fs (sda1): re-mounted. Opts:
errors=remount-ro,user_xattr,commit=0
[   20.395747] checking generic (d0000000 3f0000) vs hw (d0000000 10000000)
[   20.395750] fb: conflicting fb hw usage inteldrmfb vs VESA VGA -
removing generic driver
[   20.395920] Console: switching to colour dummy device 80x25
[   20.397297] fbcon: inteldrmfb (fb0) is primary device
[   20.397865] Console: switching to colour frame buffer device 180x56
[   20.397872] fb0: inteldrmfb frame buffer device
[   20.397873] drm: registered panic notifier
[   20.627535] acpi device:02: registered as cooling_device4
[   20.655823] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10
[   20.656457] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   20.657053] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   20.770262] ppdev: user-space parallel port driver
[   22.085036] cfg80211: Found new beacon on frequency: 5745 MHz (Ch
149) on phy0
[   22.567306] ieee80211 phy0: device now idle
[   25.135394] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   25.392278] input: TPPS/2 IBM TrackPoint as
/devices/platform/i8042/serio1/serio2/input/input11
[   35.114291] hda-intel: Invalid position buffer, using LPIB read
method instead.
[   35.124068] hda-intel: Invalid position buffer, using LPIB read
method instead.
[   35.298915] hda-intel: IRQ timing workaround is activated for card
#0. Suggest a bigger bdl_pos_adj.
[   39.177463] ieee80211 phy0: device no longer idle - scanning
[   39.281338] EXT4-fs (sda1): re-mounted. Opts:
errors=remount-ro,user_xattr,commit=0
[   42.319521] ieee80211 phy0: device now idle
[  132.085933] ieee80211 phy0: device no longer idle - scanning
[  135.458783] ieee80211 phy0: device now idle
[  135.463938] ieee80211 phy0: device no longer idle - working
[  135.466849] wlan8: authenticate with 68:7f:74:3b:b1:0f (try 1)
[  135.472508] wlan8: authenticated
[  135.472680] ieee80211 phy0: Allocated STA 68:7f:74:3b:b1:0f
[  135.472689] ieee80211 phy0: Inserted dummy STA 68:7f:74:3b:b1:0f
[  135.475839] wlan8: associate with 68:7f:74:3b:b1:0f (try 1)
[  135.482033] wlan8: RX AssocResp from 68:7f:74:3b:b1:0f (capab=0x411
status=0 aid=2)
[  135.482036] wlan8: associated
[  135.482609] ieee80211 phy0: Inserted STA 68:7f:74:3b:b1:0f
[  135.482613] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15
cWmax=1023 txop=0 uapsd=0
[  135.482616] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15
cWmax=1023 txop=0 uapsd=0
[  135.482619] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7
cWmax=15 txop=94 uapsd=0
[  135.482621] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3
cWmax=7 txop=47 uapsd=0
[  135.487047] ADDRCONF(NETDEV_CHANGE): wlan8: link becomes ready
[  135.488063] Rx A-MPDU request on tid 0 result 0
[  144.357086] Open BA session requested for 68:7f:74:3b:b1:0f tid 0
[  144.426737] activated addBA response timer on tid 0
[  144.428615] switched off addBA timer for tid 0
[  144.428618] Aggregation is on for tid 0
[  144.428758] iwlagn 0000:03:00.0: Tx aggregation enabled on ra =
68:7f:74:3b:b1:0f tid = 0
[  563.427696] Open BA session requested for 68:7f:74:3b:b1:0f tid 6
[  563.428179] activated addBA response timer on tid 6
[  563.430054] switched off addBA timer for tid 6
[  563.430058] Aggregation is on for tid 6
[  563.430198] iwlagn 0000:03:00.0: Tx aggregation enabled on ra =
68:7f:74:3b:b1:0f tid = 6
[ 1274.053879] ieee80211 phy0: wlan8: No ack for nullfunc frame to AP
68:7f:74:3b:b1:0f, try 1/2
[ 1274.058786] ieee80211 phy0: wlan8: No ack for nullfunc frame to AP
68:7f:74:3b:b1:0f, disconnecting.
[ 1274.058807] Tx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 1274.058820] Rx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 1274.058948] Tx BA session stop requested for 68:7f:74:3b:b1:0f tid 6
[ 1274.063782] Tx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 1274.063793] iwlagn 0000:03:00.0: Stopping AGG while state not ONor starting
[ 1274.063937] Tx BA session stop requested for 68:7f:74:3b:b1:0f tid 6
[ 1274.063944] iwlagn 0000:03:00.0: Stopping AGG while state not ONor starting
[ 1274.212659] ieee80211 phy0: Removed STA 68:7f:74:3b:b1:0f
[ 1274.212848] ieee80211 phy0: Destroyed STA 68:7f:74:3b:b1:0f
[ 1274.212872] ieee80211 phy0: device now idle
[ 1274.262722] Stopping Tx BA session for 68:7f:74:3b:b1:0f tid 6
[ 1274.262728] Could not find station: 68:7f:74:3b:b1:0f
[ 1274.262763] Stopping Tx BA session for 68:7f:74:3b:b1:0f tid 0
[ 1274.262768] Could not find station: 68:7f:74:3b:b1:0f
[ 1274.262803] Stopping Tx BA session for 68:7f:74:3b:b1:0f tid 0
[ 1274.262808] Could not find station: 68:7f:74:3b:b1:0f
[ 1274.262841] Stopping Tx BA session for 68:7f:74:3b:b1:0f tid 6
[ 1274.262846] Could not find station: 68:7f:74:3b:b1:0f
[ 1274.263312] cfg80211: All devices are disconnected, going to
restore regulatory settings
[ 1274.263334] cfg80211: Restoring regulatory settings
[ 1274.263391] cfg80211: Calling CRDA to update world regulatory domain
[ 1274.280759] cfg80211: Ignoring regulatory request Set by core since
the driver uses its own custom regulatory domain
[ 1274.280766] cfg80211: World regulatory domain updated:
[ 1274.280769] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 1274.280774] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(600 mBi, 2000 mBm)
[ 1274.363721] ieee80211 phy0: device no longer idle - scanning
[ 1277.606397] ieee80211 phy0: device now idle
[ 1277.611446] ieee80211 phy0: device no longer idle - working
[ 1277.614321] wlan8: authenticate with 68:7f:74:3b:b1:0f (try 1)
[ 1277.617086] wlan8: authenticated
[ 1277.617193] ieee80211 phy0: Allocated STA 68:7f:74:3b:b1:0f
[ 1277.617201] ieee80211 phy0: Inserted dummy STA 68:7f:74:3b:b1:0f
[ 1277.618046] wlan8: associate with 68:7f:74:3b:b1:0f (try 1)
[ 1277.624327] wlan8: RX AssocResp from 68:7f:74:3b:b1:0f (capab=0x411
status=0 aid=2)
[ 1277.624333] wlan8: associated
[ 1277.625710] ieee80211 phy0: Inserted STA 68:7f:74:3b:b1:0f
[ 1277.625719] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15
cWmax=1023 txop=0 uapsd=0
[ 1277.625727] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15
cWmax=1023 txop=0 uapsd=0
[ 1277.625733] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7
cWmax=15 txop=94 uapsd=0
[ 1277.625738] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3
cWmax=7 txop=47 uapsd=0
[ 1277.629864] Rx A-MPDU request on tid 0 result 0
[ 1277.640505] iwlagn 0000:03:00.0: Queue 2 stuck for 2000 ms.
[ 1277.640513] iwlagn 0000:03:00.0: On demand firmware reload
[ 1277.640610] ieee80211 phy0: Hardware restart was requested
[ 1277.640668] iwlagn 0000:03:00.0: L1 Disabled; Enabling L0S
[ 1277.640797] iwlagn 0000:03:00.0: Radio type=0x1-0x3-0x1
[ 1277.749326] Rx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 1278.639143] Rx A-MPDU request on tid 0 result 0
[ 1291.825925] Open BA session requested for 68:7f:74:3b:b1:0f tid 0
[ 1291.826100] activated addBA response timer on tid 0
[ 1291.830332] switched off addBA timer for tid 0
[ 1379.437022] Aggregation is on for tid 0
[ 1379.437169] iwlagn 0000:03:00.0: Tx aggregation enabled on ra =
68:7f:74:3b:b1:0f tid = 0
[ 2233.422214] ieee80211 phy0: wlan8: No ack for nullfunc frame to AP
68:7f:74:3b:b1:0f, try 1/2
[ 3541.474353] wlan8: deauthenticated from 68:7f:74:3b:b1:0f (Reason: 16)
[ 3541.474367] Tx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 3541.474490] Rx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 3541.477062] Tx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 3541.477072] iwlagn 0000:03:00.0: Stopping AGG while state not ONor starting
[ 3541.719666] ieee80211 phy0: Removed STA 68:7f:74:3b:b1:0f
[ 3541.719803] ieee80211 phy0: Destroyed STA 68:7f:74:3b:b1:0f
[ 3541.719832] ieee80211 phy0: device now idle
[ 3541.890003] Stopping Tx BA session for 68:7f:74:3b:b1:0f tid 0
[ 3541.890009] Could not find station: 68:7f:74:3b:b1:0f
[ 3541.890029] Stopping Tx BA session for 68:7f:74:3b:b1:0f tid 0
[ 3541.890032] Could not find station: 68:7f:74:3b:b1:0f
[ 3541.890348] cfg80211: All devices are disconnected, going to
restore regulatory settings
[ 3541.890368] cfg80211: Restoring regulatory settings
[ 3541.890406] cfg80211: Calling CRDA to update world regulatory domain
[ 3541.906994] cfg80211: Ignoring regulatory request Set by core since
the driver uses its own custom regulatory domain
[ 3541.907000] cfg80211: World regulatory domain updated:
[ 3541.907003] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 3541.907008] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(600 mBi, 2000 mBm)
[ 3541.990694] ieee80211 phy0: device no longer idle - scanning
[ 3545.160488] cfg80211: Found new beacon on frequency: 5805 MHz (Ch
161) on phy0
[ 3545.301274] ieee80211 phy0: device now idle
[ 3545.303904] ieee80211 phy0: device no longer idle - working
[ 3545.306816] wlan8: authenticate with 68:7f:74:3b:b1:0f (try 1)
[ 3545.315795] wlan8: authenticated
[ 3545.315928] ieee80211 phy0: Allocated STA 68:7f:74:3b:b1:0f
[ 3545.315937] ieee80211 phy0: Inserted dummy STA 68:7f:74:3b:b1:0f
[ 3545.316681] ieee80211 phy0: device now idle
[ 3545.316736] ieee80211 phy0: device no longer idle - working
[ 3545.319321] wlan8: associate with 68:7f:74:3b:b1:0f (try 1)
[ 3545.325539] wlan8: RX AssocResp from 68:7f:74:3b:b1:0f (capab=0x411
status=0 aid=2)
[ 3545.325544] wlan8: associated
[ 3545.326821] ieee80211 phy0: Inserted STA 68:7f:74:3b:b1:0f
[ 3545.326826] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15
cWmax=1023 txop=0 uapsd=0
[ 3545.326831] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15
cWmax=1023 txop=0 uapsd=0
[ 3545.326834] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7
cWmax=15 txop=94 uapsd=0
[ 3545.326838] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3
cWmax=7 txop=47 uapsd=0
[ 3545.335917] Rx A-MPDU request on tid 0 result 0
[ 3551.260332] Open BA session requested for 68:7f:74:3b:b1:0f tid 0
[ 3551.355065] activated addBA response timer on tid 0
[ 3552.353772] addBA response timer expired on tid 0
[ 3552.353790] Tx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 3552.632503] switched off addBA timer for tid 0
[ 3552.632508] Aggregation is on for tid 0
[ 3552.632653] iwlagn 0000:03:00.0: Tx aggregation enabled on ra =
68:7f:74:3b:b1:0f tid = 0
[ 3552.632800] Stopping Tx BA session for 68:7f:74:3b:b1:0f tid 0
[ 3618.389134] Open BA session requested for 68:7f:74:3b:b1:0f tid 0
[ 3618.389323] activated addBA response timer on tid 0
[ 3618.393331] switched off addBA timer for tid 0
[ 3618.393335] Aggregation is on for tid 0
[ 3618.393477] iwlagn 0000:03:00.0: Tx aggregation enabled on ra =
68:7f:74:3b:b1:0f tid = 0

Then I decided to rmmod iwlagn

[ 3973.371031] Tx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 3973.371147] Rx BA session stop requested for 68:7f:74:3b:b1:0f tid 0
[ 3973.371189] Stopping Tx BA session for 68:7f:74:3b:b1:0f tid 0
[ 3973.371388] wlan8: deauthenticating from 68:7f:74:3b:b1:0f by local
choice (reason=3)
[ 3973.533339] ieee80211 phy0: Removed STA 68:7f:74:3b:b1:0f
[ 3973.533432] ieee80211 phy0: Destroyed STA 68:7f:74:3b:b1:0f
[ 3973.533445] ieee80211 phy0: device now idle
[ 3973.533490] cfg80211: All devices are disconnected, going to
restore regulatory settings
[ 3973.533502] cfg80211: Restoring regulatory settings
[ 3973.533532] cfg80211: Calling CRDA to update world regulatory domain
[ 3973.546604] cfg80211: Ignoring regulatory request Set by core since
the driver uses its own custom regulatory domain
[ 3973.546611] cfg80211: World regulatory domain updated:
[ 3973.546614] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 3973.546619] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(600 mBi, 2000 mBm)
[ 3975.237526] =============================================================================
[ 3975.237534] BUG iwlagn_dev_cmd: Objects remaining on kmem_cache_close()
[ 3975.237538] -----------------------------------------------------------------------------
[ 3975.237540]
[ 3975.237544] INFO: Slab 0xffffea0002a2bc00 objects=24 used=1
fp=0xffff8800a8af1480 flags=0x100000000004080
[ 3975.237551] Pid: 3118, comm: rmmod Not tainted 3.1.0-rc5-wl+ #21
[ 3975.237554] Call Trace:
[ 3975.237567]  [<ffffffff8114dddf>] slab_err+0xaf/0xd0
[ 3975.237574]  [<ffffffff8115135b>] ? __kmalloc+0x13b/0x1d0
[ 3975.237580]  [<ffffffff81152c00>] kmem_cache_destroy+0x1d0/0x3d0
[ 3975.237592]  [<ffffffffa0380767>] iwl_uninit_drv+0x37/0x70 [iwlagn]
[ 3975.237605]  [<ffffffffa03aa105>] iwl_remove+0x101/0x11d [iwlagn]
[ 3975.237617]  [<ffffffffa03aa14b>] iwl_pci_remove+0x2a/0x6d [iwlagn]
[ 3975.237625]  [<ffffffff813024e2>] pci_device_remove+0x52/0x120
[ 3975.237632]  [<ffffffff813b178c>] __device_release_driver+0x7c/0xe0
[ 3975.237637]  [<ffffffff813b1ed8>] driver_detach+0xc8/0xd0
[ 3975.237642]  [<ffffffff813b15e9>] bus_remove_driver+0x79/0xd0
[ 3975.237646]  [<ffffffff813b22d2>] driver_unregister+0x62/0xa0
[ 3975.237652]  [<ffffffff813025f5>] pci_unregister_driver+0x45/0xc0
[ 3975.237666]  [<ffffffffa039b195>]
iwl_pci_unregister_driver+0x15/0x20 [iwlagn]
[ 3975.237678]  [<ffffffffa03aa197>] iwl_exit+0x9/0x10 [iwlagn]
[ 3975.237684]  [<ffffffff810a193d>] sys_delete_module+0x18d/0x260
[ 3975.237690]  [<ffffffff8113445a>] ? do_munmap+0x2da/0x370
[ 3975.237699]  [<ffffffff815b0f75>] ? page_fault+0x25/0x30
[ 3975.237705]  [<ffffffff815b8982>] system_call_fastpath+0x16/0x1b
[ 3975.237714] INFO: Object 0xffff8800a8af1c30 @offset=7216
[ 3975.237724] INFO: Allocated in iwlagn_tx_skb+0xd6/0x810 [iwlagn]
age=269909 cpu=1 pid=884
[ 3975.237730] 	__slab_alloc+0x297/0x480
[ 3975.237734] 	kmem_cache_alloc+0x11f/0x170
[ 3975.237742] 	iwlagn_tx_skb+0xd6/0x810 [iwlagn]
[ 3975.237749] 	iwlagn_mac_tx+0x1a/0x30 [iwlagn]
[ 3975.237774] 	__ieee80211_tx+0x76/0x260 [mac80211]
[ 3975.237792] 	ieee80211_tx+0x8c/0xb0 [mac80211]
[ 3975.237809] 	ieee80211_xmit+0xbe/0x1e0 [mac80211]
[ 3975.237827] 	ieee80211_subif_start_xmit+0x3b1/0x8e0 [mac80211]
[ 3975.237833] 	dev_hard_start_xmit+0x2a1/0x6b0
[ 3975.237837] 	sch_direct_xmit+0xee/0x1e0
[ 3975.237841] 	dev_queue_xmit+0x18f/0x620
[ 3975.237846] 	packet_sendmsg+0xb26/0xb90
[ 3975.237851] 	sock_sendmsg+0xef/0x120
[ 3975.237855] 	sys_sendto+0x13d/0x190
[ 3975.237859] 	system_call_fastpath+0x16/0x1b
[ 3975.237871] INFO: Freed in iwlagn_rx_reply_tx+0x307/0x770 [iwlagn]
age=269909 cpu=2 pid=0
[ 3975.237877] 	__slab_free+0x1a7/0x2c0
[ 3975.237881] 	kmem_cache_free+0xe6/0xf0
[ 3975.237889] 	iwlagn_rx_reply_tx+0x307/0x770 [iwlagn]
[ 3975.237900] 	iwl_rx_dispatch+0x11f/0x130 [iwlagn]
[ 3975.237911] 	iwl_irq_tasklet+0x32c/0x830 [iwlagn]
[ 3975.237915] 	tasklet_action+0x6c/0x120
[ 3975.237919] 	__do_softirq+0xad/0x1d0
[ 3975.237924] 	call_softirq+0x1c/0x30
[ 3975.237929] 	do_softirq+0x65/0xa0
[ 3975.237932] 	irq_exit+0x8e/0xb0
[ 3975.237935] 	do_IRQ+0x66/0xe0
[ 3975.237940] 	ret_from_intr+0x0/0x15
[ 3975.237945] 	acpi_idle_enter_c1+0x8d/0xab
[ 3975.237950] 	cpuidle_idle_call+0xe9/0x1c0
[ 3975.237954] 	cpu_idle+0xc5/0x100
[ 3975.237958] 	start_secondary+0x1e0/0x1e7
[ 3975.237983] SLUB iwlagn_dev_cmd: kmem_cache_destroy called for
cache that still has objects.
[ 3975.237988] Pid: 3118, comm: rmmod Not tainted 3.1.0-rc5-wl+ #21
[ 3975.237991] Call Trace:
[ 3975.237997]  [<ffffffff81152d9f>] kmem_cache_destroy+0x36f/0x3d0
[ 3975.238006]  [<ffffffffa0380767>] iwl_uninit_drv+0x37/0x70 [iwlagn]
[ 3975.238018]  [<ffffffffa03aa105>] iwl_remove+0x101/0x11d [iwlagn]
[ 3975.238030]  [<ffffffffa03aa14b>] iwl_pci_remove+0x2a/0x6d [iwlagn]
[ 3975.238036]  [<ffffffff813024e2>] pci_device_remove+0x52/0x120
[ 3975.238041]  [<ffffffff813b178c>] __device_release_driver+0x7c/0xe0
[ 3975.238046]  [<ffffffff813b1ed8>] driver_detach+0xc8/0xd0
[ 3975.238051]  [<ffffffff813b15e9>] bus_remove_driver+0x79/0xd0
[ 3975.238056]  [<ffffffff813b22d2>] driver_unregister+0x62/0xa0
[ 3975.238062]  [<ffffffff813025f5>] pci_unregister_driver+0x45/0xc0
[ 3975.238074]  [<ffffffffa039b195>]
iwl_pci_unregister_driver+0x15/0x20 [iwlagn]
[ 3975.238086]  [<ffffffffa03aa197>] iwl_exit+0x9/0x10 [iwlagn]
[ 3975.238090]  [<ffffffff810a193d>] sys_delete_module+0x18d/0x260
[ 3975.238095]  [<ffffffff8113445a>] ? do_munmap+0x2da/0x370
[ 3975.238101]  [<ffffffff815b0f75>] ? page_fault+0x25/0x30
[ 3975.238106]  [<ffffffff815b8982>] system_call_fastpath+0x16/0x1b
[ 3975.239817] iwlagn 0000:03:00.0: PCI INT A disabled
[ 3977.626994] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[ 3977.626997] Copyright(c) 2003-2011 Intel Corporation
[ 3977.627102] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 3977.627113] iwlagn 0000:03:00.0: setting latency timer to 64
[ 3977.627628] iwlagn 0000:03:00.0: pci_resource_len = 0x00002000
[ 3977.627630] iwlagn 0000:03:00.0: pci_resource_base = ffffc90024518000
[ 3977.627632] iwlagn 0000:03:00.0: HW Revision ID = 0x35
[ 3977.627731] iwlagn 0000:03:00.0: irq 44 for MSI/MSI-X
[ 3977.627782] iwlagn 0000:03:00.0: Detected Intel(R) Centrino(R)
Advanced-N 6200 AGN, REV=0x74
[ 3977.627961] iwlagn 0000:03:00.0: L1 Disabled; Enabling L0S
[ 3977.637141] iwlagn 0000:03:00.0: device EEPROM VER=0x436, CALIB=0x6
[ 3977.637143] iwlagn 0000:03:00.0: Device SKU: 0X1f0
[ 3977.637181] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24
802.11a channels
[ 3977.645447] iwlagn 0000:03:00.0: loaded firmware version 9.221.4.1
build 25532
[ 3977.646031] Registered led device: phy1-led
[ 3977.646346] cfg80211: Ignoring regulatory request Set by core since
the driver uses its own custom regulatory domain
[ 3977.647668] ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
[ 3977.701067] udev[3239]: renamed network interface wlan0 to wlan8
[ 3977.704796] iwlagn 0000:03:00.0: L1 Disabled; Enabling L0S
[ 3977.704939] iwlagn 0000:03:00.0: Radio type=0x1-0x3-0x1
[ 3977.951352] iwlagn 0000:03:00.0: L1 Disabled; Enabling L0S
[ 3977.951483] iwlagn 0000:03:00.0: Radio type=0x1-0x3-0x1
[ 3978.043624] ieee80211 phy1: device now idle
[ 3978.057693] ADDRCONF(NETDEV_UP): wlan8: link is not ready
[ 3978.123908] ieee80211 phy1: device no longer idle - scanning
