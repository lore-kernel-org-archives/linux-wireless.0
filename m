Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33735 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932457AbdACORq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 09:17:46 -0500
MIME-Version: 1.0
In-Reply-To: <a67789ba-3346-6e10-89c2-2df419a80910@broadcom.com>
References: <20170103110340.23249-1-zajec5@gmail.com> <20170103110340.23249-2-zajec5@gmail.com>
 <a67789ba-3346-6e10-89c2-2df419a80910@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 3 Jan 2017 15:17:44 +0100
Message-ID: <CACna6ryAHJuxduKYHCrB+8bbix7Nqe-bQfOAo6ONOEDpXp5CFA@mail.gmail.com> (sfid-20170103_151913_766989_1ECCE5FF)
Subject: Re: [PATCH V4 2/2] cfg80211: support ieee80211-freq-limit DT property
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 January 2017 at 13:10, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 3-1-2017 12:03, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> This patch adds a helper for reading that new property and applying
>> limitations or supported channels specified this way.
>> It may be useful for specifying single band devices or devices that
>> support only some part of the whole band. It's common that tri-band
>> routers have separated radios for lower and higher part of 5 GHz band.
>>
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> ---
>> V2: Put main code in core.c as it isn't strictly part of regulatory - po=
inted
>>     by Arend.
>>     Update to support ieee80211-freq-limit (new property).
>> V3: Introduce separated wiphy_read_of_freq_limits function.
>>     Add extra sanity checks for DT data.
>>     Move code back to reg.c as suggested by Johannes.
>> V4: Move code to of.c
>>     Use one helper called at init time (no runtime hooks)
>>     Modify orig_flags
>> ---
>>  include/net/cfg80211.h |  26 ++++++++++
>>  net/wireless/Makefile  |   1 +
>>  net/wireless/of.c      | 137 ++++++++++++++++++++++++++++++++++++++++++=
+++++++
>>  net/wireless/reg.c     |   4 +-
>>  net/wireless/reg.h     |   2 +
>>  5 files changed, 168 insertions(+), 2 deletions(-)
>>  create mode 100644 net/wireless/of.c
>>
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index ca2ac1c..d7723a8 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -311,6 +311,32 @@ struct ieee80211_supported_band {
>>       struct ieee80211_sta_vht_cap vht_cap;
>>  };
>>
>> +/**
>> + * wiphy_read_of_freq_limits - read frequency limits from device tree
>> + *
>> + * @wiphy: the wireless device to get extra limits for
>> + *
>> + * Some devices may have extra limitations specified in DT. This may be=
 useful
>> + * for chipsets that normally support more bands but are limited due to=
 board
>> + * design (e.g. by antennas or extermal power amplifier).
>> + *
>> + * This function reads info from DT and uses it to *modify* channels (d=
isable
>> + * unavailable ones). It's usually a *bad* idea to use it in drivers wi=
th
>> + * shared channel data as DT limitations are device specific.
>> + *
>> + * As this function access device node it has to be called after set_wi=
phy_dev.
>
> You are aware that you need to modify this description with earlier
> patch "cfg80211: allow passing struct device in the wiphy_new call",
> right? :-p

I dropped that earlier patch for now as it's no longer a requirement
for this change. If someone find is useful though, I'll be happy to
resume my work on it later. And update this documentation as you
pointed out ;)


>> + * It also modifies channels so they have to be set first.
>> + */
>> +#ifdef CONFIG_OF
>> +int wiphy_read_of_freq_limits(struct wiphy *wiphy);
>> +#else /* CONFIG_OF */
>> +static inline int wiphy_read_of_freq_limits(struct wiphy *wiphy)
>> +{
>> +     return 0;
>> +}
>> +#endif /* !CONFIG_OF */
>> +
>> +
>
> [...]
>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 5dbac37..bda0e9e 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -748,8 +748,8 @@ static bool is_valid_rd(const struct ieee80211_regdo=
main *rd)
>>       return true;
>>  }
>>
>> -static bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_ran=
ge,
>> -                         u32 center_freq_khz, u32 bw_khz)
>> +bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
>> +                  u32 center_freq_khz, u32 bw_khz)
>>  {
>>       u32 start_freq_khz, end_freq_khz;
>
> would it be more appropriate to move this function to util.c?

I'm OK with moving this function (and maybe struct
ieee80211_freq_range as well). Any objections?

--=20
Rafa=C5=82
