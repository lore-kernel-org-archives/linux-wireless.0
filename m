Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52030 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab1EYPBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 11:01:45 -0400
Received: by iyb14 with SMTP id 14so6253696iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 08:01:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimMXbZE=vY95C0b2H3hx=4XWdU2Qg@mail.gmail.com>
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>
 <201105241627.49201.helmut.schaa@googlemail.com> <BANLkTikcEsKYo=c=ZmzJRbmfgjmrFmx9bg@mail.gmail.com>
 <BANLkTin4MvdbqugTjtXvmjz5N8_TyTY7OA@mail.gmail.com> <BANLkTi=xfv_0C1mVAtO=w5JqyXLvh=vtAQ@mail.gmail.com>
 <BANLkTimMXbZE=vY95C0b2H3hx=4XWdU2Qg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 25 May 2011 08:01:25 -0700
Message-ID: <BANLkTi=rS_kDhB8oKBLsz2Mk2nvRJMu5mg@mail.gmail.com> (sfid-20110525_170149_611942_E39CE929)
Subject: Re: Initial automatic channel selection implementation
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com, Matt Smith <Matt.Smith@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 25, 2011 at 7:45 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> On Wed, May 25, 2011 at 4:37 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Wed, May 25, 2011 at 5:19 AM, Helmut Schaa
>> <helmut.schaa@googlemail.com> wrote:
>>> On Wed, May 25, 2011 at 12:54 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>> Yes, thanks this is a lot of work already done. Now we just need a
>>>> basic algorithm to parse this, quantify how ideal this channel is and
>>>> then spit out a desired optimal channel.
>>>
>>> That's what I've hacked some time ago (in form of the attached _ugly_ shell
>>> script that does auto channel selection with rt2x00, not sure if it works
>>> correct with other drivers as the survey dump differs somehow between
>>> rt2x00, ath5k and ath9k, and it only does channel 1-11):
>>>
>>> - Iterate over all channels and stay on each channel for some time
>>
>> Nice, yeah I was thinking of using the offchannel operation if we want
>> to spend more time there for inspection and if associated. For first
>> iteration it should be possible to just move around. In fact for AP
>> purposes I suppose one will want to just start AP mode ASAP and then
>> later do offchannel operations to do the inspection on the ideal
>> channel. Otherwise we sit there idle until we complete the Automatic
>> Channel Selection thingy.
>
> Correct, especially if we also consider 5Ghz channels. Offchannel operations
> would be nice but how can we ensure AP mode while being offchannel?

Notification of absence.

>>> - Store busy time stats for each channel
>>> - Choose the channel with the lowest busy time (and on 2.4Ghz also
>>>  check the busy times on adjacent channels)
>>
>> So I was reviewing this -- if we are TX'ing or RX'ing it seems to me
>> we should skip that time from the busy time, otherwise the "busy" time
>> includes time we induced on TX'ing or RX'ing ourselves. So I was
>> thinking of using the:
>>
>>  (active time - rx time - tx time)  / busy time
>
> Looks good ;) just one problem from a rt2x00 POV: We can't report rx/tx busy
> time separately, we can only advice the hw to include or exclude rx/tx time
> from the busy time statistics.

Doh, I see.. well in order for the above math to be useful we'd have
to be consistent across drivers. What is being done by rt2x00 right
now? If the later then the math would still work, otherwise then we'd
need to adjust.

  Luis
