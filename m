Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34607 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2DBOeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 10:34:15 -0400
Received: by mail-bk0-f46.google.com with SMTP id ik5so2546913bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 07:34:14 -0700 (PDT)
Message-ID: <4F79B8E1.6030701@openvz.org> (sfid-20120402_163419_441006_A80E2A5B)
Date: Mon, 02 Apr 2012 18:34:09 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: rtl8192ce: periodical kernel warning on v3.4-rc1
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[17174.389689] ------------[ cut here ]------------
[17174.389711] WARNING: at net/wireless/mlme.c:490 cfg80211_mlme_disassoc+0x114/0x120()
[17174.389716] Hardware name: 4291QY6
[17174.389719] Modules linked in: fuse nfsd bridge stp llc kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_dummy snd_seq_oss snd_seq_midi thinkpad_acpi snd_rawmidi cdc_ncm usbnet mii cdc_acm cdc_wdm coretemp snd_seq_midi_event snd_seq uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev snd_seq_device snd_timer rtl8192ce rtlwifi iTCO_wdt rtl8192c_common i915 snd wmi drm_kms_helper soundcore hid_logitech_dj sdhci_pci sdhci e1000e [last unloaded: scsi_wait_scan]
[17174.389807] Pid: 3663, comm: wpa_supplicant Not tainted 3.4.0-rc1-zurg-00013-g36b9175 #369
[17174.389812] Call Trace:
[17174.389824]  [<ffffffff8104548f>] warn_slowpath_common+0x7f/0xc0
[17174.389833]  [<ffffffff810454ea>] warn_slowpath_null+0x1a/0x20
[17174.389841]  [<ffffffff81625224>] cfg80211_mlme_disassoc+0x114/0x120
[17174.389852]  [<ffffffff8169e28d>] ? mutex_lock+0x1d/0x50
[17174.389859]  [<ffffffff81616a2e>] nl80211_disassociate+0xbe/0xf0
[17174.389868]  [<ffffffff8152bd1a>] genl_rcv_msg+0x21a/0x2b0
[17174.389875]  [<ffffffff8152bb00>] ? genl_rcv+0x40/0x40
[17174.389882]  [<ffffffff8152b4c9>] netlink_rcv_skb+0xa9/0xd0
[17174.389888]  [<ffffffff8152bae5>] genl_rcv+0x25/0x40
[17174.389894]  [<ffffffff8152aeee>] netlink_unicast+0x1ae/0x1f0
[17174.389901]  [<ffffffff8152b1dd>] netlink_sendmsg+0x2ad/0x310
[17174.389910]  [<ffffffff8106e038>] ? __wake_up_common+0x58/0x90
[17174.389922]  [<ffffffff814ecbf9>] sock_sendmsg+0xb9/0xe0
[17174.389929]  [<ffffffff814f2c5e>] ? sock_def_readable+0x3e/0x70
[17174.389937]  [<ffffffff814ef2d4>] ? move_addr_to_kernel+0x44/0x60
[17174.389946]  [<ffffffff814fa3c6>] ? verify_iovec+0x56/0xd0
[17174.389952]  [<ffffffff814ee496>] __sys_sendmsg+0x376/0x380
[17174.389962]  [<ffffffff81695275>] ? __bad_area_nosemaphore+0x96/0x1ea
[17174.389971]  [<ffffffff814ecca9>] ? sockfd_lookup_light+0x29/0x90
[17174.389977]  [<ffffffff814efabe>] ? sys_sendto+0xfe/0x130
[17174.389987]  [<ffffffff811319d2>] ? poll_select_copy_remaining+0xf2/0x140
[17174.389994]  [<ffffffff814efea9>] sys_sendmsg+0x49/0x90
[17174.390003]  [<ffffffff816a7e52>] system_call_fastpath+0x16/0x1b
[17174.390009] ---[ end trace 64a2442cf6dc929d ]---

Hardware: thinkpad x220, rfkill is on, AP not associated.
Probably network managed tries to connect to some AP.

# iwconfig
br0       no wireless extensions.

