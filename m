Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout8.freenet.de ([195.4.92.98]:57021 "EHLO mout8.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab1FDIkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 04:40:45 -0400
Received: from [195.4.92.19] (helo=9.mx.freenet.de)
	by mout8.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #2)
	id 1QSmPT-0007eP-BM
	for linux-wireless@vger.kernel.org; Sat, 04 Jun 2011 10:40:43 +0200
Received: from p54a193b8.dip0.t-ipconnect.de ([84.161.147.184]:52587 helo=mail.maya.org)
	by 9.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #5)
	id 1QSmPT-0001qn-17
	for linux-wireless@vger.kernel.org; Sat, 04 Jun 2011 10:40:43 +0200
Message-ID: <4DE9EF9A.1030803@01019freenet.de> (sfid-20110604_104050_418138_29821500)
Date: Sat, 04 Jun 2011 10:40:58 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: problems with hwcrypt
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

using hwcrypt with rt2800pci (with kernel 2.6.39 and
compat-wireless-2011-05-31) as AP (with hostapd in n-mode) and high
network load (created with netperf), produces warnings like this
(sometimes more, sometimes less):


Jun  4 09:44:52 pc kernel: [ 8517.220574] ------------[ cut here
]------------
Jun  4 09:44:52 pc kernel: [ 8517.220595] WARNING: at
/raid/home/andreas/tttt/compat-wireless-2011-05-31/net/mac80211/wpa.c:397 ccmp_encrypt_skb+0xc4/0x1f0
[mac80211]()
Jun  4 09:44:52 pc kernel: [ 8517.220599] Hardware name: GA-MA78G-DS3H
Jun  4 09:44:52 pc kernel: [ 8517.220600] Modules linked in: arc4
rt2800pci rt2800lib crc_ccitt rt2x00pci rt2x00lib mac80211 cfg80211
rfkill eeprom_93cx6 af_packet nls_utf8 snd_pcm_oss snd_mixer_oss snd_seq
snd_seq_device bridge stp llc tun cpufreq_conservative cpufreq_userspace
cpufreq_powersave powernow_k8 mperf fuse fglrx(P) sha256_generic cbc
dm_crypt reiserfs loop dm_mod snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm shpchp snd_timer snd
kvm_amd soundcore pci_hotplug sp5100_tco sr_mod sg snd_page_alloc r8169
kvm i2c_piix4 pcspkr edac_core edac_mce_amd firewire_ohci firewire_core
cdrom wmi e100 button k8temp crc_itu_t edd fan processor ata_generic
pata_atiixp thermal thermal_sys raid1 [last unloaded: eeprom_93cx6]
Jun  4 09:44:52 pc kernel: [ 8517.220650] Pid: 0, comm: kworker/0:0
Tainted: P        W   2.6.39-27-desktop #1
Jun  4 09:44:52 pc kernel: [ 8517.220653] Call Trace:
Jun  4 09:44:52 pc kernel: [ 8517.220665]  [<ffffffff81004642>]
dump_trace+0x82/0x370
Jun  4 09:44:52 pc kernel: [ 8517.220670]  [<ffffffff81571b70>]
dump_stack+0x69/0x6f
Jun  4 09:44:52 pc kernel: [ 8517.220676]  [<ffffffff81058fbb>]
warn_slowpath_common+0x7b/0xc0
Jun  4 09:44:52 pc kernel: [ 8517.220685]  [<ffffffffa0693304>]
ccmp_encrypt_skb+0xc4/0x1f0 [mac80211]
Jun  4 09:44:52 pc kernel: [ 8517.220708]  [<ffffffffa0693adb>]
ieee80211_crypto_ccmp_encrypt+0x2b/0x50 [mac80211]
Jun  4 09:44:52 pc kernel: [ 8517.220725]  [<ffffffffa06acdbd>]
invoke_tx_handlers+0x1fd/0x260 [mac80211]
Jun  4 09:44:52 pc kernel: [ 8517.220767]  [<ffffffffa06ace92>]
ieee80211_tx+0x72/0xf0 [mac80211]
Jun  4 09:44:52 pc kernel: [ 8517.220808]  [<ffffffffa06acfcb>]
ieee80211_xmit+0xbb/0x1d0 [mac80211]
Jun  4 09:44:52 pc kernel: [ 8517.220849]  [<ffffffffa06ad61c>]
ieee80211_subif_start_xmit+0x36c/0x860 [mac80211]
Jun  4 09:44:52 pc kernel: [ 8517.220886]  [<ffffffff81473c29>]
dev_hard_start_xmit+0x259/0x5c0
Jun  4 09:44:52 pc kernel: [ 8517.220892]  [<ffffffff8148e5eb>]
sch_direct_xmit+0xeb/0x1e0
Jun  4 09:44:52 pc kernel: [ 8517.220897]  [<ffffffff8148e787>]
__qdisc_run+0xa7/0x130
Jun  4 09:44:52 pc kernel: [ 8517.220901]  [<ffffffff81471803>]
net_tx_action+0xe3/0x200
Jun  4 09:44:52 pc kernel: [ 8517.220906]  [<ffffffff8106060d>]
__do_softirq+0xbd/0x260
Jun  4 09:44:52 pc kernel: [ 8517.220912]  [<ffffffff8157d1fc>]
call_softirq+0x1c/0x30
Jun  4 09:44:52 pc kernel: [ 8517.220916]  [<ffffffff81004585>]
do_softirq+0x65/0xa0
Jun  4 09:44:53 pc kernel: [ 8517.220920]  [<ffffffff81060abe>]
irq_exit+0x9e/0xb0
Jun  4 09:44:52 pc hostapd: wlan1: STA 00:25:9c:de:4e:30 IEEE 802.1X:
authorizing port
Jun  4 09:44:53 pc hostapd: wlan1: STA 00:25:9c:de:4e:30 RADIUS:
starting accounting session 4DE9D3E4-0000001C
Jun  4 09:44:53 pc hostapd: wlan1: STA 00:25:9c:de:4e:30 WPA: pairwise
key handshake completed (RSN)
Jun  4 09:44:53 pc kernel: [ 8517.220924]  [<ffffffff8100418c>]
do_IRQ+0x5c/0xd0
Jun  4 09:44:53 pc kernel: [ 8517.220928]  [<ffffffff815752d3>]
common_interrupt+0x13/0x13
Jun  4 09:44:53 pc kernel: [ 8517.220934]  [<ffffffff8102af52>]
native_safe_halt+0x2/0x10
Jun  4 09:44:53 pc kernel: [ 8517.220939]  [<ffffffff8100a3c7>]
default_idle+0x47/0x230
Jun  4 09:44:53 pc kernel: [ 8517.220943]  [<ffffffff8100a604>]
c1e_idle+0x54/0x110
Jun  4 09:44:53 pc kernel: [ 8517.220952]  [<ffffffff810011f6>]
cpu_idle+0x56/0xa0
Jun  4 09:44:53 pc kernel: [ 8517.220956] ---[ end trace
3ce7ff16bfe4412a ]---
Jun  4 09:44:53 pc kernel: [ 8517.220961] ------------[ cut here
]------------


hostapd runs on a dual core machine.


Andreas
