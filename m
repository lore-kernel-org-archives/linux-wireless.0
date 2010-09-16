Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61864 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab0IPAji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 20:39:38 -0400
Received: by iwn5 with SMTP id 5so547061iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 17:39:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284578468.1569.29.camel@powerslave>
References: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
 <1284575472-19888-5-git-send-email-shahar_levi@ti.com> <1284578468.1569.29.camel@powerslave>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 16 Sep 2010 10:39:18 +1000
Message-ID: <AANLkTimCrCH_yh5y3L8WcfNus9A2RFMCqvK7Xb82VGUL@mail.gmail.com>
Subject: Re: [PATCH 04/04] wl1271: 11n Support, 11n Kconfig Configurable
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext Shahar Levi <shahar_levi@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 05:21, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Wed, 2010-09-15 at 20:31 +0200, ext Shahar Levi wrote:
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
>> index e89e574..8f2cea9 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
>> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
>> @@ -2087,7 +2087,9 @@ static struct ieee80211_supported_band wl1271_band_2ghz = {
>>       .n_channels = ARRAY_SIZE(wl1271_channels),
>>       .bitrates = wl1271_rates,
>>       .n_bitrates = ARRAY_SIZE(wl1271_rates),
>> +#ifdef CONFIG_WL1271_HT
>>       .ht_cap = WL12xx_HT_CAP,
>> +#endif
>
> Here you can use #ifdef CONFIG_WL1271_80211_HT directly, no need to
> duplicate it into a new flag.

Another thing you might want to do could be to adjust the order of the
patches so you introduce this config option *before* you introduce the
actual code that is protected by it. At the moment, this functionality
is enabled unconditionally if this patch isn't applied, which could
potentially occur during bisection, given that John doesn't squash the
patches into one when he applies them.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
