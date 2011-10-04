Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36905 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab1JDTXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 15:23:21 -0400
Received: by qyk30 with SMTP id 30so3600951qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 12:23:20 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 4 Oct 2011 12:23:00 -0700
Message-ID: <CAB=NE6VjmEhmKqdwWqHz_YxD_iKu9msqDSih3OKh4SYVQXAvjg@mail.gmail.com> (sfid-20111004_212329_417197_E4295343)
Subject: iwlagn master-2011-10-03 warning on iwl_trans_pcie_tx()
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My iwlagn is pretty useless with my WRT610n when the AP gets busy with
TX/RX. I end up getting this below. I connect to my AP on 2 GHz and
then give up as it stalls there as I try to fire up gmail (while my
home page did load), when I give up I move to 5 GHz and I get similar
stalls and now am just on Ethernet. Behind the scenes I just had
Pandora on Ethernet downloading music as usual and my Galaxy S 4G
phone uploading video/pictures to G+ automatically. I reset my AP two
days ago, same as the broadband modem device.

Oct  4 12:04:03 tux kernel: [   17.527446] Intel(R) Wireless WiFi Link
AGN driver for Linux, in-tree:
Oct  4 12:04:03 tux kernel: [   17.527450] Copyright(c) 2003-2011
Intel Corporation
Oct  4 12:04:03 tux kernel: [   17.527583] iwlwifi 0000:03:00.0: PCI
INT A -> GSI 17 (level, low) -> IRQ 17
Oct  4 12:04:03 tux kernel: [   17.527592] iwlwifi 0000:03:00.0:
setting latency timer to 64
Oct  4 12:04:03 tux kernel: [   17.527679] iwlwifi 0000:03:00.0:
pci_resource_len = 0x00002000
Oct  4 12:04:03 tux kernel: [   17.527681] iwlwifi 0000:03:00.0:
pci_resource_base = ffffc900110b8000
Oct  4 12:04:03 tux kernel: [   17.527684] iwlwifi 0000:03:00.0: HW
Revision ID = 0x35
Oct  4 12:04:03 tux kernel: [   17.527784] iwlwifi 0000:03:00.0: irq
43 for MSI/MSI-X
Oct  4 12:04:03 tux kernel: [   17.527843] iwlwifi 0000:03:00.0:
Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
Oct  4 12:04:03 tux kernel: [   17.528112] iwlwifi 0000:03:00.0: L1
Disabled; Enabling L0S
Oct  4 12:04:03 tux kernel: [   17.549374] iwlwifi 0000:03:00.0:
device EEPROM VER=0x436, CALIB=0x6
Oct  4 12:04:03 tux kernel: [   17.549378] iwlwifi 0000:03:00.0:
Device SKU: 0X1f0
Oct  4 12:04:03 tux kernel: [   17.553797] thinkpad_acpi: detected a
8-level brightness capable ThinkPad
Oct  4 12:04:03 tux kernel: [   17.554661] iwlwifi 0000:03:00.0:
Tunable channels: 13 802.11bg, 24 802.11a channels
Oct  4 12:04:03 tux kernel: [   17.558683] thinkpad_acpi: radio switch
found; radios are enabled
Oct  4 12:04:03 tux kernel: [   17.561864] Linux video capture interface: v2.00
Oct  4 12:04:03 tux kernel: [   17.572663] cfg80211: World regulatory
domain updated:
Oct  4 12:04:03 tux kernel: [   17.572667] cfg80211:     (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Oct  4 12:04:03 tux kernel: [   17.572670] cfg80211:     (2402000 KHz
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Oct  4 12:04:03 tux kernel: [   17.572673] cfg80211:     (2457000 KHz
- 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Oct  4 12:04:03 tux kernel: [   17.572676] cfg80211:     (2474000 KHz
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Oct  4 12:04:03 tux kernel: [   17.572678] cfg80211:     (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Oct  4 12:04:03 tux kernel: [   17.572681] cfg80211:     (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Oct  4 12:04:03 tux kernel: [   17.584274] iwlwifi 0000:03:00.0:
loaded firmware version 9.221.4.1 build 25532
Oct  4 12:04:06 tux kernel: [   20.871100] cfg80211: Found new beacon
on frequency: 5745 MHz (Ch 149) on phy0
Oct  4 12:04:07 tux kernel: [   21.353306] ieee80211 phy0: device now idle
Oct  4 12:04:10 tux kernel: [   24.127356] IBM TrackPoint firmware:
0x0e, buttons: 3/3
Oct  4 12:04:10 tux kernel: [   24.386849] input: TPPS/2 IBM
TrackPoint as /devices/platform/i8042/serio1/serio2/input/input11
Oct  4 12:04:20 tux kernel: [   34.446261] hda-intel: Invalid position
buffer, using LPIB read method instead.
Oct  4 12:04:20 tux kernel: [   34.460741] hda-intel: Invalid position
buffer, using LPIB read method instead.
Oct  4 12:04:20 tux kernel: [   34.630865] hda-intel: IRQ timing
workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
Oct  4 12:04:24 tux kernel: [   38.186368] ieee80211 phy0: device no
longer idle - scanning
Oct  4 12:04:25 tux kernel: [   39.065708] EXT4-fs (sda1): re-mounted.
Opts: errors=remount-ro,user_xattr,commit=0
Oct  4 12:04:27 tux kernel: [   41.412585] ieee80211 phy0: device now idle
Oct  4 12:06:44 tux kernel: [  178.626667] ieee80211 phy0: device no
longer idle - scanning
Oct  4 12:06:47 tux kernel: [  181.932274] ieee80211 phy0: device now idle
Oct  4 12:06:47 tux kernel: [  181.965028] ieee80211 phy0: device no
longer idle - working
Oct  4 12:06:48 tux kernel: [  181.975874] wlan8: authenticate with
68:7f:74:3b:b1:0f (try 1)
Oct  4 12:06:48 tux kernel: [  181.984961] wlan8: authenticated
Oct  4 12:06:48 tux kernel: [  181.985029] ieee80211 phy0: Allocated
STA 68:7f:74:3b:b1:0f
Oct  4 12:06:48 tux kernel: [  181.985033] ieee80211 phy0: Inserted
dummy STA 68:7f:74:3b:b1:0f
Oct  4 12:06:48 tux kernel: [  181.985857] wlan8: associate with
68:7f:74:3b:b1:0f (try 1)
Oct  4 12:06:48 tux kernel: [  181.992390] wlan8: RX AssocResp from
68:7f:74:3b:b1:0f (capab=0x411 status=0 aid=2)
Oct  4 12:06:48 tux kernel: [  181.992395] wlan8: associated
Oct  4 12:06:48 tux kernel: [  181.994496] ieee80211 phy0: Inserted
STA 68:7f:74:3b:b1:0f
Oct  4 12:06:48 tux kernel: [  181.994501] ieee80211 phy0: WMM queue=2
aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0 uapsd=0
Oct  4 12:06:48 tux kernel: [  181.994506] ieee80211 phy0: WMM queue=3
aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
Oct  4 12:06:48 tux kernel: [  181.994509] ieee80211 phy0: WMM queue=1
aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
Oct  4 12:06:48 tux kernel: [  181.994513] ieee80211 phy0: WMM queue=0
aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
Oct  4 12:06:48 tux kernel: [  181.998981] ADDRCONF(NETDEV_CHANGE):
wlan8: link becomes ready
Oct  4 12:06:48 tux kernel: [  181.999889] Rx A-MPDU request on tid 0 result 0
Oct  4 12:06:54 tux kernel: [  188.067434] Open BA session requested
for 68:7f:74:3b:b1:0f tid 0
Oct  4 12:06:54 tux kernel: [  188.101476] activated addBA response
timer on tid 0
Oct  4 12:06:55 tux kernel: [  189.100782] addBA response timer expired on tid 0

Then I decide to switch to 5 GHz.

Oct  4 12:06:55 tux kernel: [  189.100806] Tx BA session stop
requested for 68:7f:74:3b:b1:0f tid 0
Oct  4 12:06:59 tux kernel: [  193.416483] switched off addBA timer for tid 0
Oct  4 12:06:59 tux kernel: [  193.416488] Aggregation is on for tid 0
Oct  4 12:06:59 tux kernel: [  193.416635] iwlwifi 0000:03:00.0: Tx
aggregation enabled on ra = 68:7f:74:3b:b1:0f tid = 0
Oct  4 12:06:59 tux kernel: [  193.416676] ------------[ cut here ]------------
Oct  4 12:06:59 tux kernel: [  193.416700] WARNING: at
drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:1098
iwl_trans_pcie_tx+0x798/0x7c0 [iwlwifi]()
Oct  4 12:06:59 tux kernel: [  193.416707] Hardware name: 2518F4U
Oct  4 12:06:59 tux kernel: [  193.416710] Modules linked in: ppdev
snd_hda_codec_hdmi snd_hda_codec_conexant binfmt_misc joydev
snd_hda_intel uvcvideo snd_hda_codec snd_hwdep videodev
v4l2_compat_ioctl32 snd_pcm iwlwifi btusb thinkpad_acpi mxm_wmi
bluetooth snd_seq_midi snd_rawmidi i915 mac80211 snd_seq_midi_event
snd_seq snd_timer snd_seq_device drm_kms_helper psmouse snd serio_raw
drm cfg80211 snd_page_alloc soundcore nvram i2c_algo_bit intel_agp
intel_gtt tpm_tis tpm tpm_bios video lp parport ahci libahci e1000e
Oct  4 12:06:59 tux kernel: [  193.416782] Pid: 253, comm: kworker/u:3
Not tainted 3.1.0-rc8-wl+ #23
Oct  4 12:06:59 tux kernel: [  193.416787] Call Trace:
Oct  4 12:06:59 tux kernel: [  193.416791]  <IRQ>
[<ffffffff8106368f>] warn_slowpath_common+0x7f/0xc0
Oct  4 12:06:59 tux kernel: [  193.416809]  [<ffffffff810636ea>]
warn_slowpath_null+0x1a/0x20
Oct  4 12:06:59 tux kernel: [  193.416826]  [<ffffffffa02cedf8>]
iwl_trans_pcie_tx+0x798/0x7c0 [iwlwifi]
Oct  4 12:06:59 tux kernel: [  193.416835]  [<ffffffff8105b788>] ?
try_to_wake_up+0x248/0x2b0
Oct  4 12:06:59 tux kernel: [  193.416846]  [<ffffffff8115178f>] ?
kmem_cache_alloc+0x11f/0x170
Oct  4 12:06:59 tux kernel: [  193.416860]  [<ffffffffa02bbd07>]
iwlagn_tx_skb+0x467/0x7f0 [iwlwifi]
Oct  4 12:06:59 tux kernel: [  193.416872]  [<ffffffffa02b264a>]
iwlagn_mac_tx+0x1a/0x30 [iwlwifi]
Oct  4 12:06:59 tux kernel: [  193.416905]  [<ffffffffa01a7e56>]
__ieee80211_tx+0x76/0x260 [mac80211]
Oct  4 12:06:59 tux kernel: [  193.416931]  [<ffffffffa01a972c>]
ieee80211_tx+0x8c/0xb0 [mac80211]
Oct  4 12:06:59 tux kernel: [  193.416941]  [<ffffffff8103be19>] ?
default_spin_lock_flags+0x9/0x10
Oct  4 12:06:59 tux kernel: [  193.416966]  [<ffffffffa01aa5dd>]
ieee80211_tx_pending+0x8d/0x250 [mac80211]
Oct  4 12:06:59 tux kernel: [  193.416974]  [<ffffffff8106a39c>]
tasklet_action+0x6c/0x120
Oct  4 12:06:59 tux kernel: [  193.416981]  [<ffffffff8106aaed>]
__do_softirq+0xad/0x1d0
Oct  4 12:06:59 tux kernel: [  193.416991]  [<ffffffff815ba76c>]
call_softirq+0x1c/0x30
Oct  4 12:06:59 tux kernel: [  193.416995]  <EOI>
[<ffffffff810152b5>] do_softirq+0x65/0xa0
Oct  4 12:06:59 tux kernel: [  193.417007]  [<ffffffff8106a6c5>]
local_bh_enable_ip+0x85/0xb0
Oct  4 12:06:59 tux kernel: [  193.417016]  [<ffffffff815b03c9>]
_raw_spin_unlock_bh+0x19/0x20
Oct  4 12:06:59 tux kernel: [  193.417037]  [<ffffffffa018fc8a>]
ieee80211_agg_tx_operational+0xea/0x1b0 [mac80211]
Oct  4 12:06:59 tux kernel: [  193.417045]  [<ffffffff815ad4c9>] ?
printk+0x6c/0x73
Oct  4 12:06:59 tux kernel: [  193.417066]  [<ffffffffa0190844>]
ieee80211_process_addba_resp+0x114/0x150 [mac80211]
Oct  4 12:06:59 tux kernel: [  193.417090]  [<ffffffffa019a6bd>]
ieee80211_iface_work+0x2ed/0x340 [mac80211]
Oct  4 12:06:59 tux kernel: [  193.417113]  [<ffffffffa019a3d0>] ?
ieee80211_teardown_sdata+0xf0/0xf0 [mac80211]
Oct  4 12:06:59 tux kernel: [  193.417121]  [<ffffffff810800a6>]
process_one_work+0x126/0x430
Oct  4 12:06:59 tux kernel: [  193.417129]  [<ffffffff81080e43>]
worker_thread+0x163/0x360
Oct  4 12:06:59 tux kernel: [  193.417136]  [<ffffffff81080ce0>] ?
manage_workers.clone.21+0x240/0x240
Oct  4 12:06:59 tux kernel: [  193.417144]  [<ffffffff81085e16>]
kthread+0x96/0xa0
Oct  4 12:06:59 tux kernel: [  193.417152]  [<ffffffff815ba674>]
kernel_thread_helper+0x4/0x10
Oct  4 12:06:59 tux kernel: [  193.417161]  [<ffffffff81085d80>] ?
flush_kthread_worker+0xb0/0xb0
Oct  4 12:06:59 tux kernel: [  193.417168]  [<ffffffff815ba670>] ?
gs_change+0x13/0x13
Oct  4 12:06:59 tux kernel: [  193.417174] ---[ end trace 4191e5f5f2031e03 ]---
Oct  4 12:06:59 tux kernel: [  193.417219] ------------[ cut here ]------------

This repeats itself many many many times. Eventually it manages to associate:

Oct  4 12:06:59 tux kernel: [  193.450637] Stopping Tx BA session for
68:7f:74:3b:b1:0f tid 0
Oct  4 12:07:00 tux kernel: [  194.411542] Open BA session requested
for 68:7f:74:3b:b1:0f tid 0
Oct  4 12:07:00 tux kernel: [  194.467889] activated addBA response
timer on tid 0
Oct  4 12:07:00 tux kernel: [  194.469733] switched off addBA timer for tid 0
Oct  4 12:07:01 tux kernel: [  195.907026] iwlwifi 0000:03:00.0: Queue
11 stuck for 2000 ms.
Oct  4 12:07:01 tux kernel: [  195.907032] iwlwifi 0000:03:00.0:
Current read_ptr 140 write_ptr 208
Oct  4 12:07:01 tux kernel: [  195.907034] iwlwifi 0000:03:00.0: On
demand firmware reload
Oct  4 12:07:01 tux kernel: [  195.908336] ieee80211 phy0: Hardware
restart was requested
Oct  4 12:07:01 tux kernel: [  195.908387] iwlwifi 0000:03:00.0: L1
Disabled; Enabling L0S
Oct  4 12:07:01 tux kernel: [  195.915015] iwlwifi 0000:03:00.0: Radio
type=0x1-0x3-0x1
Oct  4 12:07:02 tux kernel: [  196.015278] Tx BA session stop
requested for 68:7f:74:3b:b1:0f tid 0
Oct  4 12:07:02 tux kernel: [  196.015387] Rx BA session stop
requested for 68:7f:74:3b:b1:0f tid 0
Oct  4 12:07:02 tux kernel: [  196.015467] Stopping Tx BA session for
68:7f:74:3b:b1:0f tid 0
Oct  4 12:07:02 tux kernel: [  196.149958] Rx A-MPDU request on tid 0 result 0
Oct  4 12:07:02 tux kernel: [  196.844265] Open BA session requested
for 68:7f:74:3b:b1:0f tid 0
Oct  4 12:07:02 tux kernel: [  196.937226] activated addBA response
timer on tid 0
Oct  4 12:07:02 tux kernel: [  196.939294] switched off addBA timer for tid 0
Oct  4 12:08:31 tux kernel: [  285.324708] Tx BA session stop
requested for 68:7f:74:3b:b1:0f tid 0
Oct  4 12:08:31 tux kernel: [  285.324849] Rx BA session stop
requested for 68:7f:74:3b:b1:0f tid 0
Oct  4 12:08:31 tux kernel: [  285.324857] Stopping Tx BA session for
68:7f:74:3b:b1:0f tid 0
Oct  4 12:08:31 tux kernel: [  285.346298] wlan8: deauthenticating
from 68:7f:74:3b:b1:0f by local choice (reason=3)
Oct  4 12:08:31 tux kernel: [  285.612105] iwlwifi 0000:03:00.0:
Unknown encode cipher 6b6b6b6b
Oct  4 12:08:31 tux kernel: [  285.612122] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612156] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612188] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612220] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612252] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612288] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612325] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612363] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612401] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612470] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612503] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612536] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612574] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612614] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612654] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612693] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612730] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.612768] wlan8: dropped data frame
to not associated station 68:7f:74:3b:b1:0f

