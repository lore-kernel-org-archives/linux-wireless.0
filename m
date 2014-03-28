Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaC1Nty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:49:54 -0400
Message-ID: <1396014590.4175.30.camel@jlt4.sipsolutions.net> (sfid-20140328_144959_042289_C21DE542)
Subject: Re: [PATCH v2 01/13] cfg80211: allow drivers to iterate over
 matching combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 28 Mar 2014 14:49:50 +0100
In-Reply-To: <CA+BoTQngPM4RvG6OxrLrzoVj1vu6+jwvZr5BaWhdxy0NPWrOxA@mail.gmail.com> (sfid-20140328_144248_645561_E575B041)
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-2-git-send-email-michal.kazior@tieto.com>
	 <1396011945.4175.23.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnpijm3JxXNaCzSf3bDx6OiPDAhseTj7=0Urv4jWav=Wg@mail.gmail.com>
	 <1396012968.4175.28.camel@jlt4.sipsolutions.net>
	 <CA+BoTQngPM4RvG6OxrLrzoVj1vu6+jwvZr5BaWhdxy0NPWrOxA@mail.gmail.com>
	 (sfid-20140328_144248_645561_E575B041)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-28 at 14:42 +0100, Michal Kazior wrote:
> On 28 March 2014 14:22, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2014-03-28 at 14:21 +0100, Michal Kazior wrote:
> >
> >> >> +int cfg80211_iter_combinations(struct wiphy *wiphy,
> >> >> +                            const int num_different_channels,
> >> >> +                            const u8 radar_detect,
> >> >> +                            const int iftype_num[NUM_NL80211_IFTYPES],
> >> >> +                            void (*iter)(const struct ieee80211_iface_combination *c,
> >> >> +                                         void *data),
> >> >> +                            void *data);
> >> >
> >> > Maybe *iter should have a non-void return value and allow aborting the
> >> > loop somehow?
> >>
> >> I don't see much of use for that. You can still use *data for that.
> >
> > No, I meant to abort the iteration loop, say when the function returns
> > true (or false, whichever way you want to look at it). That way you can
> > stop iteration at the first combination that's sufficient.
> 
> I know. It's just that it bothers me - if you use true/false you end
> up with "do I use true for continue or break" (and need to put
> comments in the code) and having an enum for such a trivial thing
> seems silly too. On the other hand using *data to guard *iter is also
> silly.

Ok, let's leave it. It's not like we have a million combinations and
iterating them is expensive ...

johannes

