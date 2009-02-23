Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:25518 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbZBWTLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 14:11:12 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2632046wfa.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 11:11:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87prh9ht22.fsf@litku.valot.fi>
References: <20090223163626.20939.4879.stgit@tikku>
	 <20090223163738.20939.25890.stgit@tikku>
	 <43e72e890902230947x6e55bf36ve715295f43f74fbb@mail.gmail.com>
	 <87prh9ht22.fsf@litku.valot.fi>
Date: Mon, 23 Feb 2009 11:11:10 -0800
Message-ID: <43e72e890902231111g3705c5bh445e3317de5967f3@mail.gmail.com> (sfid-20090223_201118_287393_1FE3ECC6)
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 11:06 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
>
>> On Mon, Feb 23, 2009 at 8:37 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
>>> --- a/include/net/mac80211.h
>>> +++ b/include/net/mac80211.h
>>> @@ -903,6 +903,7 @@ enum ieee80211_hw_flags {
>>>        IEEE80211_HW_PS_NULLFUNC_STACK                  = 1<<11,
>>>        IEEE80211_HW_SUPPORTS_DYNAMIC_PS                = 1<<12,
>>>        IEEE80211_HW_MFP_CAPABLE                        = 1<<13,
>>> +       IEEE80211_HW_BEACON_FILTERING                   = 1<<14,
>>
>> Not sure this conveys what it means, how about BEACON_MISS ?
>
> To me the name "beacon filtering" sounds better. The idea of the
> feature is to avoid sending beacons to the host, that is "filter
> beacons" in firmware. Beacon miss is an action of that feature. Am I
> making any sense? :)

Nah you're right, I was thinking our own "action" heh.

> Also my assumption here is that ieee80211_beacon_loss() should be
> called only after certain number of consecutive beacon misses. While
> testing these patches on stlc45xx I used number 10. Can ath9k handle
> anything like this? Or will it just report each beacon miss
> individually?

Will have to check, I haven't read how this works in detail yet.

>>> +void ieee80211_beacon_loss(struct ieee80211_hw *hw);
>>>
>>>  /* Rate control API */
>>>
>>
>> Some kdoc would be nice for this.
>
> Definitely. It's on my TODO list.
>
>> Also I suspect you designed this with 2 GHz legacy (802.11bg) single
>> band cards in mind.
>
> Good guess :) Yes, I haven't thought about 5 GHz band.
>
>> For the case or cards capable of 5 GHz or of HT I believe we should
>> consider the cases of dealing with DFS or HT channel switch both of
>> which can occur dynamically while the STAs are associated. If
>> hardware is capable of differentiating this (through beacon
>> checksums) then that's an enhancement but for now I suspect that is
>> not the case for most hardware that implements this and as such for
>> the case when on DFS or using HT we can simply have mac80211 disable
>> this. Not sure... Thoughts?
>
> I don't see a problem. Like you said, such hardware should have beacon
> checksumming support. Whenever the checksum has changed, the hardware
> should pass the beacon to the host and mac80211 would receive the
> beacon just like without beacon filtering.

_should_ -- but I don't think this is yet implemented.

> Beacon filtering can be thought like filtering unrelevant beacons, but
> passing through the beacons which have new information. For example,
> stlc45xx already has beacon checksum support even though it doesn't
> support 5 GHz band. Unfortunately I haven't managed to find the time
> to test it yet.

As IEEE-802.11 advances how does the hardware know which IEs to
checksum or not for? :)

> If there is hardware using 5 GHz band and does not support beacon
> checksumming, then the driver should not even enable beacon filtering.

Heh.. umm, I'd like us to add this as a feature eventually too to be
able to save power but I think we do not checksum and hence my
comments.

  Luis
