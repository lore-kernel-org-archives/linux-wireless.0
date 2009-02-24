Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:48911 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbZBXUee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 15:34:34 -0500
Received: by fxm11 with SMTP id 11so3138476fxm.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 12:34:30 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
References: <20090223163626.20939.4879.stgit@tikku>
	<20090223163738.20939.25890.stgit@tikku>
	<43e72e890902230947x6e55bf36ve715295f43f74fbb@mail.gmail.com>
	<87prh9ht22.fsf@litku.valot.fi>
	<1235441919.4455.68.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 24 Feb 2009 22:34:25 +0200
In-Reply-To: <1235441919.4455.68.camel@johannes.local> (Johannes Berg's message of "Mon\, 23 Feb 2009 18\:18\:39 -0800")
Message-ID: <873ae3y3ou.fsf@litku.valot.fi> (sfid-20090224_213438_245651_55358C93)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2009-02-23 at 21:06 +0200, Kalle Valo wrote:
>
>> Also my assumption here is that ieee80211_beacon_loss() should be
>> called only after certain number of consecutive beacon misses. While
>> testing these patches on stlc45xx I used number 10. Can ath9k handle
>> anything like this? Or will it just report each beacon miss
>> individually?
>
> Should the number be configurable? The beacon interval might vary so it
> might be useful to set it so that misses * interval is constant?

Yes, I think so. I decided to omit this part for now and add it later
when we know more how different hardware support it.

>> I don't see a problem. Like you said, such hardware should have beacon
>> checksumming support. Whenever the checksum has changed, the hardware
>> should pass the beacon to the host and mac80211 would receive the
>> beacon just like without beacon filtering. 
>> 
>> Beacon filtering can be thought like filtering unrelevant beacons, but
>> passing through the beacons which have new information. For example,
>> stlc45xx already has beacon checksum support even though it doesn't
>> support 5 GHz band. Unfortunately I haven't managed to find the time
>> to test it yet.
>> 
>> If there is hardware using 5 GHz band and does not support beacon
>> checksumming, then the driver should not even enable beacon filtering.
>
> Should the flag be per-band in that case? 

I would like to see such (in my opinion broken) hardware design first.

> Or do we need checksum support anyway?

My current thinking is that to have proper beacon filtering the
hardware needs to support checksumming. Beacon filtering might work
without checksum support in most cases so that the users won't notice
anything. But from engineer's point of view I don't consider it as
good enough, at least ERP protection changes would end up unnoticed,
and I'm sure there are also other cases.

I don't know how beacon filtering works in wl12xx, I need to test that
soon. It might give some hints how other vendors have implemented
this.

> (Actually, we shouldn't call that checksum support, but 'beacon
> change notification' or something, I guess)

Yes. But I don't think we need to add any checksum support to
mac80211. Apart from mentioning it in the documentation, of course.

-- 
Kalle Valo
