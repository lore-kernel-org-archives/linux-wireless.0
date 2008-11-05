Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:19155 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYKEQ50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 11:57:26 -0500
Received: by yw-out-2324.google.com with SMTP id 9so53297ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 08:57:24 -0800 (PST)
Message-ID: <43e72e890811050857p7a6e371dq96880853dc310741@mail.gmail.com> (sfid-20081105_175729_019362_7EEB63B2)
Date: Wed, 5 Nov 2008 08:57:23 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 7/7] cfg80211/mac80211: Add Country IE parsing/802.11d support
Cc: linville@tuxdriver.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <1225887783.3619.108.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-8-git-send-email-lrodriguez@atheros.com>
	 <1225887783.3619.108.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2008 at 4:23 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2008-11-04 at 18:50 -0800, Luis R. Rodriguez wrote:
>
>
>>
>> +/*
>> + * IEEE 802.11-2007 7.3.2.9 Country information element
>> + *
>> + * Minimum length is 8 octects, ie len must be evenly
>> + * divisible by 2
>> + */
>
> That seems odd, I thought there are triplets in there? That mean it
> should be 2+N*3, no?

Forgot the environment 'I', 'O' or ' '.

alpha+environment (3) + n * 3

>> +/*
>> + * Regulatory extension stuff is for 802.11j, ammeneded to
>> + * IEEE 802.11-2007, see Annex I (page 1141) and Annex J
>> + * (page 1147). Also review 7.3.2.9.
>
> I think you should drop the 802.11j mention, it's just confusing when
> that document no longer exists and you also mention annex J.

Sure.

>> + */
>> +#define IEEE80211_COUNTRY_EXTENSION_ID 201
>
> Should that be something like EXTENSION_ID_OFFSET? Clearly they must
> mean to subtract this?

Sure but just to determine if it is a new one as they seem to come in
increasing.



>>  struct wiphy {
>> @@ -201,6 +208,8 @@ struct wiphy {
>>
>>       struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
>>
>> +     char country_ie_alpha2[2];
>
> Is that needed in the external interface? It seems it should be part of
> cfg80211_registered_device?

That seems like a better home for it.

>> +
>> +/**
>> + * regulatory_hint_ie - wireless stack hints a regulatory domain
>> + * @wiphy: the wireless device giving the hint (used only for reporting
>> + *   conflicts)
>> + * @rd: a regulatory domain built from the received country IE
>> + * @country_ie_checksum: checksum of country IE of fields we are interested in,
>> + *   we can remove this if its determined the IE never should change
>> + *   for an AP, keep in mind dot11RegulatoryClassesRequired.
>> + *
>> + * We will intersect the rd with the what CRDA tells us should apply
>> + * for the alpha2 this country IE belongs to, this prevents APs from
>> + * sending us incorrect or outdated information against a country.
>> + * If CONFIG_WIRELESS_OLD_REGULATORY is enabled and CRDA is not present
>> + * we will intersect immediately against what is currently set in the
>> + * wireless core.
>> + */
>> +extern int regulatory_hint_ie(struct wiphy *wiphy,
>> +     struct ieee80211_regdomain *rd,
>> +     u32 country_ie_checksum);
>
> Ok this I don't understand. Why the checksum thing? Why pass the
> regdomain struct in? Can't cfg80211 do the work of parsing the IE and
> you just parse the IE in, possibly "debouncing" when it hasn't changed
> (or do the debouncing in cfg80211 too, for the overhead of an extra
> function call)

It seems wrong to offload onto cfg80211 some IE parsing work even if
its related to regulatory. Are you sure you want that?

So we want two things:

1. A very quick and efficient way to determine if we can ignore the IE
processing in case the IE has already been processed
2.  A quick way to determine if a new device can ignore IE processing

The alpha2 on the registered interface solves the first
The checksum solves the second

If we leave the checksumming outside we need the helpers to check the
checksum exported. Otherwise then definitely we can stuff it into
cfg80211 but that means for a second device you'll pass the IE pointer
and len as part of the regulatory_hint_ie() and it *can* fail for
several reasons (-EALREADY, -EINVAL, -ENOMEM).

Come to think of it maybe we can remove the checksum completely if we
just check the BSSID the STA is associated to. That is a second device
can assume the IE will be the same if the alpha2 matches *and* the
BSSID is the same as the one who found it. This of course assumes the
IE will not change if the alpha2 remains the same which I think is
reasonable unless the AP's 11d settings are reconfigured and it
doesn't let off STAs after doing it.

Another thing we should consider here is the case of an Indoor AP and
an Outdoor AP. According to Felix this is very possible and he's dealt
with it. I doubt 11d is being used in those cases but regardless it
seems we should account for it and deal with it. In that case it seems
two different registered devices can be using one country but
different environments. I have kept this in mind but admit not
thoroughly. I think its good to see now what changes we'll need. Maybe
we can deal with this later on though.

> No, you should never enable an option that might print messages if
> somebody sends you frames, even beacons can trivially be faked. This may
> lull people into a false sense of security ("who'd change the regulatory
> settings??")

Fine by me. Also I think its easier to just add a damn debugfs counter
for beacons if we don't have one (I think we don't) and maybe a a 3
octect string which indicates the alph2 and the environment. If
nothing IE is set in the IE we can leave it empty.


>>       case REGDOM_SET_BY_USER:
>>               if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
>>                       return REG_INTERSECT;
>> +             /* If the user knows better the user should set the regdom
>> +              * to their country before the IE is picked up */
>> +             if (last_request->initiator == REGDOM_SET_BY_USER &&
>> +                             last_request->intersect)
>> +                     return -EOPNOTSUPP;
>
> Can you use a more customary indentation of the second if line to just
> after the parenthesis?

Like what

if (foo ||
<TAB><SPACE><SPACE>bar)
<TAB><TAB>bar;

?

> When I suggested to use a checksum I was thinking of an easy way to
> debounce. But a checksum is never perfect. Hence, the WARN_ON you added
> might trigger despite the debounce checksum. Or we might fail to follow
> changes.

Let me know what you think about the alpha2 + BSSID thing above. I
guess it should also consider the environment (I, O, ' ') in case the
AP is reconfigured to be outdoor (without being moved). I don't think
we should care about supporting these cases on the fly but we should
ensure the change won't break things.

> Maybe we should just keep a copy of the IE.

Ehh.

> When you change the
> code to be parsing in cfg80211, please keep in mind that all this
> doesn't need to be part of the wiphy struct, public API users don't need
> it.

Sure.

>>       kfree(last_request);
>> -     last_request = request;
>> -     r = call_crda(alpha2);
>>
>> -#ifndef CONFIG_WIRELESS_OLD_REGULATORY
>> -     if (r)
>> -             printk(KERN_ERR "cfg80211: Failed calling CRDA\n");
>> -#endif
>> +     last_request = request;
>> +     call_crda(alpha2);
>> +
>> +     /* Note: When CONFIG_WIRELESS_OLD_REGULATORY is enabled
>> +      * AND if CRDA is NOT present nothing will happen, if someone
>> +      * wants to bother with 11d with OLD_REG you can add a timer.
>> +      * If after x amount of time nothing happens you can call:
>> +      *
>> +      * return set_regdom(country_ie_regdomain);
>> +      *
>> +      * to intersect with the static rd
>> +      */
>
> Ah, I see. I suppose it'll still work as before so that's fine.

Heh yeah.. I should have read kobject_uevent_env() more carefully, it
only fails if it cannot build the uevent thing, it never returns what
the uvent result is from userspace, which makes sense. I should send
this as a separate patch too to clarify this.

  Luis
