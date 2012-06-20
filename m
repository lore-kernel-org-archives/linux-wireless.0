Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2FTI3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:29:53 -0400
Message-ID: <1340180991.4655.30.camel@jlt3.sipsolutions.net> (sfid-20120620_102959_517743_5206BEC9)
Subject: Re: [PATCH v3 1/2] nl80211/cfg80211: add scan channel times to scan
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Date: Wed, 20 Jun 2012 10:29:51 +0200
In-Reply-To: <CAK80WHYU+dOvMQG2aDTP7rO6b=MZXDVcX4a7KGpLizgutVcD8g@mail.gmail.com>
References: <1340177634-24568-1-git-send-email-victorg@ti.com>
	 <1340178370.4655.22.camel@jlt3.sipsolutions.net>
	 <CAK80WHYU+dOvMQG2aDTP7rO6b=MZXDVcX4a7KGpLizgutVcD8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 11:23 +0300, Goldenshtein, Victor wrote:

> The attributes are optional, so the scan will run as usual using the
> default scan times defined in cfg for software scan and default driver
> specific values for the hw_scan (if those exist).

Right.

> > I think you should ignore the attributes if NL80211_FEATURE_SCAN_TIMES
> > is not set. That will enforce that anyone implementing it sets the
> > feature flag correctly, if they ever test their code at all anyway :-)
> >
> >
> 
> The porpoise of the NL80211_FEATURE_SCAN_TIMES (as we discussed
> before) is to advertise this capability to usermode which implements
> 802.11k.

Yes, but if we let the attributes through then the driver author can
test his code and see different timings, even though the flag isn't set,
and then get confused. It'd be easier for the driver authors and more
reliable if we require the flag to be set for even reading timings from
userspace. Otherwise the driver might honour them even if the flag isn't
set which is very odd.


> > I pointed this out before -- this is problematic. Userspace could
> > request a max time of 10, and then this would set the min time to 30,
> > which means min > max which is completely stupid. We should prevent such
> > settings.
> >
> 
> This check is done in nl80211_trigger_scan(), please see:
> 
> +» » if·(request->min_ch_time·>·request->max_ch_time)
> +» » » return·-EINVAL;
> 
> and
> 
> +» » if·(request->min_passive_ch_time·>·request->max_passive_ch_time)
> +» » » return·-EINVAL;
> 
> in this case we return EINVAL, btw this also documented:
> + *    If one of the min times will be greater than max or set to zero,
> + *    -EINVAL will be returned. For the software scan only the min times

You're not getting it.

If I set *ONLY* max_passive_ch_time = 10 via nl80211, what will happen?


> > are you sure that wext uses TUs?
> >
> 
> yes, from "struct iw_scan_req":
> 	__u32		min_channel_time; /* in TU */
> 	__u32		max_channel_time; /* in TU */

Ok, great.

johannes


