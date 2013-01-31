Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab3AaNYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:24:21 -0500
Message-ID: <1359638684.8415.12.camel@jlt4.sipsolutions.net> (sfid-20130131_142426_303526_C2D36869)
Subject: Re: WARNING: at net/mac80211/agg-tx.c:625  (3.7.5)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 31 Jan 2013 14:24:44 +0100
In-Reply-To: <51086F74.4060603@candelatech.com>
References: <510842C4.3040608@candelatech.com>
	   (sfid-20130129_224440_836761_5DE244B3) <1359496013.8108.22.camel@jlt4.sipsolutions.net>
	  <51084415.9060409@candelatech.com>
	 <1359496537.8108.23.camel@jlt4.sipsolutions.net>
	 <51086F74.4060603@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 16:55 -0800, Ben Greear wrote:
> On 01/29/2013 01:55 PM, Johannes Berg wrote:
> > On Tue, 2013-01-29 at 13:50 -0800, Ben Greear wrote:
> >> On 01/29/2013 01:46 PM, Johannes Berg wrote:
> >>> On Tue, 2013-01-29 at 13:44 -0800, Ben Greear wrote:
> >>>> This is in 3.7.5, plus one ath9k patch to over-ride eeprom regdomain.
> >>>>
> >>>> Code that causes this is here...I seem to have a good test case for
> >>>> this currently, so if there is any other debugging I could put here
> >>>> that would be useful, let me know.
> >>>>
> >>>> 	if (WARN_ON(!tid_tx)) {
> >>>> 		ht_dbg(sdata, "addBA was not requested!\n");
> >>>> 		goto unlock;
> >>>> 	}
> >>>
> >>> Heh, I think Kalle just had the same. Do you have the ht_dbg()
> >>> statements (i.e. HT debugging) enabled?
> >>
> >> No, it seems I do not.
> >>
> >> Want me to enable it?
> >
> > Please. Actually, if you can (and it applies) this patch would be
> > helpful too:
> > http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git;a=commit;h=0a214d3f7e5041685ebff054628a4354bedd78c3
> 
> I added that, and the patch that allows two VAPs to register for
> beacons so I can run both VAPs I have configured on this system...
> 
> I can grab more history if it helps...
> 
> 
> [  142.852997] vap0: delba from 00:0e:8e:32:12:cf (initiator) tid 0 reason code 37
> [  142.853110] vap0: switched off addBA timer for 00:0e:8e:32:12:cf tid 0
> [  142.853122] vap0: got addBA resp for 00:0e:8e:32:12:cf tid 0 but we already gave up
> [  142.853168] vap0: switched off addBA timer for 00:11:22:99:88:00 tid 0
> [  142.853192] vap0: got addBA resp for 00:11:22:99:88:00 tid 0 but we already gave up
> [  142.853219] vap0: Stopping Tx BA session for 00:0e:8e:32:12:cf tid 0
> [  142.853513] vap0: Stopping Tx BA session for 00:11:22:99:88:00 tid 0
> [  142.853769] vap0: Open BA session requested for 00:0e:8e:32:12:cf tid 0
> [  142.853961] vap0: Open BA session requested for 00:0e:8e:32:12:cf tid 0
> [  142.853976] vap0: BA request denied - session is not idle on 00:0e:8e:32:12:cf tid 0
> [  142.854166] vap0: Rx A-MPDU request on 00:0e:8e:32:12:cf tid 0 result 0
> [  142.854235] vap0: Open BA session requested for 00:0e:8e:32:12:cf tid 0
> [  142.854251] vap0: BA request denied - session is not idle on 00:0e:8e:32:12:cf tid 0
> [  142.854344] vap0: delba from 00:11:22:99:88:00 (initiator) tid 0 reason code 37
> [  142.854436] vap0: Rx A-MPDU request on 00:11:22:99:88:00 tid 0 result 0
> [  142.854556] ------------[ cut here ]------------
> [  142.863992] vap0: Open BA session requested for 00:11:22:99:88:00 tid 0
> [  142.864166] vap0: Open BA session requested for 00:11:22:99:88:00 tid 0
> [  142.864181] vap0: BA request denied - session is not idle on 00:11:22:99:88:00 tid 0
> [  142.864218] vap0: Open BA session requested for 00:11:22:99:88:00 tid 0
> [  142.864232] vap0: BA request denied - session is not idle on 00:11:22:99:88:00 tid 0
> [  142.864276] vap0: Open BA session requested for 00:11:22:99:88:00 tid 0
> [  142.864297] vap0: BA request denied - session is not idle on 00:11:22:99:88:00 tid 0
> [  142.864332] vap0: Open BA session requested for 00:11:22:99:88:00 tid 0
> [  142.864346] vap0: BA request denied - session is not idle on 00:11:22:99:88:00 tid 0
> [  142.866319] WARNING: at /home/greearb/git/linux-3.7.dev.y/net/mac80211/agg-tx.c:631 ieee80211_start_tx_ba_cb+0x1d2/0x220 [mac80211]()
> [  142.891075] Hardware name: To Be Filled By O.E.M.
> [  142.901277] Modules linked in: iptable_raw xt_CT nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack bridge veth ip_gre gre 8021q garp stp llc 
> macvlan pktgen fuse nfsv3 nfs_acl nfsv4 auth_rpcgss nfs fscache lockd sunrpc binfmt_misc uinput arc4 ath9k coretemp snd_hda_codec_realtek iTCO_wdt mac80211 
> iTCO_vendor_support gpio_ich snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device ath9k_common ath9k_hw snd_pcm ath lpc_ich microcode pcspkr i2c_i801 
> serio_raw cfg80211 snd_timer snd r8169 soundcore snd_page_alloc mii rfkill i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: iptable_nat]
> [  142.938975] Pid: 6, comm: kworker/u:0 Tainted: G         C   3.7.5+ #36
> [  142.938980] Call Trace:
> [  142.939062]  [<c04451bd>] warn_slowpath_common+0x6d/0xa0
> [  142.939100]  [<f8e933b2>] ? ieee80211_start_tx_ba_cb+0x1d2/0x220 [mac80211]
> [  142.939160]  [<f8e933b2>] ? ieee80211_start_tx_ba_cb+0x1d2/0x220 [mac80211]
> [  142.939202]  [<c044520d>] warn_slowpath_null+0x1d/0x20
> [  142.939232]  [<f8e933b2>] ieee80211_start_tx_ba_cb+0x1d2/0x220 [mac80211]
> [  142.939273]  [<c049d64b>] ? trace_hardirqs_on+0xb/0x10
> [  142.939287]  [<c09746df>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
> [  142.939321]  [<f8e977bf>] ieee80211_iface_work+0x20f/0x310 [mac80211]
> [  142.939364]  [<c045de76>] process_one_work+0x1a6/0x3d0
> [  142.939377]  [<c045de09>] ? process_one_work+0x139/0x3d0
> [  142.939389]  [<c0460e58>] ? worker_thread+0x198/0x380
> [  142.939417]  [<f8e975b0>] ? ieee80211_netdev_select_queue+0x10/0x10 [mac80211]
> [  142.939494]  [<c0460dc2>] worker_thread+0x102/0x380
> [  142.939506]  [<c0973362>] ? preempt_schedule+0x32/0x50
> [  142.939520]  [<c046596c>] kthread+0xac/0xb0
> [  142.939532]  [<c0460cc0>] ? manage_workers+0x2b0/0x2b0
> [  142.939543]  [<c0974742>] ? _raw_spin_unlock_irq+0x22/0x50
> [  142.939559]  [<c097a0b7>] ret_from_kernel_thread+0x1b/0x28
> [  142.939571]  [<c04658c0>] ? __init_kthread_worker+0x60/0x60
> [  142.939587] ---[ end trace 0f04f0a807663584 ]---
> [  142.939594] vap0: addBA was not requested!

Darn, it looks like I forgot to add the MAC address/TID to this debug
statement. Could you do that?

johannes

