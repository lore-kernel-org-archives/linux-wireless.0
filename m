Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36094 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760961AbcDFJCa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:02:30 -0400
Message-ID: <1459933346.17504.50.camel@sipsolutions.net> (sfid-20160406_110235_473133_999C70C5)
Subject: Re: [PATCHv3 RESEND 07/11] cfg80211: add utility functions to clone
 and free nan_func
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 11:02:26 +0200
In-Reply-To: <1459244109-16038-7-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1459244109-16038-7-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +int cfg80211_clone_nan_func_members(struct cfg80211_nan_func *f1,
> +				    const struct cfg80211_nan_func *f2)
> +{
> +	memcpy(f1, f2, sizeof(*f1));

That's pretty weird. And the only user of this (in a later patch) is
first allocating the f1. I think this function should be changed to
also allocate the entire struct cfg80211_nan_func, with all the
contents.

Yes, mac80211 is actually allocating a bit more - but only a list_head.
I think I'd prefer just putting a "struct list_head list" into the
cfg80211 struct "for driver use" and getting rid of all of these
contortions.


With some care, I'm pretty sure you could even get away with a single
allocation that's big enough to cover everything, so that you don't
need to have cfg80211_free_nan_func_members() exported but can simply
kfree() the pointer returned from this function.

That's basically doing 

size = sizeof(*dst);
size += src->serv_spec_info_len;
size += src->srf_bf_len;
size += src->srf_num_macs * size(...);
size += <rx filters calculation>
size += <tx filters calculation>

and then using pointers to the single block.

The only problem might be if that can get really large, but I think it
would make memory management simpler.

In fact, it'd be *really* nice if that could also be done when parsing
this from nl80211.


Additionally, and alternatively to exporting this function from
cfg80211, why don't you change the rules around the memory?
If nl80211_nan_add_func() doesn't put the func on the stack, but
allocates it, then rdev_add_nan_func() can be forced to take ownership
of the pointer. That way, there's no need to even copy the data at all.
Yes, that'd have to be documented (particularly whether or not it also
takes ownership in error cases, it probably should), but overall I'm
pretty sure it'd simplify things.

Even if we *don't* get away with putting everything into a single
allocation in nl80211 - that might be too complicated - we'd only have
to export the free function and would never copy around things.

johannes
