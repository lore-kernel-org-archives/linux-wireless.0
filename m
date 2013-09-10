Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61615 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3IJOvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 10:51:16 -0400
Received: by mail-ie0-f179.google.com with SMTP id e14so1896659iej.38
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 07:51:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378798759.4799.57.camel@porter.coelho.fi>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	<1378218848-7853-9-git-send-email-eliad@wizery.com>
	<1378798759.4799.57.camel@porter.coelho.fi>
Date: Tue, 10 Sep 2013 16:51:15 +0200
Message-ID: <CAB3XZEdmkxNyK2i1DZXwKqnxZtXGhT3VVizc9iBQ+zTK-YJFPA@mail.gmail.com> (sfid-20130910_165119_443786_CE74A31B)
Subject: Re: [PATCH 09/12] wlcore: fix regulatory domain bit translation
From: Eliad Peller <eliad@wizery.com>
To: Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 10:39 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
>> From: Ido Reis <idor@ti.com>
>>
>> This is a fix for channels 52,56,60,64 bit translation.
>>
>> Reported-by: Yaniv Machani <yanivma@ti.com>
>> Signed-off-by: Ido Reis <idor@ti.com>
>> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>>  drivers/net/wireless/ti/wlcore/cmd.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
>> index e3ae425..1cb3296 100644
>> --- a/drivers/net/wireless/ti/wlcore/cmd.c
>> +++ b/drivers/net/wireless/ti/wlcore/cmd.c
>> @@ -1613,8 +1613,10 @@ static int wlcore_get_reg_conf_ch_idx(enum ieee80211_band band, u16 ch)
>>       case IEEE80211_BAND_5GHZ:
>>               if (ch >= 8 && ch <= 16)
>>                       idx = ((ch-8)/4 + 18);
>> -             else if (ch >= 34 && ch <= 64)
>> +             else if (ch >= 34 && ch <= 48)
>>                       idx = ((ch-34)/2 + 3 + 18);
>> +             else if (ch >= 52 && ch <= 64)
>> +                     idx = ((ch-52)/4 + 11 + 18);
>>               else if (ch >= 100 && ch <= 140)
>>                       idx = ((ch-100)/4 + 15 + 18);
>>               else if (ch >= 149 && ch <= 165)
>
> Hmmm... I don't have a clue what is going on here.  I don't know how I
> let this function pass as is originally, shame on me. :)
>
:)

> The change probably makes things work better, since someone apparently
> saw a bug in real life and reported it, but can anyone explain what is
> going on during this translation? Aren't we losing data here? Eg.
> channels 8, 9, 10 and 11 all use the same bit in the firmware command
> bitmask?
>
the 8-16 indeed looks weird, as the driver indeed declares supports
for channels 7,8,9,11...
the other conditions are a simple attempt to reduce the gap between
the channels (e.g. no channels between 64 and 100) in order to get a
minimized bitmap.
since the gap between the defined channels in the 5ghz band is usually
2/4 (36->38 vs. 60->64) the other calculations seems fine (i didn't
dig into them as well, though).

i'll try getting some more information from the fw guys regarding the
8-16 range.

Eliad.
