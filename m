Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34816 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbcEaP6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 11:58:22 -0400
Received: by mail-oi0-f50.google.com with SMTP id w184so297233771oiw.2
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2016 08:58:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464700487.3076.28.camel@sipsolutions.net>
References: <1463739223-19205-1-git-send-email-zajec5@gmail.com>
	<1464689804.3076.13.camel@sipsolutions.net>
	<CACna6rw--bPNdWcp1Bx1GOKv9cnOgfr5D_YU1RF7A8CS_Bt7Vg@mail.gmail.com>
	<1464700487.3076.28.camel@sipsolutions.net>
Date: Tue, 31 May 2016 17:58:21 +0200
Message-ID: <CACna6rz6N_indSm7WNyJdyWmbKnkx-dTBzwUN=x+m5ooSkbRXA@mail.gmail.com> (sfid-20160531_175825_920951_C2C024FE)
Subject: Re: [PATCH iw] add "channels" PHY command listing frequencies with
 more details
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 May 2016 at 15:14, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2016-05-31 at 15:10 +0200, Rafał Miłecki wrote:
>
>> > Unfortunately, I get compiler warnings about width_* being possibly
>> > used uninitialized. Can you address that please?
>> It's nice your compiled got this mistake, my didn't. There were
>> actually meant to be static. I'll fix that.
>
> I actually think the compiler is wrong, and there's no reason for them
> to be static, is there?
>
> The first iteration of the loop should always initialize since -1 is
> used for initialization?
>
> In any case, I'd prefer to avoid static, if necessary pass some kind of
> context structure in to the function?

I don't know if we can assume getting all three attributes:
NL80211_BAND_ATTR_HT_CAPA
NL80211_BAND_ATTR_VHT_CAPA
NL80211_BAND_ATTR_FREQS
at the same single handler call. I guess not. That's why I believe we
need all width_* to be static, so they keep value across separated
handler calls.


>> > > +TOPLEVEL(channels, NULL, NL80211_CMD_GET_WIPHY, 0, CIB_PHY,
>> > > handle_channels, "Show available channels.");
>> > Maybe that should be allowed for a CIB_DEV too?
>> Since this is PHY specific, I was thinking it should be CIB_PHY. I
>> didn't see reason to allow querying devices. Similarly we don't
>> support "iw dev wlan0 reg get".
>>
>> Anyway, I can change that if you think it's better for some reason.
>
> I was just thinking that supporting it with wlan0 would in certain
> cases make it easier for the user (not having to look up the phy
> number)
>
>> Any hint how to make command usable with both: phy and dev?
>
> Just add:
>
> TOPLEVEL(channels, NULL, NL80211_CMD_GET_WIPHY, 0, CIB_NETDEV, ...);

But this will disallow using "iw phy phy0 channels". I'd prefer to
have this one working in the first place and having "iw dev wlan0
channels" as an alternative. Is there a way to achieve that easily?

-- 
Rafał
