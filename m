Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63417 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab1GQRgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 13:36:41 -0400
Received: by wwe5 with SMTP id 5so2570408wwe.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 10:36:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310763624.4164.29.camel@jlt3.sipsolutions.net>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	<1310600747-9583-2-git-send-email-thomas@cozybit.com>
	<1310723669.4164.18.camel@jlt3.sipsolutions.net>
	<CAG6hwVONFH+vkSasF7AaSaqvHK78wwNtZesi0RSUnuCi17d9Fw@mail.gmail.com>
	<1310763624.4164.29.camel@jlt3.sipsolutions.net>
Date: Sun, 17 Jul 2011 12:36:40 -0500
Message-ID: <CAG6hwVOVJGBF87jqY-K4xnjDWcVD-RTYXfV-N9=T-5Ty1U2TdQ@mail.gmail.com> (sfid-20110717_193645_338763_4D070BBF)
Subject: Re: [PATCH 1/5] mac80211: give if_mesh a beacon
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 2:00 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2011-07-15 at 12:30 -0700, Thomas Pedersen wrote:
>
>> >> +     if (ieee80211_vif_is_mesh(&sdata->vif))
>> >> +             rcu_assign_pointer(sdata->u.mesh.beacon, new);
>
>> The ifdef is already in ieee80211_vif_is_mesh()
>
> Yeah but sdata->u.mesh doesn't exist without mesh configured.
>
>> > what's + 400? You can't really think the TIM IE is that long?
>>
>> No, but you're right, that number is pretty arbitrary. Maximum length
>> of mesh IEs currently (Mesh ID + Mesh Conf + Mesh Awake) is only 47.
>> Since mesh IEs have to be added during beacon time, might it make
>> sense to track the needed length in the if_mesh?
>
> Maybe just add a comment what's included in the 400?
>
>> > Also ... since you'll need PS support eventually anyway, maybe you
>> > should refactor "struct ieee80211_if_ap" into something AP-specific
>> > (currently only VLANs) and the rest, and then use "the rest" in mesh as
>> > well to make all this code more unified.
>>
>> I like this approach much better. Are you suggesting just factoring
>> out the PS data, or taking it further and creating a generic "if which
>> beacons"?
>
> Well, I don't think "iface which beacons" is really what we need here --
> IBSS sends beacons as well but we don't really have PS support there and
> it'd be different anyway. But on the other hand, if you also factor out
> the beacon pointer, you can embed that into both. Like I said, I think
> from struct ..._if_ap you only have the vlan list that you don't want?

I'd rather just factor all the PS data out for now, and maintain the
beacon separately. Is there Is there any good reason we'd want to lump
these two together? ieee80211_beacon_add_tim() for example already
treats these as separate.

>
> johannes
>
>
