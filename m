Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35837 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaFKFVB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 01:21:01 -0400
Received: by mail-pa0-f45.google.com with SMTP id hz1so1495591pad.4
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 22:21:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UMDM3rSq1FLjO5yammhjX=6NgvntQvt9NGijOHBxq+wg@mail.gmail.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
 <CAB=NE6W+BjyH3Ywb2Goigu6-=omtTQuLsmnXx+Mwz5Dc6bk_Uw@mail.gmail.com> <CAB=NE6UMDM3rSq1FLjO5yammhjX=6NgvntQvt9NGijOHBxq+wg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 11 Jun 2014 08:20:45 +0300
Message-ID: <CA+XVXfebutZMPhPZKqOjwg-_h4it4C4AQRAO0brSOZs6Sghxyg@mail.gmail.com> (sfid-20140611_072105_543334_44796F2D)
Subject: Re: [PATCH 0/7] regulatory enhancements
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 12:44 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
>
> On Tue, May 20, 2014 at 1:48 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > On Sun, May 11, 2014 at 1:50 AM, Emmanuel Grumbach
> > <emmanuel.grumbach@intel.com> wrote:
> >> Hi Johannes,
> >>
> >> Newer Intel cards store regulatory settings in firmware.
> >> This patch series adds support for a wiphy callback, allowing
> >> the regulatory core to fetch driver/firmware defined redgomain
> >> data whenever a country code change is requested.
> >>
> >> Along with that, there is also a small fix from Eliad.
> >>
> >> Arik Nemtsov (6):
> >>   cfg80211: don't set reg timeout for user-handled hint
> >>   cfg80211: introduce regulatory flags controlling bw
> >>   cfg80211: allow drivers to provide regulatory settings
> >>   cfg80211: treat the special "unknown" alpha2 as valid
> >>   cfg80211: accept world/same regdom from driver/user hints
> >>   cfg80211: leave invalid channels on regdomain change
> >
> > Please Cc me on regulatory patches. I've noted issues with the wiphy
> > callback addition, but other than place if you can please resend
> > patches that do not depend on that, that'd be appreciated, I'll take a
> > look at those in the morning.
>
> I haven't seen these patches, please split them up, I think a few
> already were accepted, but separating them between the new
> functionality being added is key to speedy review. I'll take a second
> stab at review of the fw API now as I'm going comfortalbe with the
> idea of letting folks shoot themselves on the foot.

This one is in, it's an obvious fix:
4d3df54 cfg80211: don't set reg timeout for user-handled hint

The others are patches supporting the new Intel regulatory solution,
so none of them are in. I'll make sure to resend them today.

Arik
