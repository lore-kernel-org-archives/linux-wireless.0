Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39184 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaHMLUN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 07:20:13 -0400
Message-ID: <1407928809.21220.33.camel@jlt4.sipsolutions.net> (sfid-20140813_132018_748303_7579F559)
Subject: Re: [PATCH 1/2] cfg80211: clarify BSS probe response vs. beacon data
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@adurom.com>
Date: Wed, 13 Aug 2014 13:20:09 +0200
In-Reply-To: <CAB3XZEdOC1ERUm1HDK03qWQti35Z66EHL+0gD9=oBpcPfK2r4w@mail.gmail.com> (sfid-20140813_131330_615891_557AC86F)
References: <1407870219-1720-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEckyoDVShskF8rRe7DFuVMO-LBdhFDejiJ63SjhsEvmAA@mail.gmail.com>
	 <1407928122.21220.31.camel@jlt4.sipsolutions.net>
	 <CAB3XZEdOC1ERUm1HDK03qWQti35Z66EHL+0gD9=oBpcPfK2r4w@mail.gmail.com>
	 (sfid-20140813_131330_615891_557AC86F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-08-13 at 14:13 +0300, Eliad Peller wrote:
> On Wed, Aug 13, 2014 at 2:08 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-08-13 at 13:57 +0300, Eliad Peller wrote:
> >
> >
> >> > @@ -1011,6 +1018,9 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
> >> >         if (res->pub.capability & WLAN_CAPABILITY_ESS)
> >> >                 regulatory_hint_found_beacon(wiphy, channel, gfp);
> >> >
> >> > +       /* assume drivers don't mix and match too badly */
> >> > +       res->known_frame_type = true;
> >> > +
> >>
> >> i think you should set the flag only in case of a beacon.
> >> otherwise, you might "validate" res->ies although it contains probe
> >> response data.
> >
> > Hm, what do you mean? If we have known frametype and we have beacon_ies,
> > then IEs in nl80211 are certain to be proberesp_ies ...
> >
> sorry, i meant res->beacon_ies.
> 
> consider the following flow:
> cfg80211_inform_bss_width(presp1):
>  * beacon_ies = presp1
>  * known_frame_type = false
> 
> cfg80211_inform_bss_width_frame(presp2):
>  * proberesp_ies = presp2
>  * beacon_ies = presp1
>  * known_frame_type = true

Yeah, well, I'm hoping that drivers wouldn't be so stupid? :)

Maybe we should just get rid of the requirement to assign beacon_ies
with the bss_width() call and make free() smarter?

johannes