a lot more of these...

And then:

Oct  4 12:08:31 tux kernel: [  285.614430] wlan8: dropped frame to
00:00:00:00:00:00 (unauthorized port)
Oct  4 12:08:31 tux kernel: [  285.614477] wlan8: dropped frame to
00:00:00:00:00:00 (unauthorized port)
Oct  4 12:08:31 tux kernel: [  285.706894] ieee80211 phy0: Removed STA
68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.707041] ieee80211 phy0: Destroyed
STA 68:7f:74:3b:b1:0f
Oct  4 12:08:31 tux kernel: [  285.707073] ieee80211 phy0: device now idle
Oct  4 12:08:31 tux kernel: [  285.707435] cfg80211: All devices are
disconnected, going to restore regulatory settings
Oct  4 12:08:31 tux kernel: [  285.707460] cfg80211: Restoring
regulatory settings
Oct  4 12:08:31 tux kernel: [  285.707513] cfg80211: Calling CRDA to
update world regulatory domain
Oct  4 12:08:31 tux kernel: [  285.734559] cfg80211: Ignoring
regulatory request Set by core since the driver uses its own custom
regulatory domain
Oct  4 12:08:31 tux kernel: [  285.734564] cfg80211: World regulatory
domain updated:
Oct  4 12:08:31 tux kernel: [  285.734566] cfg80211:     (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Oct  4 12:08:31 tux kernel: [  285.734569] cfg80211:     (2402000 KHz
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Oct  4 12:08:31 tux kernel: [  285.734572] cfg80211:     (2457000 KHz
- 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Oct  4 12:08:31 tux kernel: [  285.734575] cfg80211:     (2474000 KHz
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Oct  4 12:08:31 tux kernel: [  285.734578] cfg80211:     (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Oct  4 12:08:31 tux kernel: [  285.734581] cfg80211:     (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Oct  4 12:08:31 tux kernel: [  285.814415] ieee80211 phy0: device no
longer idle - scanning
Oct  4 12:08:35 tux kernel: [  289.084075] ieee80211 phy0: device now idle
Oct  4 12:08:35 tux kernel: [  289.117726] ieee80211 phy0: device no
longer idle - working
Oct  4 12:08:35 tux kernel: [  289.127296] wlan8: authenticate with
68:7f:74:3b:b1:10 (try 1)
Oct  4 12:08:35 tux kernel: [  289.321657] wlan8: authenticate with
68:7f:74:3b:b1:10 (try 2)
Oct  4 12:08:35 tux kernel: [  289.322338] wlan8: authenticated
Oct  4 12:08:35 tux kernel: [  289.322501] ieee80211 phy0: Allocated
STA 68:7f:74:3b:b1:10
Oct  4 12:08:35 tux kernel: [  289.322510] ieee80211 phy0: Inserted
dummy STA 68:7f:74:3b:b1:10
Oct  4 12:08:35 tux kernel: [  289.323565] wlan8: associate with
68:7f:74:3b:b1:10 (try 1)
Oct  4 12:08:35 tux kernel: [  289.324948] wlan8: RX AssocResp from
68:7f:74:3b:b1:10 (capab=0x11 status=0 aid=1)
Oct  4 12:08:35 tux kernel: [  289.324953] wlan8: associated
Oct  4 12:08:35 tux kernel: [  289.326652] ieee80211 phy0: Inserted
STA 68:7f:74:3b:b1:10
Oct  4 12:08:35 tux kernel: [  289.326662] ieee80211 phy0: WMM queue=2
aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0 uapsd=0
Oct  4 12:08:35 tux kernel: [  289.326671] ieee80211 phy0: WMM queue=3
aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
Oct  4 12:08:35 tux kernel: [  289.326680] ieee80211 phy0: WMM queue=1
aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
Oct  4 12:08:35 tux kernel: [  289.326688] ieee80211 phy0: WMM queue=0
aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
Oct  4 12:08:35 tux kernel: [  289.333572] Rx A-MPDU request on tid 0 result 0
Oct  4 12:08:40 tux kernel: [  294.005617] Open BA session requested
for 68:7f:74:3b:b1:10 tid 0
Oct  4 12:08:40 tux kernel: [  294.041539] activated addBA response
timer on tid 0

My 802.11 is useless, so I'm using Ethernet now.

  Luis
