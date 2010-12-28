Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65176 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0L1GQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 01:16:30 -0500
Received: by gxk9 with SMTP id 9so1107321gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 22:16:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293454640.19215.3042.camel@powerslave>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
 <1293028057-6212-7-git-send-email-arik@wizery.com> <1293454640.19215.3042.camel@powerslave>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 28 Dec 2010 08:16:14 +0200
Message-ID: <AANLkTikrgQwxBKSc_s-DHU+ktU+HwHb1hBukL+0rgpYK@mail.gmail.com>
Subject: Re: [PATCH v2 06/18] wl1271: AP mode - init sequence
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 27, 2010 at 14:57, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
>> Split HW init sequence into AP/STA specific parts
>>
>> The AP specific init sequence includes configuration of templates, rate
>> classes, power mode, etc. Also unmask AP specific events in the event mbox.
>>
>> Separate the differences between AP and STA init into mode
>> specific functions called from wl1271_hw_init. The first is called after
>> radio configuration and the second after memory configuration.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
>> index 02f843c..d51324d 100644
>> --- a/drivers/net/wireless/wl12xx/cmd.h
>> +++ b/drivers/net/wireless/wl12xx/cmd.h
>> @@ -140,6 +140,13 @@ enum cmd_templ {
>>                                 * For CTS-to-self (FastCTS) mechanism
>>                                 * for BT/WLAN coexistence (SoftGemini). */
>>       CMD_TEMPL_ARP_RSP,
>> +
>> +     /* AP-mode specific */
>> +     CMD_TEMPL_AP_BEACON = 13,
>> +     CMD_TEMPL_AP_PROBE_RESPONSE,
>> +     CMD_TEMPL_AP_ARP_RSP,
>> +     CMD_TEMPL_DEAUTH_AP,
>> +
>>       CMD_TEMPL_MAX = 0xff
>>  };
>
> Cool, I see that you fixed the issue we had before.  Just one question,
> is the CMD_TEMPL_AP_ARP_RSP the same as the original CMD_TEMPL_ARP_RSP?
> I mean is it only the order in the enum that is different between the AP
> and the STA firmwares? If that's the case, we should *really* try to get
> this fixed in the AP firmware.
>
> It's still new enough and not so many people are using it yet, right? So
> it's the time to fix it if it makes sense.

Actually the AP and STA modes will be merged in one FW in the future.
So its already unified there.
Also note arp-filtering is only relevant for the STA role for now.
Only stations get the BSS_CHANGED_ARP_FILTER notification.
Implementing this for AP will require changes in mac80211.

>
>
>> diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
>> index 799c369..df6666b 100644
>> --- a/drivers/net/wireless/wl12xx/init.c
>> +++ b/drivers/net/wireless/wl12xx/init.c
>
> [...]
>
>> @@ -145,10 +253,6 @@ int wl1271_init_phy_config(struct wl1271 *wl)
>>       if (ret < 0)
>>               return ret;
>>
>> -     ret = wl1271_acx_group_address_tbl(wl, true, NULL, 0);
>> -     if (ret < 0)
>> -             return ret;
>> -
>
> Here we're changing the order of these initialization ACXs, but it
> shouldn't be a problem.  If it is a problem, it's a firmware bug that
> (hopefully) can be fixed.

Haven't seen a problem with this one. Also note this ACX will be
reconfigured again on the first wl1271_op_configure_filter() call.

>
>
>> @@ -213,11 +317,150 @@ static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
>>       return 0;
>>  }
>>
>> +static int wl1271_sta_hw_init(struct wl1271 *wl)
>> +{
>> +     int ret;
>> +
>> +     ret = wl1271_cmd_ext_radio_parms(wl);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     ret = wl1271_sta_init_templates_config(wl);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     ret = wl1271_acx_group_address_tbl(wl, true, NULL, 0);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     /* Initialize connection monitoring thresholds */
>> +     ret = wl1271_acx_conn_monit_params(wl, false);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     /* Beacon filtering */
>> +     ret = wl1271_init_beacon_filter(wl);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     /* Bluetooth WLAN coexistence */
>> +     ret = wl1271_init_pta(wl);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     /* Beacons and boradcast settings */
>
> You copied the typo, maybe you could take the opportunity to fix it?

Sure.

>
>> +     ret = wl1271_init_beacon_broadcast(wl);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     /* Configure for ELP power saving */
>> +     ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     /* Configure rssi/snr averaging weights */
>> +     ret = wl1271_acx_rssi_snr_avg_weights(wl);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     ret = wl1271_acx_sta_rate_policies(wl);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     return 0;
>> +}
>
> Also here, this changes the initialization order a bit.  I think this
> was Juuso's concern earlier.  At least while we were having debug camps,
> the TI people supporting us were always asking us to be extremely
> cautious with the order of the initialization.  They were saying that it
> was really important to do the initialization in the same way as the
> tiwlan driver does.  Hopefully this is not an issue now...

We haven't encountered any issues in our internal testing (in both STA
and AP roles).

>
>
>> @@ -279,21 +512,11 @@ int wl1271_hw_init(struct wl1271 *wl)
>>       if (ret < 0)
>>               goto out_free_memmap;
>>
>> -     /* Bluetooth WLAN coexistence */
>> -     ret = wl1271_init_pta(wl);
>> -     if (ret < 0)
>> -             goto out_free_memmap;
>> -
>
> Just out of curiosity... Is AP coexistence with Bluetooth possible? This
> could be important in some scenarios.

It is possible and will be implemented in the future.

>
>
>> diff --git a/drivers/net/wireless/wl12xx/init.h b/drivers/net/wireless/wl12xx/init.h
>> index 7762421..4d37210 100644
>> --- a/drivers/net/wireless/wl12xx/init.h
>> +++ b/drivers/net/wireless/wl12xx/init.h
>> @@ -27,10 +27,13 @@
>>  #include "wl12xx.h"
>>
>>  int wl1271_hw_init_power_auth(struct wl1271 *wl);
>> -int wl1271_init_templates_config(struct wl1271 *wl);
>> +int wl1271_sta_init_templates_config(struct wl1271 *wl);
>>  int wl1271_init_phy_config(struct wl1271 *wl);
>>  int wl1271_init_pta(struct wl1271 *wl);
>>  int wl1271_init_energy_detection(struct wl1271 *wl);
>>  int wl1271_hw_init(struct wl1271 *wl);
>>
>> +/* Functions from wl1271_main.c */
>> +u32 wl1271_min_rate_get(struct wl1271 *wl);
>> +
>
> This is bad and shouldn't be here.  Need to find a better place for it.

How about tx.h? It's TX rate we're talking about here after all.
I can also change the name to wl1271_tx_min_rate_get().

>
>
>> diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
>> index be21032..b230e72 100644
>> --- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
>> +++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
>> @@ -160,4 +160,9 @@ struct wl12xx_probe_resp_template {
>>       struct wl12xx_ie_country country;
>>  } __packed;
>>
>> +struct wl12xx_disconn_template {
>> +     struct ieee80211_header header;
>> +     __le16 disconn_reason;
>> +} __packed;
>> +
>
> Isn't padding necessary here to keep the struct 32-bit aligned?

AFAIK, templates should not be 32-bit aligned. Most of the templates
are not aligned.

Regards,
Arik
