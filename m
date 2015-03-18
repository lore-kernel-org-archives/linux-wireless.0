Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33735 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbbCRTWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 15:22:54 -0400
Message-ID: <1426706561.3001.25.camel@sipsolutions.net> (sfid-20150318_202257_673790_A47FFEF8)
Subject: Re: [PATCH] mac80211: stop scan before connection
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Spinadel <david.spinadel@intel.com>
Date: Wed, 18 Mar 2015 20:22:41 +0100
In-Reply-To: <CAB3XZEdJTjRS9tek_KnR9t_HT5+AHjvcjKuBavY2KSrHj9jLkw@mail.gmail.com> (sfid-20150318_111123_601058_E60EC6E5)
References: <1426615118-17516-1-git-send-email-emmanuel.grumbach@intel.com>
	 <CAB3XZEd7cQwKm_yLztzeTB0S_-uEp4FwzDUV1O8cG6mNtkiY_A@mail.gmail.com>
	 <1426671981.3001.12.camel@sipsolutions.net>
	 <CAB3XZEdJTjRS9tek_KnR9t_HT5+AHjvcjKuBavY2KSrHj9jLkw@mail.gmail.com>
	 (sfid-20150318_111123_601058_E60EC6E5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-18 at 12:11 +0200, Eliad Peller wrote:

> i'm not sure. the AP will probably have some retransmissions, 

It hopefully will, but they'll be real retransmissions (with retry bit),
usually occurring within a very short period of time.

> so the
> station should have good chances to get the frames (assuming the
> hardware will give this interface some airtime during the scan).

So the normal dwell time during even an active scan (say 30ms) will mean
that all of those retries will not be heard once you miss the first one.

> > So in a sense you could say deferring the handling doesn't make sense,
> > but I'd still argue you shouldn't start this process while you're in the
> > middle of scanning, hence this patch.
> >
> i agree the patch makes sense anyway, i just noted that mac80211
> behavior seems wrong.
> you should avoid scanning while connecting in first place, not defer
> the handling.

Yeah, agree.

> btw, note that both this patch and ieee80211_iface_work() don't count
> for the sched scan case, which is basically the same.

True, except we can't really cover that case since we don't even know
when we're really scanning while sched scan is enabled.

I'd expect drivers to either abort the scheduled scan in that case, or
protected the authentication/association in some way (like iwlwifi does,
for example, by giving a few hundred ms of guaranteed channel time in
the mgd_prepare_tx method)

> > We may have to do more exclusions (e.g. don't start a scan while
> > authenticating or associating) here though, and ultimately not
> > *processing* the frames will be irrelevant as they shouldn't be coming
> > in anyway.
> that's true for auth/assoc frames. but some other frames (e.g. deauth)
> can come anytime, and i don't see why we should defer processing in
> this case.

Yeah, true. This seems like something we should take a closer look at,
think about the design more and document the expectations better.

Still, I think this patch is one step along that way.

johannes

