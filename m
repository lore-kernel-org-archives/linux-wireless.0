Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65382 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0IPRRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 13:17:14 -0400
Received: by iwn5 with SMTP id 5so1193365iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 10:17:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE6600113431B85@dnce02.ent.ti.com>
References: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
 <1284575472-19888-5-git-send-email-shahar_levi@ti.com> <1284578468.1569.29.camel@powerslave>
 <AANLkTimCrCH_yh5y3L8WcfNus9A2RFMCqvK7Xb82VGUL@mail.gmail.com> <AC090B9732AB2B4DB7FF476E907FE6600113431B85@dnce02.ent.ti.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 17 Sep 2010 03:16:53 +1000
Message-ID: <AANLkTinPodQRk8HYDxxZ9BiKJ=-yAg8nybVqGpCqXsa2@mail.gmail.com>
Subject: Re: [PATCH 04/04] wl1271: 11n Support, 11n Kconfig Configurable
To: "Levi, Shahar" <shahar_levi@ti.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/17 Levi, Shahar <shahar_levi@ti.com>:
>> -----Original Message-----
>> From: Julian Calaby [mailto:julian.calaby@gmail.com]
>> Sent: Thursday, September 16, 2010 2:39 AM
>> To: Luciano Coelho
>> Cc: Levi, Shahar; linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH 04/04] wl1271: 11n Support, 11n Kconfig Configurable
>>
>> On Thu, Sep 16, 2010 at 05:21, Luciano Coelho <luciano.coelho@nokia.com>
>> wrote:
>> > On Wed, 2010-09-15 at 20:31 +0200, ext Shahar Levi wrote:
>> >> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c
>> b/drivers/net/wireless/wl12xx/wl1271_main.c
>> >> index e89e574..8f2cea9 100644
>> >> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
>> >> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
>> >> @@ -2087,7 +2087,9 @@ static struct ieee80211_supported_band
>> wl1271_band_2ghz = {
>> >>       .n_channels = ARRAY_SIZE(wl1271_channels),
>> >>       .bitrates = wl1271_rates,
>> >>       .n_bitrates = ARRAY_SIZE(wl1271_rates),
>> >> +#ifdef CONFIG_WL1271_HT
>> >>       .ht_cap = WL12xx_HT_CAP,
>> >> +#endif
>> >
>> > Here you can use #ifdef CONFIG_WL1271_80211_HT directly, no need to
>> > duplicate it into a new flag.
>>
>> Another thing you might want to do could be to adjust the order of the
>> patches so you introduce this config option *before* you introduce the
>> actual code that is protected by it. At the moment, this functionality
>> is enabled unconditionally if this patch isn't applied, which could
>> potentially occur during bisection, given that John doesn't squash the
>> patches into one when he applies them.
>>
>> Thanks,
>>
>> --
>>
>> Julian Calaby
>>
>> Email: julian.calaby@gmail.com
>> Profile: http://www.google.com/profiles/julian.calaby/
>> .Plan: http://sites.google.com/site/juliancalaby/
>
> Hi Julian,
> It is a good point. ".ht_cap = WL12xx_HT_CAP" in wl1271_main.c adds only on patch 03/04. I believe that adding "#ifdef CONFIG_WL1271_HT" in wl1271_main.c with early patch on code that not exist is less clear. Squashing the patches 03 and 04 to one in v2 could prevent that but it will not emphasize the configuration option. Is there are cases that the some patches from series not applies?

Bisection (which seems to be my watch word, at the moment) could jump
into the middle of random patch sets like this.

Personally, I'd squash 3 and 4 into one patch: I.e. you're saying
"here's the functionality and it's protected by a Kconfig variable."
The fact that it's touching the Kconfig file is probably enough
emphasis in and of itself.

> Thanks for your review,

No problem,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
