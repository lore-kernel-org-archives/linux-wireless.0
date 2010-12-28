Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42281 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0L1RQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 12:16:36 -0500
Received: by ywl5 with SMTP id 5so3931416ywl.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 09:16:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293537823.24274.18.camel@chilepepper>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
 <1293028057-6212-16-git-send-email-arik@wizery.com> <1293537823.24274.18.camel@chilepepper>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 28 Dec 2010 19:16:17 +0200
Message-ID: <AANLkTikozSoq+PjM41pPuwjzg4YNByd3BdQ43=7dW4jr@mail.gmail.com>
Subject: Re: [PATCH v2 15/18] wl1271: AP mode - encryption support
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 28, 2010 at 14:03, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
>> Encryption key configuration is different for AP/STA modes.
>>
>> AP encryption keys are recorded when the BSS is not started. On BSS
>> start they are propagated to the AP (in wl1271_ap_init_hwenc).
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
>> index 0662b19..81ba75d 100644
>> --- a/drivers/net/wireless/wl12xx/tx.h
>> +++ b/drivers/net/wireless/wl12xx/tx.h
>> @@ -152,4 +152,8 @@ void wl1271_tx_flush(struct wl1271 *wl);
>>  u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
>>  u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set);
>>
>> +/* Functions from wl1271_main.c */
>> +
>> +int wl1271_set_default_wep_key(struct wl1271 *wl, u8 id);
>> +
>>  #endif
>
> Again, same thing.  Can we put this somewhere else?
>

Actually the WEP default key is used for TX, so we can put this in tx.c.

Regards,
Arik
