Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:57225 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0AIA2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 19:28:39 -0500
Received: by iwn32 with SMTP id 32so3487678iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jan 2010 16:28:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100108232009.GA4840@jm.kir.nu>
References: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
	<1262903097-2129-3-git-send-email-lrodriguez@atheros.com>
	<20100108131451.GA18758@jm.kir.nu> <43e72e891001081341j1c24b7c4i6f5bb636d8ccc81b@mail.gmail.com>
	<20100108232009.GA4840@jm.kir.nu>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 8 Jan 2010 16:28:17 -0800
Message-ID: <43e72e891001081628s47474cadl5473432411162f0f@mail.gmail.com>
Subject: Re: [PATCH 2/4] cfg80211: fix 2 GHz subband calculation for country
	IEs
To: Jouni Malinen <j@w1.fi>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 8, 2010 at 3:20 PM, Jouni Malinen <j@w1.fi> wrote:
> On Fri, Jan 08, 2010 at 01:41:58PM -0800, Luis R. Rodriguez wrote:
>> On Fri, Jan 8, 2010 at 5:14 AM, Jouni Malinen <j@w1.fi> wrote:
>> > By the way, that looks completely bogus.. Channel number cannot be used
>> > to figure out whether this is 2.4 GHz or 5 GHz band (e.g., channel 8 is
>> > used in both). This really should be based on the band the frame with
>> > the Country IE was received.
>>
>> This seems to me more like an issue with the spec. Doing it based on
>> the received band is obviously possible but what if the AP wants to
>> send out Country IE information for both channel 8 on 2 GHz and
>> channel 8 on 5 GHz?
>>
>
> I don't think the original Country IE design from IEEE Std 802.11d-2001
> really supported such use, i.e., you can only describe the channels from
> your own band with that design. Have you really seen APs advertising
> channels from the other band in their Country IE?
>
> I would assume you could now use the Regulatory Extension mechanism to
> define another regulatory class and subband followed by channel triplets
> to do that. However, even in that case, the first triplets in the IE
> really needs to be for the band the frame is send on. Once the
> Regulatory Extension Identifier is used, further triplets should be
> interpreted differently. Anyway, I have no idea whether anyone really
> supports this extension (or can parse the standard to figure out how it
> would be used ;-)..

Heh alright, I'll change this to match the rx'd band first but that
change is a bit big for stable so we'll have to deal with how we have
it now for stable. I'll submit the changes for wireless-testing. Now
last question -- although I haven't seen APs send country IEs for two
bands in case we do, how do you want to treat those channels?

Does hostapd send just one band or two bands on the country IE?

  Luis
