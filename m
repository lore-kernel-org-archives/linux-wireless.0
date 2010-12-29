Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58568 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0L2VL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 16:11:59 -0500
Received: by gxk9 with SMTP id 9so1606737gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 13:11:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293614508.15791.0.camel@powerslave>
References: <1293557808-27068-1-git-send-email-arik@wizery.com>
 <1293557808-27068-15-git-send-email-arik@wizery.com> <1293614508.15791.0.camel@powerslave>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 29 Dec 2010 23:11:42 +0200
Message-ID: <AANLkTi=tTx=XZ0nFnTsds1F1X2saSYiVmgSxWL1zU-GY@mail.gmail.com>
Subject: Re: [PATCH v3 14/18] wl1271: AP mode - record TX configuration settings
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 29, 2010 at 11:21, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Tue, 2010-12-28 at 19:36 +0200, ext Arik Nemtsov wrote:
>>
>> diff --git a/drivers/net/wireless/wl12xx/main.c
>> b/drivers/net/wireless/wl12xx/main.c
>> index 3747d98..ea61ae7 100644
>> --- a/drivers/net/wireless/wl12xx/main.c
>> +++ b/drivers/net/wireless/wl12xx/main.c
>> @@ -1433,6 +1433,8 @@ static int wl1271_op_config(struct ieee80211_hw
>> *hw, u32 changed)
>>                 goto out;
>>         }
>>
>> +       is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
>> +
>>         ret = wl1271_ps_elp_wakeup(wl, false);
>>         if (ret < 0)
>>                 goto out;
>
> Did you forget to fix this one? As we discussed, this should be in
> 10/18.
>

Actually it was added in 10/18 (at the beginning of the function), but
I forgot to remove it from 14/18.
The correct place to set this is here after the mutex is held, so I've
moved this line to 10/18 (for good this time I hope).

Thanks,
Arik
