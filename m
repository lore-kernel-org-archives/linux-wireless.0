Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63519 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1JJT3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 15:29:23 -0400
Received: by ywb5 with SMTP id 5so5701858ywb.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 12:29:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318271328.9690.381.camel@cumari>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	<1318234397-21081-7-git-send-email-eliad@wizery.com>
	<1318271328.9690.381.camel@cumari>
Date: Mon, 10 Oct 2011 21:29:23 +0200
Message-ID: <CAB3XZEfA2woetrXDycv3xcBYGBvyYJQoLz969Rp8k8WjaG3FFw@mail.gmail.com> (sfid-20111010_212927_011194_D4400CBE)
Subject: Re: [PATCH 06/29] wl12xx: add vifs list
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 10, 2011 at 8:28 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote:
>> keep a list of all the vifs associated with our hw.
>> it will be later used in order to iterate through vifs.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
>> index 33ccdf8..55561c5 100644
>> --- a/drivers/net/wireless/wl12xx/wl12xx.h
>> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
>> @@ -394,6 +394,8 @@ struct wl1271 {
>>       unsigned long roles_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
>>       unsigned long roc_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
>>
>> +     struct list_head wlvif_list;
>> +
>>       struct wl1271_acx_mem_map *target_mem_map;
>>
>>       /* Accounting for allocated / available TX blocks on HW */
>> @@ -564,6 +566,7 @@ struct wl1271_station {
>>
>>  struct wl12xx_vif {
>>       struct wl1271 *wl;
>> +     struct list_head list;
>
> I know we alredy call this kind of thing "list" struct wl1271 for the
> ARP stuff, but I prefer "node" so it's easier to follow when calling
> list_add and friends.  Mind changing?
>
i think "list" is the standard convention (e.g. see sta_info,
ieee80211_key, etc.) and more intuitive.

>
>> @@ -653,6 +656,9 @@ struct ieee80211_vif *wl12xx_wlvif_to_vif(struct wl12xx_vif *wlvif)
>>       return container_of((void *)wlvif, struct ieee80211_vif, drv_priv);
>>  }
>>
>> +#define wl12xx_for_each_wlvif(wl, wlvif) \
>> +             list_for_each_entry(wlvif, &wl->wlvif_list, list)
>> +
>
> This looks fine, but is it really necessary? I think the call to
> list_for_each_entry is clear enough already, isn't it?
>
i find it easier to understand this way.
also, future patches will add wl12xx_for_each_wlvif_sta and
wl12xx_for_each_wlvif_ap, so it even makes more sense to use this
macro.

Eliad.
