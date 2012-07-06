Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43701 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2GFHld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 03:41:33 -0400
Received: by yenl2 with SMTP id l2so8291900yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 00:41:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341560078.4462.11.camel@jlt3.sipsolutions.net>
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
 <1341417530-9062-3-git-send-email-arik@wizery.com> <1341473996.4455.2.camel@jlt3.sipsolutions.net>
 <CA+XVXfdwGAdxdmZTx+4pC4=6agM0SuvHV_xsF0gGCE_5NMB7YA@mail.gmail.com>
 <1341557988.4462.6.camel@jlt3.sipsolutions.net> <CA+XVXff3_ugusQ=HPVeg3YSp3OBjWwpCVHTxd+Tnxg5Rf_5W3w@mail.gmail.com>
 <1341560078.4462.11.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 6 Jul 2012 10:41:16 +0300
Message-ID: <CA+XVXfcRWY+DT8RVfMdC8gzfKY+_2W5msp65ba0xaAZLYA09Fw@mail.gmail.com> (sfid-20120706_094137_178841_596833EE)
Subject: Re: [RFC 2/4] cfg80211: support unused HT-cap-per-band configuration
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 6, 2012 at 10:34 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-07-06 at 10:30 +0300, Arik Nemtsov wrote:
>
>> >> Also putting ht_cap_invalid inside the struct creates strange corner
>> >> cases. One could mark the vif ht_cap as invalid as well, but the code
>> >> would just ignore it.
>> >
>> > Good point. But then let's just move it out and change drivers ...
>> > that's much cleaner I think.
>>
>> You mean move out ht_supported?
>
> Yeah, I think that'd make more sense? Have it in the sband directly.

It does make more sense. But I was thinking there might be code
setting this dynamically in some drivers, so the changes would be
non-trivial. The union was sort of a compromise.

Maybe move it out for vht_cap for now? :)

>
>
>> >> >> @@ -30,13 +31,16 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
>> >> >>                chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
>> >> >>               return NULL;
>> >> >>
>> >> >> -     ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
>> >> >> +     sband = rdev->wiphy.bands[chan->band];
>> >> >> +     ht_cap = &sband->ht_cap;
>> >> >>
>> >> >>       if (channel_type != NL80211_CHAN_NO_HT) {
>> >> >> -             if (!ht_cap->ht_supported)
>> >> >> +             if (!sband->ht_supported)
>> >> >>                       return NULL;
>> >> >>
>> >> >> -             if (channel_type != NL80211_CHAN_HT20 &&
>> >> >> +             /* this check is ignored when per-band HT caps are not used */
>> >> >> +             if (!sband->ht_cap_invalid &&
>> >> >> +                 channel_type != NL80211_CHAN_HT20 &&
>> >> >
>> >> > This is also major confusion, it seems you should roll 2/3 into one
>> >> > patch?
>> >>
>> >> I'm not sure that would help. rdev_freq_to_chan doesn't get the
>> >> net_device, so it can't get the HT caps. I guess I can add the
>> >> net_device as an optional argument where it is used and check the
>> >> caps. OTOH it seem like a sanity check we can do without?
>> >
>> > I don't think we should do without that check? If you request say AP
>> > operation on 40 MHz then you absolutely rely on that happening or
>> > returning an error, not randomly operating in legacy mode!
>>
>> Sure. I'll send the netdev to the function where possible (I think
>> everywhere except the virtual monitor).
>
> I think the function should restrict to NO_HT in case it doesn't have
> caps, otherwise it can't properly restrict. I suppose that means you
> won't be able to do HT monitoring with your device, but I can live with
> that.

Actually the ht_supported flag is still global, so HT monitoring is
possible, just not HT40 monitoring I think. We'll fix that if the need
arises (or just boot the driver with fixed caps via a module param).
