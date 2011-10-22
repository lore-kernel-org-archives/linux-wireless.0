Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab1JVRjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 13:39:51 -0400
Subject: Re: [PATCH 1/4] nl80211: Add probe response offload attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAA038468Y7T4BSAycqmNc0q+Ph1wSh07B57tV--O00kvDEp-wg@mail.gmail.com> (sfid-20111022_192728_088869_C7443530)
References: <1319289112-21896-1-git-send-email-guy@wizery.com>
	 <1319290457.3956.3.camel@jlt3.sipsolutions.net>
	 <1319290618.3956.6.camel@jlt3.sipsolutions.net>
	 <CAA038468Y7T4BSAycqmNc0q+Ph1wSh07B57tV--O00kvDEp-wg@mail.gmail.com>
	 (sfid-20111022_192728_088869_C7443530)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Oct 2011 19:39:46 +0200
Message-ID: <1319305186.3956.11.camel@jlt3.sipsolutions.net> (sfid-20111022_193954_840410_3142181D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-22 at 19:26 +0200, Guy Eilam wrote:

> >> > +enum nl80211_probe_resp_offload_support_attr {
> >> > +   NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS,
> >> > +   NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2,
> >> > +   NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P,
> >> > +};
> >>
> >> I think doing = 1<<N here would be nicer to use in drivers & userspace.
> >
> > Hm, also: should we call this WPS or WSC, and do we need to distinguish
> > WPS and WPS2? My AP mode patch called it WSC in a different context but
> > I can change, we just should be consistent.
> >
> >> > + * @get_probe_resp_offload: Get probe response offload support from driver.
> >>
> >> and this seems unnecessary -- why not just put a u32 value into struct
> >> wiphy?
> >
> > Oh, and probably a regular WIPHY flag that indicates whether the
> > attribute should be added at all so that it can also be 0 but present
> > (presence with 0 value indicates something other than not present).
> 
> When this is not supported a -EOPNOTSUPP should be returned.
> A 0 return means that it is supported.

Yeah but if you add a wiphy flag and the bits into struct wiphy, then
you can save the function pointer which seems nicer?

johannes

