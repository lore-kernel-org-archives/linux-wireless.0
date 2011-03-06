Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f51.google.com ([74.125.83.51]:36460 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1CFPiW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 10:38:22 -0500
Received: by gwb15 with SMTP id 15so2073019gwb.10
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 07:38:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik8TYGmg3hekoN546ToRDxi5HJeoq75R29WfSxt@mail.gmail.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
 <1299421940-26292-15-git-send-email-shahar_levi@ti.com> <AANLkTik8TYGmg3hekoN546ToRDxi5HJeoq75R29WfSxt@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 6 Mar 2011 17:38:07 +0200
Message-ID: <AANLkTi=0BLW-CC1TeyT35ZtfaZnBav1LxczRbQ0KmDYj@mail.gmail.com>
Subject: Re: [PATCH 14/15] wl12xx: 1281/1283 support - disable TX aggregation
 for AP mode in wl128x
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ relooping the list ]

On Sun, Mar 6, 2011 at 17:36, Arik Nemtsov <arik@wizery.com> wrote:
>
>
> On Sun, Mar 6, 2011 at 16:32, Shahar Levi <shahar_levi@ti.com> wrote:
>>
>> From: Arik Nemtsov <arik@wizery.com>
>>
>> This is a workaround for the HW bug we're encountering when operating
>> with 48Mhz SDIO clocks. This workaround is currently employed by the MCP
>> driver as well.
>>
>> This is not healthy for CPU usage, and UDP TX seems hurt by this change.
>> TCP RX/TX seems unchanged from Trio or the 1-spare-block FW variant.
>>
>> With this workaround we get a working AP on Blaze.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>>  drivers/net/wireless/wl12xx/tx.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
>> index 9c0ec06..831248e 100644
>> --- a/drivers/net/wireless/wl12xx/tx.c
>> +++ b/drivers/net/wireless/wl12xx/tx.c
>> @@ -568,6 +568,11 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
>>                }
>>                buf_offset += ret;
>>                wl->tx_packets_count++;
>> +
>> +               /* Disable packet aggregation for 1283 AP-mode */
>> +               if (wl->chip.id == CHIP_ID_1283_PG20 &&
>> +                   wl->bss_type == BSS_TYPE_AP_BSS)
>> +                       break;
>>        }
>>
>>  out_ack:
>> --
>> 1.7.0.4
>>
>
> This bug has already been resolved. Luca - please disregard this workaround.
> Regards,
> Arik
