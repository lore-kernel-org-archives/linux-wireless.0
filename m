Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:41054 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab0AHVmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 16:42:19 -0500
Received: by iwn32 with SMTP id 32so3408293iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jan 2010 13:42:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100108131451.GA18758@jm.kir.nu>
References: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
	<1262903097-2129-3-git-send-email-lrodriguez@atheros.com>
	<20100108131451.GA18758@jm.kir.nu>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 8 Jan 2010 13:41:58 -0800
Message-ID: <43e72e891001081341j1c24b7c4i6f5bb636d8ccc81b@mail.gmail.com>
Subject: Re: [PATCH 2/4] cfg80211: fix 2 GHz subband calculation for country
	IEs
To: Jouni Malinen <j@w1.fi>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 8, 2010 at 5:14 AM, Jouni Malinen <j@w1.fi> wrote:
> On Thu, Jan 07, 2010 at 05:24:55PM -0500, Luis R. Rodriguez wrote:
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -555,7 +555,7 @@ static struct ieee80211_regdomain *country_ie_2_rd(
>>               /* 2 GHz */
>>               if (triplet->chans.first_channel <= 14)
>
> By the way, that looks completely bogus.. Channel number cannot be used
> to figure out whether this is 2.4 GHz or 5 GHz band (e.g., channel 8 is
> used in both). This really should be based on the band the frame with
> the Country IE was received.

This seems to me more like an issue with the spec. Doing it based on
the received band is obviously possible but what if the AP wants to
send out Country IE information for both channel 8 on 2 GHz and
channel 8 on 5 GHz?

>>                       end_channel = triplet->chans.first_channel +
>> -                             triplet->chans.num_channels;
>> +                             triplet->chans.num_channels - 1;
>
> Could be reasonable to verify that num_channels is not 0.. Based on a
> quick look, I did not notice places where negative end_channel value
> would trigger bad problems, but it would be safer to validate that the
> received information is valid before using it.

Good point, thanks, will send another patch to deal with that case.

  Luis
