Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59314 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbcHLKaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 06:30:19 -0400
Message-ID: <1470995683.26902.31.camel@sipsolutions.net> (sfid-20160812_123024_187100_73A2DD11)
Subject: Re: [PATCH v6] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com,
	djindal@qti.qualcomm.com
Date: Fri, 12 Aug 2016 11:54:43 +0200
In-Reply-To: <1470991178-11024-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1470991178-11024-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-12 at 14:09 +0530, Purushottam Kushwaha wrote:
> 
>   * @radar_detect_regions: bitmap of regions supported for radar
> detection
> + * @diff_beacon_int_gcd: This interface combination supports
> different beacon
> + *	intervals in multiple of GCD value.

I think you should add "Leave this set to 0 to require all beacon
intervals to match exactly."

And another thing I just realized: Perhaps somebody might not just have
a GCD requirement, but also require that all beacon intervals are an
exact multiple of the smallest of them? I.e. that the GCD(all of them)
== min(all of them)?

Anyway, if you don't have such a requirement now, there's no reason to
add it now either.

>   * With this structure the driver can describe which interface
>   * combinations it supports concurrently.
> @@ -2970,6 +2972,7 @@ struct ieee80211_iface_limit {
>   *	.n_limits = ARRAY_SIZE(limits2),
>   *	.max_interfaces = 8,
>   *	.num_different_channels = 1,
> + *	.diff_beacon_int_gcd = 100,
>   *  };

This becomes somewhat curious. Does it also mean that you can only
support beacon intervals that are multiples of 100?

This being your example kinda makes me think that you *do* want to have
it multiples of the smallest, like I was outlining below?

Assuming your driver would advertise it this way, would you actually be
able to do BIs of 200 and 300 on two interfaces?

Regardless, advertising 100 would mean not supporting a beacon interval
of 50 at all, which seems odd.


I think the GCD requirement should be rephrased (and my original
mention of this wasn't very precise) - I think it really shouldn't be
an exact GCD requirement like you did now, but a requirement *on* the
GCD, like

 @diff_beacon_int_gcd_min: When 0, all beacon intervals must match.
	When >0, different beacon intervals must have a GCD that's at
	least as big as this value.

maybe also add, since the GCD of a single value is fishy:

	When >0, any beacon interval must also be bigger than this
	value.

With a diff_beacon_int_gcd_min=50, this would still allow beacon
intervals 102,153 (GCD 51), which seems much more flexible.

The clarification that it also represents the minimum for a single
beacon interval would make some sense to me, but at the same time it
can't be used only for that, so perhaps separating a minimum out
(rather than using the hard-coded minimum of 10) would make sense.

> + * @NL80211_IFACE_COMB_DIFF_BI_GCD: u32 attribute specifying the GCD
> of
> + *	different beacon intervals supported by all the interface
> combinations
> + *	in this group (not present if all beacon interval must
> match).

I'd turn that around: "(if not present, all beacon intervals must
match)"

> +struct diff_beacon_int {
> > +	u32 beacon_int;
> > +	bool valid;
> +};
> +
> +static void
> +cfg80211_validate_diff_beacon_int(const struct ieee80211_iface_combination *c,
> > +				  void *data)
> +{
> > +	struct diff_beacon_int *diff_bi = data;
> +
> > +	if (c->diff_beacon_int_gcd &&
> > +	    !(diff_bi->beacon_int % c->diff_beacon_int_gcd))
> > +		diff_bi->valid = true;
> +}
> > 

Obviously, this validation is far easier than calculating the GCD
first, but I think it's worthwhile doing it the other way.

johannes

