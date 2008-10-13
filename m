Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:47122 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483AbYJMXFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 19:05:53 -0400
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
From: Pavel Roskin <proski@gnu.org>
To: Christian Lamparter <chunkeey@web.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223938526.27118.6.camel@dv>
References: <48EE20FB.4060700@lwfinger.net>
	 <1223936680.10113.7.camel@johannes.berg> <1223937392.27118.2.camel@dv>
	 <200810140055.34065.chunkeey@web.de>  <1223938526.27118.6.camel@dv>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 19:05:51 -0400
Message-Id: <1223939151.27769.3.camel@dv> (sfid-20081014_010557_204631_92AE445E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-13 at 18:55 -0400, Pavel Roskin wrote:
> On Tue, 2008-10-14 at 00:55 +0200, Christian Lamparter wrote:
> > > I don't get that on i386.  But the values don't seem to be corrupted
> > by
> > > byte-swapping.
> > >
> > Hmm, this should be impossible since:
> > "p54: report appropriate rate and band values for 802.11a"
> > 5f840304b5f7dff0028407fa9b284aecb85a94aa
> 
> I see.  It's recent code, so maybe it wasn't broken yet when I was
> testing it on i386.
> 
> This code in drivers/net/wireless/p54/p54common.c sets rate_idx:
> 
>   rx_status.rate_idx = (dev->conf.channel->band == IEEE80211_BAND_2GHZ ?
>   hdr->rate : (hdr->rate - 4)) & 0xf;
> 
> printk() shows:
> 
> dev->conf.channel->band = 1, hdr->rate = 0, rx_status.rate_idx = 12

And if I set rx_status.rate_idx to 0, I still get that badness for the
same reason (status->rate_idx = 12, sband->n_bitrates = 8).  Also, there
is another badness reported sometimes:

Badness at /home/proski/src/linux-2.6/net/mac80211/main.c:232
NIP: c02aa6a8 LR: c02aa6a0 CTR: c02cb578
REGS: eeacfe90 TRAP: 0700   Tainted: G        W  (2.6.27-wl)
MSR: 00029032 <EE,ME,IR,DR>  CR: 24004024  XER: 20000000
TASK = ef081800[6660] 'p54pci' THREAD: eeace000
GPR00: 00000001 eeacff40 ef081800 ffffffea c1bd1a20 00000056 00000031 ef10a000 
GPR08: 00000031 ffffffe9 00000056 c02cb578 00000011 00000000 01729138 000000db 
GPR16: 0172920c 41400000 0173dba4 00241678 c03b237c ef84dfb0 ef84dfac 00000001 
GPR24: c032cfa0 c0359d90 c032cfd8 00000001 00000000 eeace000 f103a6a8 c1a19180 
NIP [c02aa6a8] ieee80211_hw_config+0xa8/0xbc
LR [c02aa6a0] ieee80211_hw_config+0xa0/0xbc
Call Trace:
[eeacff40] [c02aa6a0] ieee80211_hw_config+0xa0/0xbc (unreliable)
[eeacff50] [c02b04f0] ieee80211_scan_work+0x144/0x1b8
[eeacff60] [c003b26c] run_workqueue+0xc4/0x160
[eeacff90] [c003b850] worker_thread+0x54/0xb8
[eeacffd0] [c003f788] kthread+0x50/0x88
[eeacfff0] [c000fe88] kernel_thread+0x44/0x60
Instruction dump:
80090014 7f805800 41bdffd0 4bffffc0 812306e8 4bffff90 81230060 81290014 
7d2903a6 4e800421 3123ffff 7c091910 <0f000000> 80010014 38210010 7c0803a6 

The code is:

        if (changed && local->open_count) {
                ret = local->ops->config(local_to_hw(local), changed);
                /*
                 * HW reconfiguration should never fail, the driver has told
                 * us what it can support so it should live up to that promise.
                 */
                WARN_ON(ret);
        }

-- 
Regards,
Pavel Roskin
