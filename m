Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50606 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009AbaFTXm2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 19:42:28 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>
Date: Fri, 20 Jun 2014 16:42:15 -0700
Subject: RE: [PATCH v3] mwifiex: Use the proper interfaces
Message-ID: <477F20668A386D41ADCC57781B1F70430FE56126BE@SC-VEXCH1.marvell.com> (sfid-20140621_014235_050856_0BE4DA65)
References: <1403239692-3352-1-git-send-email-bzhao@marvell.com>
 <alpine.DEB.2.10.1406210051340.5170@nanos>
In-Reply-To: <alpine.DEB.2.10.1406210051340.5170@nanos>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas,

> > @@ -143,8 +142,7 @@ mwifiex_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
> >  	       len - sizeof(struct ieee80211_hdr_3addr));
> >
> >  	skb->priority = LOW_PRIO_TID;
> > -	do_gettimeofday(&tv);
> > -	skb->tstamp = timeval_to_ktime(tv);
> > +	__net_timestamp(skb);
> 
> and __net_timestamp(skb) does
> 
>     skb->tstamp = ktime_get_real();

Ah, I didn't realize that __net_timestamp also does ktime_get_real.
Thanks for pointing it out!

> 
> ...
> 
> >  mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
> >  				  const struct sk_buff *skb)
> >  {
> > +	u32 queue_delay = ktime_to_ms(ktime_sub(ktime_get(), skb->tstamp));
> 
> So now you do:
> 
>     delay = now(CLOCK_MONOTONIC) - tstamp(CLOCK_REALTIME);
> 
> Brilliant brainfart!
> 
> My original patch merily converted open coded crap to a consistent
> one. And all of this was using the same time base: CLOCK_REALTIME.
> 
> Johannes rightfully started a discussion about CLOCK_REALTIME
> vs. CLOCk_MONOTONIC suitability for certain use cases and then you
> send a patch which subtracts different time bases and assign the
> responsibility for that to Johannes:
> 
> > v3: don't use net_timedelta() (Johannes Berg)

I just wanted to thank Johannes for commenting.

> 
> Did you ever test that patch? Clearly not. Simply because on every
> machine where now(CLOCK_MONOTONIC) != now(CLOCK_REALTIME) this falls
> apart in bits and pieces. And that's the sane case, not the stupid
> eval board without a RTC driver which defaults to 1970:00:00:00:00 and
> happens to have CLOCK_MONOTONIC and CLOCK_REALTIME in sync.
> 
> So aside of not testing it proper, you clearly have no clue what you
> are doing and then you have the chuzpe to claim that Johannes asked
> you to do so.

I will revert this patch.

Thank you again for pointing out my error.

Regards,
Bing

> 
> Nice try.
> 
> Thanks,
> 
> 	tglx
> 
> 

