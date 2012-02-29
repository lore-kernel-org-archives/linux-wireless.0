Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:55720 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449Ab2B2Ijx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 03:39:53 -0500
Received: by mail-lpp01m010-f50.google.com with SMTP id m13so8925620lah.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 00:39:51 -0800 (PST)
Message-ID: <1330504788.18637.90.camel@cumari> (sfid-20120229_093958_816044_0280A68C)
Subject: Re: [PATCH 3/7] wl12xx: reset link Tx queues when freeing it
From: Luciano Coelho <coelho@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 10:39:48 +0200
In-Reply-To: <87pqcyavn5.fsf@purkki.adurom.net>
References: <1330382494-31148-1-git-send-email-arik@wizery.com>
	 <1330382494-31148-3-git-send-email-arik@wizery.com>
	 <1330422678.18637.28.camel@cumari> <87pqcyavn5.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-29 at 10:31 +0200, Kalle Valo wrote: 
> Luciano Coelho <coelho@ti.com> writes:
> 
> >> @@ -973,8 +974,14 @@ void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
> >>  	struct sk_buff *skb;
> >>  	struct ieee80211_tx_info *info;
> >>  
> >> -	for (i = 0; i < NUM_TX_QUEUES; i++)
> >> -		wl->tx_queue_count[i] = 0;
> >> +	/* only reset the queues if something bad happened */
> >> +	if (WARN_ON(wl1271_tx_total_queue_count(wl) != 0)) {
> >
> > Let's make all these WARN_ONs as WARN_ON_ONCE as it is recommended
> > nowadays.  This will make Kalle Valo happier. :)
> 
> Hehe. Actually the dislike against WARN_ON() was started by John, I
> again started the war to killing BUG_ON() :)

Right, John's email was where I got the "recommended" from. ;)


> But nevertheless, this changes makes also me happy. I have seen cases
> where the whole system reboots because of WARN_ON() spam, so
> WARN_ON_ONCE() is much better in in cases where's a possibility that it
> will get printed a lot. Of course printk_ratelimit() is another option,
> but for some reason it isn't that popular.

Yeah, I totally agree.  Especially when we have a loop, WARN_ON_ONCE
should be sufficient, in my opinion.

-- 
Cheers,
Luca.

