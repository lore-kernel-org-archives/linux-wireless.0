Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53867 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1DZIjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 04:39:44 -0400
Received: by bwz15 with SMTP id 15so317828bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 01:39:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303800793.2336.25.camel@cumari>
References: <1302774475-2977-1-git-send-email-eliad@wizery.com>
	<1303800793.2336.25.camel@cumari>
Date: Tue, 26 Apr 2011 11:39:42 +0300
Message-ID: <BANLkTinN2jZdqeCPi6R+tCoF=318UJ_qyQ@mail.gmail.com> (sfid-20110426_103948_315276_6104690D)
Subject: Re: [PATCH V2 1/2] wl12xx: consider encryption when configuring auto
 arp template
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Luca,

On Tue, Apr 26, 2011 at 9:53 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Thu, 2011-04-14 at 12:47 +0300, Eliad Peller wrote:
>> When configuring the arp response template, and encryption is enabled,
>> we should add some space and set the protected flag bit in the fc.
>>
>> In order to track the encryption type, set wl->encryption_type when
>> setting an encryption key, and reconfigure the arp response.
>> Clear this field on wl1271_join, as keys have to be re-configured
>> anyway after a join command.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> A couple of style comments.
> [...]
>
>> +     skb_reserve(skb, sizeof(*hdr) + 8);
>
> What's 8? Maybe it would be better to make it clear with something like
> WL1271_EXTRA_SPACE_MAX?
>
sure.

>
>> @@ -771,12 +773,41 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr)
>>       arp_hdr->ar_op = cpu_to_be16(ARPOP_REPLY);
>>
>>       /* arp payload */
>> -     memcpy(tmpl.sender_hw, wl->vif->addr, ETH_ALEN);
>> -     tmpl.sender_ip = ip_addr;
>> +     memcpy(tmpl->sender_hw, wl->vif->addr, ETH_ALEN);
>> +     tmpl->sender_ip = ip_addr;
>> +
>> +     /* encryption space */
>> +     switch (wl->encryption_type) {
>> +     case KEY_TKIP:
>> +             extra = WL1271_TKIP_IV_SPACE;
>> +             break;
>> +     case KEY_AES:
>> +             extra = 8;
>> +             break;
>> +     }
>
> It would be nicer to have WL1271_EXTRA_SPACE_AES here instead.  And
> maybe rename the WL1271_TKIP_IV_SPACE to WL1271_EXTRA_SPACE_TKIP, to
> make it consistent and clearer?
>
WL1271_TKIP_IV_SPACE is already being used in tx.c.
It's a bit tricky, as while we use the WL1271_TKIP_IV_SPACE (or
WL1271_EXTRA_SPACE_TKIP) in our tx path, we won't use
WL1271_EXTRA_SPACE_AES in the tx path, because we set the
IEEE80211_KEY_FLAG_GENERATE_IV for the key.
anyway, i'll just add it :)

> Maybe we should also complete the switch and explicitly set extra to
> zero for KEY_NONE, KEY_WEP, KEY_GEM and default?
>
>
>> @@ -2734,6 +2748,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
>>
>>               if (bss_conf->arp_addr_cnt == 1 &&
>>                   bss_conf->arp_filter_enabled) {
>> +                     wl->ip_addr = addr;
>>                       /*
>>                        * The template should have been configured only upon
>>                        * association. however, it seems that the correct ip
>> @@ -2749,8 +2764,10 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
>>                       ret = wl1271_acx_arp_ip_filter(wl,
>>                               ACX_ARP_FILTER_ARP_FILTERING,
>>                               addr);
>> -             } else
>> +             } else {
>> +                     wl->ip_addr = 0;
>>                       ret = wl1271_acx_arp_ip_filter(wl, 0, addr);
>> +             }
>
> This is not important at all, but maybe it's a bit cleaner: you could
> remove the addr argument in wl1271_acx_arp_ip_filter() and always use
> wl->ip_addr instead? You could then also get rid of the local addr here.
>
in fact, since we are going toward multi-role fw, i do try to avoid
using the global wl struct as much as possible.
anyway, i didn't change this function, so i don't think it's the right
patch to change it.
(we should probably change a lot of functions after we'll have a
per-interface data)

thanks for the review,
Eliad.
