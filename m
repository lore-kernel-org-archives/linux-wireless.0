Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33211 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab2K0Vce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 16:32:34 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so4788189wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 13:32:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354023406.950.109.camel@cumari.coelho.fi>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
 <1353998701-18171-15-git-send-email-arik@wizery.com> <1354023406.950.109.camel@cumari.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 27 Nov 2012 23:32:17 +0200
Message-ID: <CA+XVXfeeo9kPmKyo=qtn_bAnj5gveiKa6PiMq8hV-5P9P4oyhw@mail.gmail.com> (sfid-20121127_223238_619439_36D4393F)
Subject: Re: [PATCH 14/20] wlcore: restore default channel configuration
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Victor Goldenshtein <victorg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 27, 2012 at 3:36 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2012-11-27 at 08:44 +0200, Arik Nemtsov wrote:
>> From: Victor Goldenshtein <victorg@ti.com>
>>
>> wlcore allocates two static structs wl1271_band_2ghz & wl1271_band_5ghz
>> which are used/modified by Reg-Domain e.g. some channel might be marked
>> as passive at some point. Make sure we don't keep stale settings around
>> if the HW is unregistered/registered during operation.
>>
>> [Arik - use Tx-power constant and tweak commit message]
>>
>> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
>> index e68cd3f..3ced59b 100644
>> --- a/drivers/net/wireless/ti/wlcore/main.c
>> +++ b/drivers/net/wireless/ti/wlcore/main.c
>
> [...]
>
>> @@ -5537,6 +5537,7 @@ wlcore_iface_combinations[] = {
>>
>>  static int wl1271_init_ieee80211(struct wl1271 *wl)
>>  {
>> +     int i;
>>       static const u32 cipher_suites[] = {
>>               WLAN_CIPHER_SUITE_WEP40,
>>               WLAN_CIPHER_SUITE_WEP104,
>> @@ -5599,6 +5600,22 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
>>                    ARRAY_SIZE(wl1271_channels_5ghz) >
>>                    WL1271_MAX_CHANNELS);
>>       /*
>> +     * clear channel flags from the previous usage
>> +     * and restore max_power & max_antenna_gain values.
>> +     */
>> +     for (i = 0; i < ARRAY_SIZE(wl1271_channels); i++) {
>> +             wl1271_band_2ghz.channels[i].flags = 0;
>> +             wl1271_band_2ghz.channels[i].max_power = WLCORE_MAX_TXPWR;
>> +             wl1271_band_2ghz.channels[i].max_antenna_gain = 0;
>> +     }
>> +
>> +     for (i = 0; i < ARRAY_SIZE(wl1271_channels_5ghz); i++) {
>> +             wl1271_band_5ghz.channels[i].flags = 0;
>> +             wl1271_band_5ghz.channels[i].max_power = WLCORE_MAX_TXPWR;
>> +             wl1271_band_5ghz.channels[i].max_antenna_gain = 0;
>> +     }
>> +
>> +     /*
>
> This looks a bit hacky, because you must know what values are being
> modified by cfg80211.  What if in the future there are more values in
> the channel structure that are being modified?
>
> The best would be to have a copy of the struct to pass to cfg80211 when
> the hardware is registered and realloc it when we unregister.  That
> would be safer and more future-proof, but would use a bit more memory
> though.

Yea a new struct wasn't used because of the memory requirement. I
agree a copy is cleaner.
Let's start with this one to solve the actual bug and make a TODO for later?

I'm also not sure that having cfg80211 change a structure allocated
and owned by the driver is the cleanest solution for the regulatory
stuff.
