Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:33609 "EHLO sequoia2.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752389Ab3GaNyz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 09:54:55 -0400
Date: Wed, 31 Jul 2013 06:26:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.11] mac80211: ignore HT primary channel while connected
Message-ID: <20130731132625.GA23521@sequoia2.sous-sol.org> (sfid-20130731_155458_607166_ED86BFF1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375264234-31077-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Johannes Berg (johannes@sipsolutions.net) wrote:
> While we're connected, the AP shouldn't change the primary channel
> in the HT information. We checked this, and dropped the connection
> if it did change it.
> 
> Unfortunately, this is causing problems on some APs, e.g. on the
> Netgear WRT610NL: the beacons seem to always contain a bad channel
> and if we made a connection using a probe response (correct data)
> we drop the connection immediately and can basically not connect
> properly at all.
> 
> Work around this by ignoring the HT primary channel information in
> beacons if we're already connected.
> 
> Also print out more verbose messages in the other situations to
> help diagnose similar bugs quicker in the future.

I just gave this a try, and my laptop is still hanging w/ same WARN_ON
being triggered:

...
	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
					IEEE80211_CHAN_DISABLED)) {
		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
			ret = IEEE80211_STA_DISABLE_HT |
			      IEEE80211_STA_DISABLE_VHT;
			goto out;
		}
...

