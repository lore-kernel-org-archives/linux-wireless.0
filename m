Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:34537 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaFTXP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 19:15:56 -0400
Date: Sat, 21 Jun 2014 01:15:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bing Zhao <bzhao@marvell.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v3] mwifiex: Use the proper interfaces
In-Reply-To: <1403239692-3352-1-git-send-email-bzhao@marvell.com>
Message-ID: <alpine.DEB.2.10.1406210051340.5170@nanos> (sfid-20140621_011559_323296_DBA59A75)
References: <1403239692-3352-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 19 Jun 2014, Bing Zhao wrote:

> @@ -143,8 +142,7 @@ mwifiex_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
>  	       len - sizeof(struct ieee80211_hdr_3addr));
>  
>  	skb->priority = LOW_PRIO_TID;
> -	do_gettimeofday(&tv);
> -	skb->tstamp = timeval_to_ktime(tv);
> +	__net_timestamp(skb);

and __net_timestamp(skb) does

    skb->tstamp = ktime_get_real();

...

>  mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
>  				  const struct sk_buff *skb)
>  {
> +	u32 queue_delay = ktime_to_ms(ktime_sub(ktime_get(), skb->tstamp));

So now you do:

    delay = now(CLOCK_MONOTONIC) - tstamp(CLOCK_REALTIME);

Brilliant brainfart!

My original patch merily converted open coded crap to a consistent
one. And all of this was using the same time base: CLOCK_REALTIME.

Johannes rightfully started a discussion about CLOCK_REALTIME
vs. CLOCk_MONOTONIC suitability for certain use cases and then you
send a patch which subtracts different time bases and assign the
responsibility for that to Johannes:

> v3: don't use net_timedelta() (Johannes Berg)

Did you ever test that patch? Clearly not. Simply because on every
machine where now(CLOCK_MONOTONIC) != now(CLOCK_REALTIME) this falls
apart in bits and pieces. And that's the sane case, not the stupid
eval board without a RTC driver which defaults to 1970:00:00:00:00 and
happens to have CLOCK_MONOTONIC and CLOCK_REALTIME in sync.

So aside of not testing it proper, you clearly have no clue what you
are doing and then you have the chuzpe to claim that Johannes asked
you to do so.

Nice try.

Thanks,

	tglx



