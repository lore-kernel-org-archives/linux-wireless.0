Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63298 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab0HBFhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 01:37:31 -0400
Received: by iwn7 with SMTP id 7so3809645iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 22:37:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201008021313.54850.br1@einfach.org>
References: <20100729035820.5930.29864.stgit@tt-desk> <201007291812.28639.br1@einfach.org>
	<AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com>
	<201008021313.54850.br1@einfach.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 1 Aug 2010 22:37:10 -0700
Message-ID: <AANLkTimRnfa8HVpi0hcP7Eo9Nrns60ff3Hs+fq39WoJh@mail.gmail.com>
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com, nbd@openwrt.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 1, 2010 at 9:13 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Fri July 30 2010 00:04:49 Luis R. Rodriguez wrote:
>> >> I don't want to do any work myself on drivers for this, can we have
>> >> cfg80211/mac80211 do this for us?
>> >
>> > is this not a separate issue from defining the API? you could have it do
>> > this for you even now, with or without the antenna API, no?
>>
>> It depends on the consumer and at what level we think the consumer
>> should be doing whatever checks or changes it should. For starters I
>> would expect at least a check for association within cfg80211 which
>> disallows hw config changes.
>
> for ath5k at least, it's o.k. to change antenna configuration during
> association.

Then do it through debugfs.

> if 802.11n devices cannot change antenna setup during association, the driver
> could simply reject the configuration. but i can see that it can make sense to
> handle some of this in cfg80211 or mac80211. it should be possible to add that
> on top of my patches.

I would expect the respective changes within your patches, not after.

> i think you are expecting to much.

I refuse to accept patches which can potentially create bogus bug
reports or loose crap implementations in drivers. Wext had a lot of
this and I am glad we haven't yet allowed for this crap with nl80211.
To allow your patch to go through as-is without addressing all the
points made would be enabling driver developers to get real sloppy.

> for now i just want to define an API which
> 1) can be used right now and 2) is flexible enough to support 802.11n devices.

Use debugfs or consider a simple API for legacy for nl80211.

> as i don't work with 802.11n devices right now, please don't expect me to
> solve all 802.11n related antenna problems.

I'm not, the point I was trying to make is that solving this for
legacy and that for 802.11n this needs more thought and work.

> as long as the API is flexible
> enough i think it can be added later as 802.11n devices are going to accept
> antenna configuration.

If you want really flexible stuff without addressing serious
considerations before introducing a new kernel API then use debugfs.

  Luis
