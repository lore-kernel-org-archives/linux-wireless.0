Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33769 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbaA0UpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 15:45:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1W7t3G-00049p-WE
	for linux-wireless@vger.kernel.org; Mon, 27 Jan 2014 21:45:03 +0100
Received: from 151.66.154.13 ([151.66.154.13])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jan 2014 21:45:02 +0100
Received: from masterzorag by 151.66.154.13 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jan 2014 21:45:02 +0100
To: linux-wireless@vger.kernel.org
From: masterzorag <masterzorag@gmail.com>
Subject: ath9k, mac80211, kernel =?utf-8?b?V0FSTl9PTl9PTkNFOg==?= net/mac80211/rate.c:  =?utf-8?b?X19yYXRlX2NvbnRyb2xfc2VuZF9sb3c=?=
Date: Mon, 27 Jan 2014 17:15:04 +0000 (UTC)
Message-ID: <loom.20140127T180244-387@post.gmane.org> (sfid-20140127_214542_985002_86A7FE20)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

uname -a
Linux blackbox 3.13.0 #10 SMP Mon Jan 27 17:40:21 CET 2014 i686 AMD E-350
Processor AuthenticAMD GNU/Linux

lspci | grep Wir
03:00.0 Network controller: Qualcomm Atheros AR9285 Wireless Network Adapter
(PCI-Express) (rev 01)

iw wlan0 info
Interface wlan0
        ifindex 4
        wdev 0x1
        addr c0:f8:da:86:42:0d
        type managed
        wiphy 0
        channel 7 (2442 MHz), width: 40 MHz, center1: 2432 MHz

on mode N, resetting bitrates masks:
iw wlan0 set bitrates legacy-2.4
iw wlan0 set bitrates mcs-2.4

results in a device reset with this bounch of messages:

    Jan 27 17:59:01 blackbox kernel: wlan0: release an RX reorder frame due
to timeout on earlier frames
    Jan 27 17:59:02 blackbox kernel: wlan0: Rx BA session stop requested for
14:d6:4d:46:2d:19 tid 0 inititator reason: 0
    Jan 27 17:59:09 blackbox kernel: ------------[ cut here ]------------
    Jan 27 17:59:09 blackbox kernel: WARNING: CPU: 1 PID: 2493 at
net/mac80211/rate.c:263 __rate_control_send_low+0x92/0xbf [mac80211]()
    Jan 27 17:59:09 blackbox kernel: Modules linked in: ctr ccm ipv6 ath9k
ath9k_common ath9k_hw radeon ath kvm_amd snd_hda_codec_realtek mac80211 kvm
snd_hda_codec_hdmi cfbfillrect snd_hda_intel cfg80211 cfbimgblt cfbcopyarea
i2c_algo_bit drm_kms_helper snd_hda_codec rfkill ttm snd_hwdep snd_pcm drm
psmouse snd_page_alloc snd_timer agpgart r8169 snd backlight k10temp
xhci_hcd ohci_pci mii ohci_hcd ehci_pci sp5100_tco ehci_hcd rtc_cmos
i2c_piix4 evdev
    Jan 27 17:59:09 blackbox kernel: CPU: 1 PID: 2493 Comm: kworker/u4:0
Tainted: G           O 3.13.0 #10
    Jan 27 17:59:09 blackbox kernel: Hardware name: FOXCONN
NT-A2400&NT-A3500/NT-A2400&NT-A3500, BIOS 4.6.4 06/23/2011
    Jan 27 17:59:09 blackbox kernel: Workqueue: phy0
ieee80211_beacon_connection_loss_work [mac80211]
    Jan 27 17:59:09 blackbox kernel: 00000007 00000000 f39ffd0c c130b9cd
00000000 f39ffd24 c1024001 f8c985ba
    Jan 27 17:59:09 blackbox kernel: f39e7798 00000000 00000000 f39ffd34
c1024027 00000009 00000000 f39ffd50
    Jan 27 17:59:09 blackbox kernel: f8c985ba f4750360 0000000c f39e7780
f39ffe14 f475205c f39ffd70 f8c98744
    Jan 27 17:59:09 blackbox kernel: Call Trace:
    Jan 27 17:59:09 blackbox kernel: [<c130b9cd>] dump_stack+0x41/0x52
    Jan 27 17:59:09 blackbox kernel: [<c1024001>] warn_slowpath_common+0x5c/0x73
    Jan 27 17:59:09 blackbox kernel: [<f8c985ba>] ?
__rate_control_send_low+0x92/0xbf [mac80211]
    Jan 27 17:59:09 blackbox kernel: [<c1024027>] warn_slowpath_null+0xf/0x13
    Jan 27 17:59:09 blackbox kernel: [<f8c985ba>]
__rate_control_send_low+0x92/0xbf [mac80211]
    Jan 27 17:59:09 blackbox kernel: [<f8c98744>]
rate_control_send_low+0x5a/0xbf [mac80211]
    Jan 27 17:59:09 blackbox kernel: [<f8cb378f>]
minstrel_ht_get_rate+0x23/0x288 [mac80211]
    Jan 27 17:59:09 blackbox kernel: [<f8c98edb>]
