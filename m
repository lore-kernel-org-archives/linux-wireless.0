Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:44365 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaHMLjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 07:39:05 -0400
Received: by mail-ig0-f176.google.com with SMTP id hn18so9827010igb.9
        for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2014 04:39:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407928809.21220.33.camel@jlt4.sipsolutions.net>
References: <1407870219-1720-1-git-send-email-johannes@sipsolutions.net>
	<CAB3XZEckyoDVShskF8rRe7DFuVMO-LBdhFDejiJ63SjhsEvmAA@mail.gmail.com>
	<1407928122.21220.31.camel@jlt4.sipsolutions.net>
	<CAB3XZEdOC1ERUm1HDK03qWQti35Z66EHL+0gD9=oBpcPfK2r4w@mail.gmail.com>
	<1407928809.21220.33.camel@jlt4.sipsolutions.net>
Date: Wed, 13 Aug 2014 14:39:04 +0300
Message-ID: <CAB3XZEd0h_aPQSHr900+VWxdRw014QUP01-qj5rjsKsd+dhBsQ@mail.gmail.com> (sfid-20140813_133921_781369_99443EAA)
Subject: Re: [PATCH 1/2] cfg80211: clarify BSS probe response vs. beacon data
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@adurom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 13, 2014 at 2:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-08-13 at 14:13 +0300, Eliad Peller wrote:
>> On Wed, Aug 13, 2014 at 2:08 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Wed, 2014-08-13 at 13:57 +0300, Eliad Peller wrote:
>> >
>> >
>> >> > @@ -1011,6 +1018,9 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
>> >> >         if (res->pub.capability & WLAN_CAPABILITY_ESS)
>> >> >                 regulatory_hint_found_beacon(wiphy, channel, gfp);
>> >> >
>> >> > +       /* assume drivers don't mix and match too badly */
>> >> > +       res->known_frame_type = true;
>> >> > +
>> >>
>> >> i think you should set the flag only in case of a beacon.
>> >> otherwise, you might "validate" res->ies although it contains probe
>> >> response data.
>> >
>> > Hm, what do you mean? If we have known frametype and we have beacon_ies,
>> > then IEs in nl80211 are certain to be proberesp_ies ...
>> >
>> sorry, i meant res->beacon_ies.
>>
>> consider the following flow:
>> cfg80211_inform_bss_width(presp1):
>>  * beacon_ies = presp1
>>  * known_frame_type = false
>>
>> cfg80211_inform_bss_width_frame(presp2):
>>  * proberesp_ies = presp2
>>  * beacon_ies = presp1
>>  * known_frame_type = true
>
> Yeah, well, I'm hoping that drivers wouldn't be so stupid? :)
>
well, they just use the api... :)

> Maybe we should just get rid of the requirement to assign beacon_ies
> with the bss_width() call and make free() smarter?

this will also require changing cfg80211_bss_update() to take care of
this case, etc.
not sure we really want to complicate it further more.

Eliad.