Jul 31 05:45:10 x220 kernel: [   40.047670] wlp3s0: authenticate with 2c:36:f8:fa:46:21
Jul 31 05:45:10 x220 kernel: [   40.053635] wlp3s0: send auth to 2c:36:f8:fa:46:21 (try 1/3)
Jul 31 05:45:10 x220 kernel: [   40.146302] wlp3s0: authenticated
Jul 31 05:45:10 x220 kernel: [   40.146675] wlp3s0: waiting for beacon from 2c:36:f8:fa:46:21
Jul 31 05:45:11 x220 kernel: [   40.250878] wlp3s0: associate with 2c:36:f8:fa:46:21 (try 1/3)
Jul 31 05:45:11 x220 kernel: [   40.254241] wlp3s0: RX AssocResp from 2c:36:f8:fa:46:21 (capab=0x101 status=0 aid=3)
Jul 31 05:45:11 x220 kernel: [   40.275168] wlp3s0: associated
Jul 31 05:45:11 x220 kernel: [   40.275252] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
Jul 31 05:45:11 x220 kernel: [   40.275385] cfg80211: Calling CRDA for country: DE
Jul 31 05:45:11 x220 kernel: [   40.296753] cfg80211: Regulatory domain changed to country: DE
Jul 31 05:45:11 x220 kernel: [   40.296763] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 31 05:45:11 x220 kernel: [   40.296769] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 31 05:45:11 x220 kernel: [   40.296774] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 31 05:45:11 x220 kernel: [   40.296778] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 31 05:45:11 x220 kernel: [   40.296782] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
Jul 31 05:45:11 x220 kernel: [   40.296787] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
Jul 31 05:45:11 x220 NetworkManager[574]: <info> (wlp3s0): supplicant interface state: scanning -> authenticating
Jul 31 05:45:11 x220 NetworkManager[574]: <info> (wlp3s0): supplicant interface state: authenticating -> associating
Jul 31 05:45:11 x220 NetworkManager[574]: <info> (wlp3s0): supplicant interface state: associating -> completed
Jul 31 05:45:11 x220 NetworkManager[574]: <info> Activation (wlp3s0/wireless) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'ietf'.
Jul 31 05:45:11 x220 NetworkManager[574]: <info> Activation (wlp3s0) Stage 3 of 5 (IP Configure Start) scheduled.
Jul 31 05:45:11 x220 NetworkManager[574]: <info> Activation (wlp3s0) Stage 3 of 5 (IP Configure Start) started...
Jul 31 05:45:11 x220 NetworkManager[574]: <info> (wlp3s0): device state change: config -> ip-config (reason 'none') [50 70 0]
Jul 31 05:45:11 x220 NetworkManager[574]: <info> Activation (wlp3s0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Jul 31 05:45:11 x220 NetworkManager[574]: <info> dhclient started with pid 1786
Jul 31 05:45:11 x220 NetworkManager[574]: <info> Activation (wlp3s0) Beginning IP6 addrconf.
Jul 31 05:45:11 x220 NetworkManager[574]: <info> Activation (wlp3s0) Stage 3 of 5 (IP Configure Start) complete.
Jul 31 05:45:11 x220 kernel: [   40.354582] ------------[ cut here ]------------
Jul 31 05:45:11 x220 kernel: [   40.354628] WARNING: CPU: 2 PID: 85 at net/mac80211/mlme.c:338 ieee80211_determine_chantype+0x26f/0x380 [mac80211]()
Jul 31 05:45:11 x220 kernel: [   40.354631] Modules linked in: ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM iptable_mangle tun bridge openvswitch stp llc bnep bluetooth arc4 iwldvm ip6t_REJECT nf_conntrack_ipv6 nf_conntrack_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 ip6table_filter ip6_tables xt_conntrack nf_conntrack mac80211 iwlwifi snd_hda_codec_hdmi uvcvideo snd_hda_codec_conexant cfg80211 snd_hda_intel videobuf2_vmalloc snd_hda_codec videobuf2_memops videobuf2_core snd_hwdep iTCO_wdt videodev iTCO_vendor_support snd_seq media snd_seq_device sdhci_pci sdhci snd_pcm e1000e i2c_i801 joydev mmc_core lpc_ich mfd_core thinkpad_acpi tpm_tis wmi tpm rfkill snd_page_alloc tpm_bios snd_timer snd ptp soundcore pps_core mperf uinput binfmt_misc dm_crypt i915 i2c_algo_bit drm_kms_helper drm i2c_core video
Jul 31 05:45:11 x220 kernel: [   40.354715] CPU: 2 PID: 85 Comm: kworker/u16:4 Not tainted 3.11.0-rc3+ #7
Jul 31 05:45:11 x220 kernel: [   40.354720] Hardware name: LENOVO 4291CL9/4291CL9, BIOS 8DET56WW (1.26 ) 12/01/2011
Jul 31 05:45:11 x220 kernel: [   40.354744] Workqueue: phy0 ieee80211_iface_work [mac80211]
Jul 31 05:45:11 x220 kernel: [   40.354748]  0000000000000009 ffff880403cff9d8 ffffffff8160bd12 0000000000000000
Jul 31 05:45:11 x220 kernel: [   40.354754]  ffff880403cffa10 ffffffff8105393d ffff880403cffae0 0000000000000810
Jul 31 05:45:11 x220 kernel: [   40.354759]  ffff8803f6638800 0000000000000001 ffff8803f3e37070 ffff880403cffa20
Jul 31 05:45:11 x220 kernel: [   40.354765] Call Trace:
Jul 31 05:45:11 x220 kernel: [   40.354776]  [<ffffffff8160bd12>] dump_stack+0x45/0x56
Jul 31 05:45:11 x220 kernel: [   40.354784]  [<ffffffff8105393d>] warn_slowpath_common+0x7d/0xa0
Jul 31 05:45:11 x220 kernel: [   40.354791]  [<ffffffff81053a1a>] warn_slowpath_null+0x1a/0x20
Jul 31 05:45:11 x220 kernel: [   40.354819]  [<ffffffffa040be2f>] ieee80211_determine_chantype+0x26f/0x380 [mac80211]
Jul 31 05:45:11 x220 kernel: [   40.354852]  [<ffffffffa040f209>] ieee80211_rx_mgmt_beacon+0x589/0x10f0 [mac80211]
Jul 31 05:45:11 x220 kernel: [   40.354885]  [<ffffffffa04111d3>] ieee80211_sta_rx_queued_mgmt+0x2b3/0x530 [mac80211]
Jul 31 05:45:11 x220 kernel: [   40.354931]  [<ffffffff81092d74>] ? load_balance+0x144/0x790
Jul 31 05:45:11 x220 kernel: [   40.354962]  [<ffffffffa03e31cc>] ieee80211_iface_work+0x25c/0x360 [mac80211]
Jul 31 05:45:11 x220 kernel: [   40.354971]  [<ffffffff8107131f>] process_one_work+0x16f/0x420
Jul 31 05:45:11 x220 kernel: [   40.354979]  [<ffffffff81071f3b>] worker_thread+0x11b/0x390
Jul 31 05:45:11 x220 kernel: [   40.354987]  [<ffffffff81071e20>] ? manage_workers.isra.25+0x2a0/0x2a0
Jul 31 05:45:11 x220 kernel: [   40.354994]  [<ffffffff810784a0>] kthread+0xc0/0xd0
Jul 31 05:45:11 x220 kernel: [   40.355002]  [<ffffffff810783e0>] ? insert_kthread_work+0x40/0x40
Jul 31 05:45:11 x220 kernel: [   40.355010]  [<ffffffff8161af1c>] ret_from_fork+0x7c/0xb0
Jul 31 05:45:11 x220 kernel: [   40.355017]  [<ffffffff810783e0>] ? insert_kthread_work+0x40/0x40
Jul 31 05:45:11 x220 kernel: [   40.355022] ---[ end trace a4924d352b62426c ]---

And this continues until I hit power switch.  Any specific debugging that would 
be helpful?

thanks,
-chris