usb0      no wireless extensions.

eth0      no wireless extensions.

lo        no wireless extensions.

sit0      no wireless extensions.

wlan0     IEEE 802.11bgn  ESSID:off/any
           Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
           Encryption key:off
           Power Management:off


# lspci
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network Connection (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b4)
00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b4)
00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b4)
00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5 (rev b4)
00:1c.6 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 7 (rev b4)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation QM67 Express Chipset Family LPC Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 04)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 04)
03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter (rev 01)
0d:00.0 System peripheral: Ricoh Co Ltd Device e823 (rev 07)
0e:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)


[17097.544478] wlan0: authenticate with 20:37:06:f7:37:70
[17097.554989] wlan0: direct probe to 20:37:06:f7:37:70 (try 1/3)
[17097.755693] wlan0: direct probe to 20:37:06:f7:37:70 (try 2/3)
[17097.956437] wlan0: direct probe to 20:37:06:f7:37:70 (try 3/3)
[17098.157122] wlan0: authentication with 20:37:06:f7:37:70 timed out
[17104.408682] wlan0: authenticate with 20:37:06:f6:7d:70
[17104.425788] wlan0: send auth to 20:37:06:f6:7d:70 (try 1/3)
[17104.432094] wlan0: authenticated
[17104.447964] wlan0: associate with 20:37:06:f6:7d:70 (try 1/3)
[17104.467974] wlan0: RX AssocResp from 20:37:06:f6:7d:70 (capab=0x431 status=0 aid=81)
[17104.467982] wlan0: associated
[17174.389689] ------------[ cut here ]------------
[17174.389711] WARNING: at net/wireless/mlme.c:490 cfg80211_mlme_disassoc+0x114/0x120()
[17174.389716] Hardware name: 4291QY6
[17174.389719] Modules linked in: fuse nfsd bridge stp llc kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_dummy snd_seq_oss snd_seq_midi thinkpad_acpi snd_rawmidi cdc_ncm usbnet mii cdc_acm cdc_wdm coretemp snd_seq_midi_event snd_seq uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev snd_seq_device snd_timer rtl8192ce rtlwifi iTCO_wdt rtl8192c_common i915 snd wmi drm_kms_helper soundcore hid_logitech_dj sdhci_pci sdhci e1000e [last unloaded: scsi_wait_scan]
[17174.389807] Pid: 3663, comm: wpa_supplicant Not tainted 3.4.0-rc1-zurg-00013-g36b9175 #369
[17174.389812] Call Trace:
[17174.389824]  [<ffffffff8104548f>] warn_slowpath_common+0x7f/0xc0
[17174.389833]  [<ffffffff810454ea>] warn_slowpath_null+0x1a/0x20
[17174.389841]  [<ffffffff81625224>] cfg80211_mlme_disassoc+0x114/0x120
[17174.389852]  [<ffffffff8169e28d>] ? mutex_lock+0x1d/0x50
[17174.389859]  [<ffffffff81616a2e>] nl80211_disassociate+0xbe/0xf0
[17174.389868]  [<ffffffff8152bd1a>] genl_rcv_msg+0x21a/0x2b0
[17174.389875]  [<ffffffff8152bb00>] ? genl_rcv+0x40/0x40
[17174.389882]  [<ffffffff8152b4c9>] netlink_rcv_skb+0xa9/0xd0
[17174.389888]  [<ffffffff8152bae5>] genl_rcv+0x25/0x40
[17174.389894]  [<ffffffff8152aeee>] netlink_unicast+0x1ae/0x1f0
[17174.389901]  [<ffffffff8152b1dd>] netlink_sendmsg+0x2ad/0x310
[17174.389910]  [<ffffffff8106e038>] ? __wake_up_common+0x58/0x90
[17174.389922]  [<ffffffff814ecbf9>] sock_sendmsg+0xb9/0xe0
[17174.389929]  [<ffffffff814f2c5e>] ? sock_def_readable+0x3e/0x70
[17174.389937]  [<ffffffff814ef2d4>] ? move_addr_to_kernel+0x44/0x60
[17174.389946]  [<ffffffff814fa3c6>] ? verify_iovec+0x56/0xd0
[17174.389952]  [<ffffffff814ee496>] __sys_sendmsg+0x376/0x380
[17174.389962]  [<ffffffff81695275>] ? __bad_area_nosemaphore+0x96/0x1ea
[17174.389971]  [<ffffffff814ecca9>] ? sockfd_lookup_light+0x29/0x90
[17174.389977]  [<ffffffff814efabe>] ? sys_sendto+0xfe/0x130
[17174.389987]  [<ffffffff811319d2>] ? poll_select_copy_remaining+0xf2/0x140
[17174.389994]  [<ffffffff814efea9>] sys_sendmsg+0x49/0x90
[17174.390003]  [<ffffffff816a7e52>] system_call_fastpath+0x16/0x1b
[17174.390009] ---[ end trace 64a2442cf6dc929d ]---
[17175.587561] wlan0: authenticate with 20:37:06:f6:7d:50
[17175.598023] wlan0: send auth to 20:37:06:f6:7d:50 (try 1/3)
[17175.611084] wlan0: authenticated
[17175.627938] wlan0: associate with 20:37:06:f6:7d:50 (try 1/3)
[17175.664120] wlan0: RX AssocResp from 20:37:06:f6:7d:50 (capab=0x431 status=0 aid=171)
[17175.664132] wlan0: associated
[17177.652905] wlan0: deauthenticated from 20:37:06:f6:7d:50 (Reason: 7)
[17179.019189] wlan0: authenticate with b8:be:bf:68:94:70
[17179.034583] wlan0: direct probe to b8:be:bf:68:94:70 (try 1/3)
[17179.235344] wlan0: direct probe to b8:be:bf:68:94:70 (try 2/3)
[17179.436077] wlan0: direct probe to b8:be:bf:68:94:70 (try 3/3)
[17179.636810] wlan0: authentication with b8:be:bf:68:94:70 timed out
[17186.091097] wlan0: authenticate with 20:37:06:f6:7d:50
[17186.104400] wlan0: send auth to 20:37:06:f6:7d:50 (try 1/3)
[17186.108917] wlan0: authenticated
[17186.130357] wlan0: associate with 20:37:06:f6:7d:50 (try 1/3)
[17186.140499] wlan0: RX AssocResp from 20:37:06:f6:7d:50 (capab=0x431 status=0 aid=171)
[17186.140511] wlan0: associated
[17193.186198] wlan0: deauthenticating from 20:37:06:f6:7d:50 by local choice (reason=3)
[17194.151397] wlan0: authenticate with 20:37:06:f7:36:e0
[17194.169820] wlan0: send auth to 20:37:06:f7:36:e0 (try 1/3)
[17194.172992] wlan0: authenticated
[17194.190936] wlan0: associate with 20:37:06:f7:36:e0 (try 1/3)
[17194.206369] wlan0: RX AssocResp from 20:37:06:f7:36:e0 (capab=0x431 status=0 aid=81)
[17194.206379] wlan0: associated
[17196.289713] ------------[ cut here ]------------
[17196.289736] WARNING: at net/wireless/mlme.c:490 cfg80211_mlme_disassoc+0x114/0x120()
[17196.289742] Hardware name: 4291QY6
[17196.289746] Modules linked in: fuse nfsd bridge stp llc kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_dummy snd_seq_oss snd_seq_midi thinkpad_acpi snd_rawmidi cdc_ncm usbnet mii cdc_acm cdc_wdm coretemp snd_seq_midi_event snd_seq uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev snd_seq_device snd_timer rtl8192ce rtlwifi iTCO_wdt rtl8192c_common i915 snd wmi drm_kms_helper soundcore hid_logitech_dj sdhci_pci sdhci e1000e [last unloaded: scsi_wait_scan]
[17196.289914] Pid: 3663, comm: wpa_supplicant Tainted: G        W    3.4.0-rc1-zurg-00013-g36b9175 #369
[17196.289920] Call Trace:
[17196.289932]  [<ffffffff8104548f>] warn_slowpath_common+0x7f/0xc0
[17196.289941]  [<ffffffff810454ea>] warn_slowpath_null+0x1a/0x20
[17196.289949]  [<ffffffff81625224>] cfg80211_mlme_disassoc+0x114/0x120
[17196.289960]  [<ffffffff8169e28d>] ? mutex_lock+0x1d/0x50
[17196.289967]  [<ffffffff81616a2e>] nl80211_disassociate+0xbe/0xf0
[17196.289976]  [<ffffffff8152bd1a>] genl_rcv_msg+0x21a/0x2b0
[17196.289983]  [<ffffffff8152bb00>] ? genl_rcv+0x40/0x40
[17196.289990]  [<ffffffff8152b4c9>] netlink_rcv_skb+0xa9/0xd0
[17196.289996]  [<ffffffff8152bae5>] genl_rcv+0x25/0x40
[17196.290002]  [<ffffffff8152aeee>] netlink_unicast+0x1ae/0x1f0
[17196.290009]  [<ffffffff8152b1dd>] netlink_sendmsg+0x2ad/0x310
[17196.290018]  [<ffffffff8106e038>] ? __wake_up_common+0x58/0x90
[17196.290029]  [<ffffffff814ecbf9>] sock_sendmsg+0xb9/0xe0
[17196.290037]  [<ffffffff814f2c5e>] ? sock_def_readable+0x3e/0x70
[17196.290045]  [<ffffffff814ef2d4>] ? move_addr_to_kernel+0x44/0x60
[17196.290053]  [<ffffffff814fa3c6>] ? verify_iovec+0x56/0xd0
[17196.290059]  [<ffffffff814ee496>] __sys_sendmsg+0x376/0x380
[17196.290069]  [<ffffffff81695275>] ? __bad_area_nosemaphore+0x96/0x1ea
[17196.290078]  [<ffffffff814ecca9>] ? sockfd_lookup_light+0x29/0x90
[17196.290084]  [<ffffffff814efabe>] ? sys_sendto+0xfe/0x130
[17196.290094]  [<ffffffff811319d2>] ? poll_select_copy_remaining+0xf2/0x140
[17196.290101]  [<ffffffff814efea9>] sys_sendmsg+0x49/0x90
[17196.290110]  [<ffffffff816a7e52>] system_call_fastpath+0x16/0x1b
[17196.290115] ---[ end trace 64a2442cf6dc929e ]---
[17197.480213] wlan0: authenticate with 20:37:06:f6:7d:50
[17197.490631] wlan0: send auth to 20:37:06:f6:7d:50 (try 1/3)
[17197.492900] wlan0: authenticated
[17197.505655] wlan0: associate with 20:37:06:f6:7d:50 (try 1/3)
[17197.512257] wlan0: RX AssocResp from 20:37:06:f6:7d:50 (capab=0x431 status=0 aid=169)
[17197.512263] wlan0: associated
[17218.954237] wlan0: deauthenticating from 20:37:06:f6:7d:50 by local choice (reason=3)
[17546.563663] wlan0: authenticate with 20:37:06:f6:7d:70
[17546.577750] wlan0: direct probe to 20:37:06:f6:7d:70 (try 1/3)
[17546.778108] wlan0: direct probe to 20:37:06:f6:7d:70 (try 2/3)
[17546.978801] wlan0: direct probe to 20:37:06:f6:7d:70 (try 3/3)
[17547.179547] wlan0: authentication with 20:37:06:f6:7d:70 timed out
[17553.436659] wlan0: authenticate with 20:37:06:f6:7d:50
[17553.450363] wlan0: send auth to 20:37:06:f6:7d:50 (try 1/3)
[17553.453441] wlan0: authenticated
[17553.472400] wlan0: associate with 20:37:06:f6:7d:50 (try 1/3)
[17553.492820] wlan0: RX AssocResp from 20:37:06:f6:7d:50 (capab=0x431 status=0 aid=173)
[17553.492831] wlan0: associated
