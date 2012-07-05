Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64072 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2GELZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 07:25:45 -0400
Received: by yenl2 with SMTP id l2so7223874yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 04:25:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341473996.4455.2.camel@jlt3.sipsolutions.net>
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
 <1341417530-9062-3-git-send-email-arik@wizery.com> <1341473996.4455.2.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 5 Jul 2012 14:25:29 +0300
Message-ID: <CA+XVXfdwGAdxdmZTx+4pC4=6agM0SuvHV_xsF0gGCE_5NMB7YA@mail.gmail.com> (sfid-20120705_132559_995930_64269470)
Subject: Re: [RFC 2/4] cfg80211: support unused HT-cap-per-band configuration
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 5, 2012 at 10:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-07-04 at 18:58 +0300, Arik Nemtsov wrote:
>
>>  struct ieee80211_sta_ht_cap {
>> +     bool ht_supported; /* this must be first */
>>       u16 cap; /* use IEEE80211_HT_CAP_ */
>> -     bool ht_supported;
>
>
>> -     struct ieee80211_sta_ht_cap ht_cap;
>> +     union {
>> +             struct ieee80211_sta_ht_cap ht_cap;
>> +             bool ht_supported;
>> +     };
>> +     bool ht_cap_invalid;
>
>
> Yuck. Why use the union at all? You could just put the ht_cap_invalid
> into the ht_cap struct, and it wouldn't even take space, there's
> padding :-)

The point is - we still want to use ht_cap.ht_supported, even when
ht_cap is invalid. I was afraid there would be some confusion, hence
one can set:
band.ht_supported = true;
band.ht_cap_invalid = false;

And the union means we don't have to change old drivers.

Also putting ht_cap_invalid inside the struct creates strange corner
cases. One could mark the vif ht_cap as invalid as well, but the code
would just ignore it.

>
>
>> @@ -30,13 +31,16 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
>>                chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
>>               return NULL;
>>
>> -     ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
>> +     sband = rdev->wiphy.bands[chan->band];
>> +     ht_cap = &sband->ht_cap;
>>
>>       if (channel_type != NL80211_CHAN_NO_HT) {
>> -             if (!ht_cap->ht_supported)
>> +             if (!sband->ht_supported)
>>                       return NULL;
>>
>> -             if (channel_type != NL80211_CHAN_HT20 &&
>> +             /* this check is ignored when per-band HT caps are not used */
>> +             if (!sband->ht_cap_invalid &&
>> +                 channel_type != NL80211_CHAN_HT20 &&
>
> This is also major confusion, it seems you should roll 2/3 into one
> patch?

I'm not sure that would help. rdev_freq_to_chan doesn't get the
net_device, so it can't get the HT caps. I guess I can add the
net_device as an optional argument where it is used and check the
caps. OTOH it seem like a sanity check we can do without?

Arik
