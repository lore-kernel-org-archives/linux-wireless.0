Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbbHNJAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 05:00:46 -0400
Date: Fri, 14 Aug 2015 11:00:44 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: GCOV_PROFILE_ALL breaks BUILD_BUG_ON(!is_power_of_2(8))
Message-ID: <20150814090044.GB21759@unicorn.suse.cz> (sfid-20150814_110139_550951_CECD78CD)
References: <1439457109-21833-1-git-send-email-johannes@sipsolutions.net>
 <1439540944.2091.10.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439540944.2091.10.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2015 at 10:29:04AM +0200, Johannes Berg wrote:
> +linux-kernel
> 
> > +#define DECLARE_EWMA(name, _factor, _weight)> 	> 	> 	> 	> \
> > +> 	> struct ewma_##name {> 	> 	> 	> 	> 	> 	> \
> > +> 	> 	> unsigned long internal;> 	> 	> 	> 	> 	> \
> > +> 	> };> 	> 	> 	> 	> 	> 	> 	> 	> \
> > +> 	> static inline void ewma_##name##_init(struct ewma_##name *e)> 	> \
> > +> 	> {> 	> 	> 	> 	> 	> 	> 	> 	> \
> > +> 	> 	> BUILD_BUG_ON(!__builtin_constant_p(_factor));> 	> 	> \
> > +> 	> 	> BUILD_BUG_ON(!__builtin_constant_p(_weight));> 	> 	> \
> > +> 	> 	> BUILD_BUG_ON(!is_power_of_2(_factor));> 	> 	> 	> \
> > +> 	> 	> BUILD_BUG_ON(!is_power_of_2(_weight));> 	> 	> 	> \
> > 
> 
> So this seemed fine to me, but for some reason the compiler is saying
> the BUILD_BUG_ON(!is_power_of_2(x)) fails, if and only if (!)
> CONFIG_GCOV_PROFILE_ALL is enabled, which seems to boil down to the
> compiler option -fprofile-arcs.
> 
> I'm going to replace this with just the code itself, i.e.
> 
>                 /* both must be a power of 2 */
>                 BUILD_BUG_ON(_factor & (_factor - 1));
>                 BUILD_BUG_ON(_weight & (_weight - 1));
> 
> but should I have expected this?

It might have something to do with the fact that is_power_of_2() being
an inline function, perhaps with this compiler option it translates to
something that can't be used in the context BUILD_BUG_ON() uses it in.

There is a BUILD_BUG_ON_NOT_POWER_OF_2() macro you could use.

                                                        Michal Kubecek
