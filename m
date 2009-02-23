Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:36650 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbZBWT6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 14:58:14 -0500
Received: by rv-out-0506.google.com with SMTP id g37so2079333rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 11:58:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87bpst7xxd.fsf@litku.valot.fi>
References: <20090223163626.20939.4879.stgit@tikku>
	 <20090223163738.20939.25890.stgit@tikku>
	 <43e72e890902230947x6e55bf36ve715295f43f74fbb@mail.gmail.com>
	 <87prh9ht22.fsf@litku.valot.fi>
	 <43e72e890902231111g3705c5bh445e3317de5967f3@mail.gmail.com>
	 <87bpst7xxd.fsf@litku.valot.fi>
Date: Mon, 23 Feb 2009 11:58:12 -0800
Message-ID: <43e72e890902231158w63b6fc7dh47eb0dd42a553aa3@mail.gmail.com> (sfid-20090223_205817_439166_04E7FA43)
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 11:31 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
>
>> On Mon, Feb 23, 2009 at 11:06 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>>>
>>>> For the case or cards capable of 5 GHz or of HT I believe we should
>>>> consider the cases of dealing with DFS or HT channel switch both of
>>>> which can occur dynamically while the STAs are associated. If
>>>> hardware is capable of differentiating this (through beacon
>>>> checksums) then that's an enhancement but for now I suspect that is
>>>> not the case for most hardware that implements this and as such for
>>>> the case when on DFS or using HT we can simply have mac80211 disable
>>>> this. Not sure... Thoughts?
>>>
>>> I don't see a problem. Like you said, such hardware should have beacon
>>> checksumming support. Whenever the checksum has changed, the hardware
>>> should pass the beacon to the host and mac80211 would receive the
>>> beacon just like without beacon filtering.
>>
>> _should_ -- but I don't think this is yet implemented.
>
> This is transparent for mac80211, if that's what you are asking. Even
> though the beacon filtering feature is enabled, the hardware can still
> send as much as beacons it wants. The most important is that the
> driver will call ieee80211_beacon_loss() whenever beacons are lost
> because mac80211 will not be following them.

Sure. My concerns was if drivers should enable/disable the flag
dynamically based on configuration. If hardware supports checksumming
as the one you are working with does then you are set, however if it
is not then essentially we either do not support this flag for those
type of devices that do not support checksumming _or_ we consider the
cases where this can be disabled dynamically depending on the
configuration (DFS, HT).

If we do support dynamic tuning of this variable due to different type
of connections to APs (DFS or HT) it might make sense to just have a
separate flag to indicate this and let mac80211 figure things out for
you. This is what I was getting at.

>>> Beacon filtering can be thought like filtering unrelevant beacons, but
>>> passing through the beacons which have new information. For example,
>>> stlc45xx already has beacon checksum support even though it doesn't
>>> support 5 GHz band. Unfortunately I haven't managed to find the time
>>> to test it yet.
>>
>> As IEEE-802.11 advances how does the hardware know which IEs to
>> checksum or not for? :)
>
> This is what is documented about stlc45xx firmware beacon filtering:
>
> "The LM_PSM_CHECKSUM flag configures the LMAC to calculate a checksum
> over the beacon frame body. The checksum is calculated over the
> frame-body, starting after the timestamp element. Excluded from the
> checksum calculation are all flexible elements, with a corresponding
> element ID in the exclude array structure member. The beacon is
> forwarded to the application, if the checksum changes from the
> previous received beacon."
>
> So the host can just provide the element ids which need to be excluded.

This is nice :)

>>> If there is hardware using 5 GHz band and does not support beacon
>>> checksumming, then the driver should not even enable beacon filtering.
>>
>> Heh.. umm, I'd like us to add this as a feature eventually too to be
>> able to save power but I think we do not checksum and hence my
>> comments.
>
> Other option is that the hardware just periodically passes a beacon to
> the host, for example every 10 seconds. Not very elegant, but I guess
> good enough for certain use cases.

Not good enough for DFS and not sure about HT as per the spec. I think
its easier to not enable this when on DFS channels or connecting using
11n.

  Luis
