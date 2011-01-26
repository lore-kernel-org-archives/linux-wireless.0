Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36783 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1AZUEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 15:04:53 -0500
Received: by yxt3 with SMTP id 3so278970yxt.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 12:04:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296050470.2039.47.camel@pimenta>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
 <1295156534-4178-3-git-send-email-arik@wizery.com> <1296050470.2039.47.camel@pimenta>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Jan 2011 22:04:37 +0200
Message-ID: <AANLkTi=sLYCiBSjv-c1L86AJ7UtDS6+p+Pax36bLJLFb@mail.gmail.com>
Subject: Re: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta connection
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 16:01, Luciano Coelho <coelho@ti.com> wrote:
> On Sun, 2011-01-16 at 06:42 +0100, Arik Nemtsov wrote:
>> If a sta starts transmitting immediately after authentication, sometimes
>> the FW deauthenticates it. Fix this by marking the sta "in-connection"
>> in FW before sending the autentication response.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> Looks good.  So you don't need to remove the STA from the inconnection
> list later? Does the firmware remove it automatically?

Yes. There's a timeout period after which the STA is removed.

>
>
>> diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
>> index fdec4a3..d3ba27c 100644
>> --- a/drivers/net/wireless/wl12xx/tx.c
>> +++ b/drivers/net/wireless/wl12xx/tx.c
>> @@ -70,6 +70,22 @@ static void wl1271_free_tx_id(struct wl1271 *wl, int id)
>>       }
>>  }
>>
>> +static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
>> +                                           struct sk_buff *skb)
>
> This indentation seems wrong.

will fix.

>
>
>> +     /*
>> +      * add the station to the known list before broadcasting the
>> +      * authentication response. this way it won't get de-authed by FW
>> +      * when transmitting too soon.
>> +      */
>
> Broadcasting the auth response? Isn't it unicast?

I meant "transmitting". Thanks.

>
>
>> @@ -238,6 +254,9 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
>>       if (ret < 0)
>>               return ret;
>>
>> +     if (wl->bss_type == BSS_TYPE_AP_BSS)
>> +             wl1271_tx_ap_update_inconnection_sta(wl, skb);
>> +
>>       wl1271_tx_fill_hdr(wl, skb, extra, info);
>
> Isn't there any other place where you can put this? Doesn't it add too
> much overhead if you do it for every TX frame?

At this stage the STA has not been officially added yet, so this is
just a packet. In fact it won't be added unless authenticated. When
the STA is added its too late. If we failed to mark it in-connection,
sometimes the FW will disconnect it.

Performance wise - its just another "compare + jmp" statement
basically (checking the packet header). Didn't see any effect on
throughput.

Regards,
Arik
