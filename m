Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45462 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0ETB0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 21:26:52 -0400
Received: by mail-pv0-f174.google.com with SMTP id 18so1258895pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 18:26:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005201012.12045.br1@einfach.org>
References: <20100519012528.22206.77550.stgit@tt-desk> <201005200935.40377.br1@einfach.org>
	<20100520005143.GB10702@tux> <201005201012.12045.br1@einfach.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 19 May 2010 18:26:29 -0700
Message-ID: <AANLkTimso6hoef9IG2VtRQsHQiOVTQF-dwNZEooZTb3Y@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna
	configuration
To: Bruno Randolf <br1@einfach.org>
Cc: "ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 19, 2010 at 6:12 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Thursday 20 May 2010 09:51:43 Luis R. Rodriguez wrote:
>> On Wed, May 19, 2010 at 05:35:40PM -0700, Bruno Randolf wrote:
>> > On Thursday 20 May 2010 02:07:25 you wrote:
>> > > On Tue, May 18, 2010 at 6:31 PM, Bruno Randolf <br1@einfach.org> wrote:
>> > > > + * @NL80211_ATTR_ANTENNA_TX: Bitmap of antennas to use for
>> > > > transmitting. + * @NL80211_ATTR_ANTENNA_RX: Bitmap of antennas to
>> > > > use for receiving.
>> > >
>> > > This gets the job done, but that's it. The API defined allows for a
>> > > hugely loose implementation on each driver.
>> >
>> > i tried to define it like this, in the commit log:
>> >     The antenna configuration is defined as a bitmap of allowed antennas.
>> >     This bitmap is 8 bit at the moment, each bit representing one
>> >     antenna. If multiple antennas are selected, the driver may use
>> >     diversity for receive and transmit.
>> >
>> > is this not precise enough?
>>
>> No, the commit log is just a placeholder of information, if you want to
>> define API you do it through the kdoc so you can slap people when then
>> submit patches that do not follow it. The kdoc above allows the flexibility
>> you were looking for but that I do not think we should have since it will
>> confuse the users who want to tune antenna settings on different drivers.
>
> you are talking about the place where to put the definition, not about the
> definition itself. i agree, the definition should be in the kdoc, and i'll
> update the patch. what's wrong with the definition itself?

Why are you using a bitmask for only 3 possibly different settings?

>> Understood, how about just defining something very basic and simple
>> for legacy based operation mode?
>
> i think my implementation is quite basic and simple ;)

Oh it is, I think it can be much simpler though.

>> > > And yet for another driver it could be something completely different
>> > > in usersepace.
>> >
>> > what do you think that could be, realistically, given the above
>> > definition?
>>
>> Well, anything that has to do with tx / rx antennas.
>
> that's not very clear. can you give me an example?

iw dev wlan0 set_tx_antenna 4

>> > > I think it would be better for us to define a static
>> > > API for all legacy cards and another for 802.11n cards, or unify them
>> > > but to be very specific about the API for antenna settings/chainmask
>> > > settings.
>> >
>> > sure. any suggestions?
>>
>> Sure how about FIXED_A, FIXED_B, DIVERSITY ?
>
> that's very ath5k centric.
>
> what if there is a 'legacy' hardware with 3 or more antennas?

Like what?

> what if we want to configure RX on antenna 1, TX on antenna 2?

Are you not using a value for TX and RX? Would that now allow for this?

> what if we want to use RX diversity but always TX on a fixed antenna?

You have this for both, RX and TX, and specify that on the kdoc (?)

> these are possible and useful configurations, which are not supported right
> now by ath5k but it's easy to add them.
>
> i don't see how "my" API is too complicated, and i think it allows for a clear
> configuration of these cases as well.
>
> your criticism seems to be based on the fact that it's not clear how to handle
> 802.11n chainmask + antenna configuration, but this is not what my patch is
> concerned about. let's go step by step...

No no, that is my fault, I brought that up, I was hoping we could
address it but it seems that we can't as I don't have time to think
about this further in a unified clean API. But if its just going to be
legacy then I don't see why we would use a large bitmap.

  Luis