rate_control_get_rate+0x85/0xb6 [mac80211]
    Jan 27 17:59:09 blackbox kernel: [<f8ca3217>]
invoke_tx_handlers+0x1039/0x10a8 [mac80211]
    Jan 27 17:59:09 blackbox kernel: [<c103f582>] ? try_to_wake_up+0x1d1/0x1d1
    Jan 27 17:59:09 blackbox kernel: [<f8ca3451>] ieee80211_tx+0x77/0x9a
[mac80211]
    Jan 27 17:59:09 blackbox kernel: [<f8ca38c5>] ieee80211_xmit+0x86/0x8f
[mac80211]
    Jan 27 17:59:09 blackbox kernel: [<f8ca44eb>]
__ieee80211_tx_skb_tid_band+0x5e/0x6b [mac80211]
    Jan 27 17:59:09 blackbox kernel: [<f8caad71>]
ieee80211_send_nullfunc+0x91/0x9a [mac80211]
    Jan 27 17:59:09 blackbox kernel: [<f8caadd2>]
ieee80211_mgd_probe_ap_send+0x58/0xf9 [mac80211]
    Jan 27 17:59:09 blackbox kernel: [<f8cab0e9>]
ieee80211_mgd_probe_ap.part.36+0xd8/0xe4 [mac80211]
    Jan 27 17:59:09 blackbox kernel: [<f8cab66a>]
ieee80211_beacon_connection_loss_work+0x64/0x6b [mac80211]
    Jan 27 17:59:09 blackbox kernel: [<c10334c2>] process_one_work+0x16c/0x27c
    Jan 27 17:59:09 blackbox kernel: [<c1033991>] worker_thread+0x19c/0x27d
    Jan 27 17:59:09 blackbox kernel: [<c10337f5>] ? rescuer_thread+0x202/0x202
    Jan 27 17:59:09 blackbox kernel: [<c1037746>] kthread+0x9f/0xa4
    Jan 27 17:59:09 blackbox kernel: [<c130f6b7>]
ret_from_kernel_thread+0x1b/0x28
    Jan 27 17:59:09 blackbox kernel: [<c10376a7>] ?
kthread_freezable_should_stop+0x3b/0x3b
    Jan 27 17:59:09 blackbox kernel: ---[ end trace 113ec2368607d936 ]---
    Jan 27 17:59:11 blackbox kernel: wlan0: Rx A-MPDU request on
14:d6:4d:46:2d:19 tid 0 result 0
    Jan 27 17:59:12 blackbox kernel: net_ratelimit: 2 callbacks suppressed
    Jan 27 17:59:12 blackbox kernel: wlan0: release an RX reorder frame due
to timeout on earlier frames


ath9k kernel debug:
Jan 27 19:10:10 blackbox kernel: ath: phy0: enable IER
Jan 27 19:10:10 blackbox kernel: ath: phy0: AR_IMR 0x918404b0 IER 0x1
Jan 27 19:10:10 blackbox kernel: ath: phy0: listenTime=971 OFDM:1
errs=1105/s CCK:0 errs=12/s ofdm_turn=1
Jan 27 19:10:10 blackbox kernel: ath: phy0: **** ofdmlevel 1=>2,
rssi=28[lo=7 hi=40]
Jan 27 19:10:10 blackbox kernel: ath: phy0: ** ch 2442: level 1=>2[def:3]
cycpwrThr1[level]=4 ini=6
Jan 27 19:10:10 blackbox kernel: ath: phy0: ** ch 2442: level 1=>2[def:3]
cycpwrThr1Ext[level]=4 ini=6
Jan 27 19:10:10 blackbox kernel: ath: phy0: ANI parameters: SI=2, ofdmWS=on
FS=1 MRCcck=off listenTime=971 ofdmErrs=1073 cckErrs=12
Jan 27 19:10:10 blackbox kernel: ath: phy0: ** ch 2442: level 1=>2[def:2]
firstep[level]=4 ini=4
Jan 27 19:10:10 blackbox kernel: ath: phy0: ** ch 2442: level 1=>2[def:2]
firstep_low[level]=4 ini=4
Jan 27 19:10:10 blackbox kernel: ath: phy0: ANI parameters: SI=2, ofdmWS=on
FS=2 MRCcck=off listenTime=971 ofdmErrs=1073 cckErrs=12
Jan 27 19:10:10 blackbox kernel: ath: phy0: Calibration @1440493 finished: 
 ani, caldone: true
Jan 27 19:10:10 blackbox kernel: ath: phy0: disable IER
Jan 27 19:10:10 blackbox kernel: ath: phy0: enable IER
Jan 27 19:10:10 blackbox kernel: ath: phy0: AR_IMR 0x918404b0 IER 0x1
Jan 27 19:10:10 blackbox kernel: ath: phy0: disable IER
Jan 27 19:10:10 blackbox kernel: ath: phy0: enable IER
Jan 27 19:10:10 blackbox kernel: ath: phy0: AR_IMR 0x918404b0 IER 0x1
Jan 27 19:10:10 blackbox kernel: ath: phy0: disable IER
and looping...

