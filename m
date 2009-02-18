Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51782 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbZBRPOy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 10:14:54 -0500
Subject: Re: Missing link quality with wireless-testing
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1234964271.4023.21.camel@johannes.local>
References: <1234896777.4678.7.camel@californication>
	 <1234899806.29785.35.camel@johannes.local>
	 <1234902294.4678.12.camel@californication>
	 <1234904111.29785.44.camel@johannes.local>
	 <1234904978.4678.31.camel@californication>
	 <1234913132.11832.10.camel@70-5-246-164.pools.spcsdns.net>
	 <1234933059.21412.28.camel@californication>
	 <20090218073104.GA23366@jm.kir.nu>
	 <1234944391.21412.47.camel@californication>
	 <20090218082520.GA26280@jm.kir.nu>  <1234959523.13950.47.camel@localhost>
	 <1234964271.4023.21.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 10:13:06 -0500
Message-Id: <1234969986.19743.7.camel@localhost> (sfid-20090218_161458_454251_6213CB9B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-02-18 at 14:37 +0100, Johannes Berg wrote:
> On Wed, 2009-02-18 at 07:18 -0500, Dan Williams wrote:
> 
> [snipped explanation]
> 
> > Anyone think all this stuff really, really sucks?  Yes!!!  So lets just
> > have drivers/stack provide a few sane values that userspace really
> > doesn't have to go through this shit to calculate...
> > 
> > <rant ends>
> > 
> > NM is probably fine here with qual == 0 because I doubt the GIWRANGE
> > handler is returning a valid max_qual.qual > 0 anymore with Johannes'
> > patch.  Could be wrong though.
> 
> We're actually getting _two_ things wrong now and nobody ever noticed.
> So much for "but someone might care about the values wext returns". But
> there actually is a problem.
> 
> First, we're reporting max_qual.qual != 0 still, this should be changed.
> wpa_supplicant is still reporting quality values, so the invalid flags
> aren't ever set. This needs to change in mac80211 (fixing the immediate
> regression) and wpa_supplicant.
> 
> HOWEVER. Since all our qual.qual values are 0 though, your code _should_
> cope fine, because of this (from NM):
> 
>         /* If the quality percent was 0 or doesn't exist, then try to use signal levels instead */
>         if ((percent < 1) && (level_percent >= 0))
>                 percent = level_percent;
> 
> Now, why doesn't it?
> 
> Because we don't report proper max_qual _level_ values. Something
> clearly nobody cared about because NM was using qual.qual and not
> qual.level. Here's the relevant snippet from mac80211:
> 
>         /* cfg80211 requires this, and enforces 0..100 */
>         if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
>                 range->max_qual.level = 100;
>         else if  (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
>                 range->max_qual.level = -110;
>         else
>                 range->max_qual.level = 0;
> 
> Note the dBm branch -- clearly wrong. Did anyone care? Clearly not.

Almost; I was partially wrong as well.  The comments from wireless.h
imply that max_qual.level in the dBm case can be < 0.  Remember that
these values are *s8*, and thus max_qual.level can be < 0 and greater
than -127 at least.

This of course doesn't allow RSSI-based levels of > 127, but whatever.
To get the definitive determination of RSSI vs. dBm for level, you use
(updated & IW_QUAL_DBM).

The understanding of max_qual.level == 0 means dBm was probably from
conversations with Jean and that's apparently not borne out by the
evidence from wireless.h, unless there's something else I'm not reading.

NM doesn't handle IW_QUAL_DBM.  It should.

> Therefore, here's what I'm going to do:
>  1) always set IW_QUAL_QUAL_INVALID, even in max_qual (fixes bug #1)
>  2) set max_qual.level to 0 for dBm instead of -110 (fixes bug #2)
> 
> patch below.

I think leaving max_qual.level == -110 is OK in mac80211 actually.  It's
NM that's got the problem by not respecting IW_QUAL_DBM.

Dan


> johannes
> 
> Subject: mac80211: fix wext max_qual report
> 
> mac80211 is reporting a max_qual.level of -110 for dBm while it
> should be reporting 0. It is also reporting a valid max_qual.qual
> although we no longer set qual.qual, which trips up NetworkManager
> due to a wpa_supplicant bug. But we don't need to report that our
> max_qual.qual value is valid.
> 
> Fix the max_qual.level to be 0 for dBm and 100 for non-dBm and
> remove max_qual.qual. max_qual.noise = -110 also seems wrong,
> so fix that while at it.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/wext.c |   28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> --- wireless-testing.orig/net/mac80211/wext.c	2009-02-18 14:24:56.000000000 +0100
> +++ wireless-testing/net/mac80211/wext.c	2009-02-18 14:29:07.000000000 +0100
> @@ -148,11 +148,19 @@ static u8 ieee80211_get_wstats_flags(str
>  {
>  	u8 wstats_flags = 0;
>  
> -	wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
> -					   IEEE80211_HW_SIGNAL_DBM) ?
> -				IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
> -	wstats_flags |= local->hw.flags & IEEE80211_HW_NOISE_DBM ?
> -				IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
> +	wstats_flags |= IW_QUAL_QUAL_INVALID;
> +
> +	if (local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
> +			       IEEE80211_HW_SIGNAL_DBM))
> +		wstats_flags |= IW_QUAL_LEVEL_UPDATED;
> +	else
> +		wstats_flags |= IW_QUAL_LEVEL_INVALID;
> +
> +	if (local->hw.flags & IEEE80211_HW_NOISE_DBM)
> +		wstats_flags |= IW_QUAL_NOISE_UPDATED;
> +	else
> +		wstats_flags |= IW_QUAL_NOISE_INVALID;
> +
>  	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
>  		wstats_flags |= IW_QUAL_DBM;
>  
> @@ -191,19 +199,11 @@ static int ieee80211_ioctl_giwrange(stru
>  	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
>  		range->max_qual.level = 100;
>  	else if  (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
> -		range->max_qual.level = -110;
> -	else
>  		range->max_qual.level = 0;
>  
> -	if (local->hw.flags & IEEE80211_HW_NOISE_DBM)
> -		range->max_qual.noise = -110;
> -	else
> -		range->max_qual.noise = 0;
> -
> -	range->max_qual.qual = 100;
> +	range->max_qual.noise = 0;
>  	range->max_qual.updated = ieee80211_get_wstats_flags(local);
>  
> -	range->avg_qual.qual = 50;
>  	/* not always true but better than nothing */
>  	range->avg_qual.level = range->max_qual.level / 2;
>  	range->avg_qual.noise = range->max_qual.noise / 2;
> 
> 

