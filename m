Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12740 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab0LFTgG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 14:36:06 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 11:35:52 -0800
Date: Mon, 6 Dec 2010 11:36:00 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Felix Fietkau <nbd@openwrt.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Script to crash ath9k with DMA errors.
Message-ID: <20101206193600.GC21442@tux>
References: <4CF44543.9070605@candelatech.com>
 <20101130004424.GC1901@tux>
 <4CF6D8C8.2000308@candelatech.com>
 <4CF8A6DE.4020804@candelatech.com>
 <4CFAFBE1.3080505@openwrt.org>
 <4CFB20BA.5090300@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CFB20BA.5090300@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 04, 2010 at 09:18:50PM -0800, Ben Greear wrote:
> On 12/04/2010 06:41 PM, Felix Fietkau wrote:
> > On 2010-12-03 9:14 AM, Ben Greear wrote:
> >> On 12/01/2010 03:22 PM, Ben Greear wrote:
> >>> On 11/29/2010 04:44 PM, Luis R. Rodriguez wrote:
> >>>> On Mon, Nov 29, 2010 at 04:28:51PM -0800, Ben Greear wrote:
> >>>
> >>>>> BUG: unable to handle kernel NULL pointer dereference at 00000040
> >>>>> IP: [<f933470a>] ath_tx_start+0x461/0x5ef [ath9k]
> >>>>> *pde = 00000000
> >>>>> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> >>>>> last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/irq
> >>>>> Modules linked in: aes_i586 aes_generic fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9k_common ath9k_hw mi]
> >>>>>
> >>>>> Pid: 38, comm: kworker/u:1 Tainted: G        W   2.6.37-rc3-wl+ #53 PDSBM/PDSBM
> >>>>> EIP: 0060:[<f933470a>] EFLAGS: 00010246 CPU: 1
> >>>>> EIP is at ath_tx_start+0x461/0x5ef [ath9k]
> >>>>
> >>>> Please use
> >>>>
> >>>> gdb drivers/net/wireless/ath/ath9k/
> >>>> l *(ath_tx_start+0x461)
> >>>>
> >>>>      Luis
> >>>
> >>> I managed to hit that ath_tx_start crash again, and this time there were no obvious
> >>> DMA or irq errors immediately preceding it.  So, it might be a real bug
> >>> after all.  I'll add some extra checks to see if tid->ac is NULL.
> >>
> >> I've made some small progress on this general issue.
> >>
> >> First, I added all sorts of debugging to try to figure out ath_tx_start crash.
> >> As best as I can tell, 'tid' is not NULL, but also is not a valid pointer,
> >> and probably something close to 0x0.  I've added yet more debugging, but haven't
> >> hit the problem again.
> >>
> >> I also tried stopping DMA in a loop up to 5 times if it failed to stop
> >> previously in the loop.  This did not appear to help at all.
> >>
> >> I also managed to make both the ath_tx_start crash and the DMA errors very hard to reproduce
> >> (I dare not say fixed, yet).
> >>
> >> It appears that this small patch (and possibly, the fact that I set debugging to 0x600
> >> instead of 0x400) makes the problems go away.  This makes me wonder if a root cause is
> >> something to do with repeatedly resetting the hardware too fast, as setting channels rapidly
> >> would tend to do that, and channels are set on association by supplicant, it appears.
> > Please try this patch while leaving the unnecessary resets in place.
> > I found that when ath_drain_all_txq finds tx dma not stopped, it will
> > issue a reset at a point in time where it is both useless (since it's
> > right before a reset anyway) and dangerous (since the rx dma engine
> > isn't even disabled yet), so IMHO the right thing to do is to drop
> > this extra reset.
> >
> > --- a/drivers/net/wireless/ath/ath9k/xmit.c
> > +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> > @@ -1194,18 +1194,8 @@ void ath_drain_all_txq(struct ath_softc
> >   		}
> >   	}
> >
> > -	if (npend) {
> > -		int r;
> > -
> > -		ath_print(common, ATH_DBG_FATAL,
> > -			  "Failed to stop TX DMA. Resetting hardware!\n");
> > -
> > -		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, ah->caldata, false);
> > -		if (r)
> > -			ath_print(common, ATH_DBG_FATAL,
> > -				  "Unable to reset hardware; reset status %d\n",
> > -				  r);
> > -	}
> > +	if (npend)
> > +		ath_print(common, ATH_DBG_FATAL,  "Failed to stop TX DMA!\n");
> >
> >   	for (i = 0; i<  ATH9K_NUM_TX_QUEUES; i++) {
> >   		if (ATH_TXQ_SETUP(sc, i))
> 
> 
> I applied this on top of all my patches, and on top of the 4 that Luis recently
> posted.
> 
> I'm trying this on a different system than normal..happens to be configured
> with 115 stations.  It was getting this fail-to-stop-RX warning even with my
> channel-change mitigation patch, so I left it in.  I can still test w/it removed
> if you want.
> 
> None of my interfaces are using WPA (or supplicant)..just un-encrypted
> association to an AP 3 feet away.
> 
> The recent success I had on Friday was on a different system entirely,
> with only 84 STAs, and using wpa-supplicant with 30 or so stations
> using WPA and the other 55 on a different AP un-encrypted (still using
> wpa_supplicant for all of these).
> 
> So, can't compare my previous reports directly with this one.
> 
> I'm going to re-configure this one to have smaller numbers of
> stations and use wpa_supplicant..will see how that goes.
> 
> Even with all these warnings in the logs..system is basically stable and
> a few interfaces are able to associate, at least for a short time.
>
> 
> WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/recv.c:538 ath_stoprecv+0xcd/0xd7 [ath9k]()
> Hardware name: 945GM
> Could not stop RX, we could be confusing the DMA engine when we start RX up
> Modules linked in: 8021q garp stp llc michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss 
> sunrpc p4_clockmod ipv6 uinput arc4 ecb ath9k mac80211 snd_intel8x0 snd_ac97_codec ath9k_common ac97_bus snd_seq snd_seq_device ath9k_hw ath snd_pcm pcspkr 
> i2c_i801 serio_raw cfg80211 iTCO_wdt iTCO_vendor_support microcode snd_timer snd soundcore e1000e snd_page_alloc yenta_socket floppy i915 drm_kms_helper drm 
> i2c_algo_bit i2c_core video output [last unloaded: ipt_addrtype]
> Pid: 5, comm: kworker/u:0 Tainted: G        W   2.6.37-rc4-wl+ #16
> Call Trace:
>   [<78436fbd>] warn_slowpath_common+0x77/0x8c
>   [<f946028f>] ? ath_stoprecv+0xcd/0xd7 [ath9k]
>   [<f946028f>] ? ath_stoprecv+0xcd/0xd7 [ath9k]
>   [<7843704e>] warn_slowpath_fmt+0x2e/0x30
>   [<f946028f>] ath_stoprecv+0xcd/0xd7 [ath9k]
>   [<f945e4bb>] ath_reset+0x55/0x163 [ath9k]
>   [<7845a68d>] ? trace_hardirqs_on+0xb/0xd
>   [<f9462830>] ath_tx_complete_poll_work+0x90/0xdf [ath9k]
>   [<78446fd4>] process_one_work+0x1af/0x2bf
>   [<78446f63>] ? process_one_work+0x13e/0x2bf
>   [<f94627a0>] ? ath_tx_complete_poll_work+0x0/0xdf [ath9k]
>   [<78448722>] worker_thread+0xf9/0x1bf
>   [<78448629>] ? worker_thread+0x0/0x1bf
>   [<7844b252>] kthread+0x62/0x67
>   [<7844b1f0>] ? kthread+0x0/0x67
>   [<784036c6>] kernel_thread_helper+0x6/0x1a

Can you clarify the status of this issue. It remains unclear to me from
your above description how things are going. As I read it some things
look OK now but you still get a warning.

  Luis
