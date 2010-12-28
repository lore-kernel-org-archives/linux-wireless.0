Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50099 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab0L1Lhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 06:37:43 -0500
Received: by ywl5 with SMTP id 5so3837514ywl.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 03:37:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293536140.24274.16.camel@chilepepper>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
 <1293028057-6212-15-git-send-email-arik@wizery.com> <1293536140.24274.16.camel@chilepepper>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 28 Dec 2010 13:37:27 +0200
Message-ID: <AANLkTi=e3wugdns_VDarSxEn_9Cj=1evW0N2SpTOprtP@mail.gmail.com>
Subject: Re: [PATCH v2 14/18] wl1271: AP mode - record TX configuration settings
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 28, 2010 at 13:35, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
>> Record TX configuration settings in the "conf" member of our global
>> structure (struct wl1271) if conf_tx is called when the firmware is
>> not loaded.
>>
>> Later on when the firmware is loaded, we apply the tx conf as part of
>> the init sequence.
>>
>> Important for AP mode since conf_tx is called before add_interface
>> (where the firmware is initialized).
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
>> index 3cc4f79..71a67f1 100644
>> --- a/drivers/net/wireless/wl12xx/main.c
>> +++ b/drivers/net/wireless/wl12xx/main.c
>> @@ -1462,6 +1462,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
>>               goto out;
>>       }
>>
>> +     is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
>> +
>>       ret = wl1271_ps_elp_wakeup(wl, false);
>>       if (ret < 0)
>>               goto out;
>
> This is cross-patch and should be in 10/18.

You're right. Actually fixed this already.

Regards,
Arik
