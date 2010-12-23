Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40307 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab0LWLFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 06:05:21 -0500
Received: by gxk3 with SMTP id 3so1828364gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Dec 2010 03:05:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293049334.14423.1.camel@powerslave>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
 <1293028057-6212-2-git-send-email-arik@wizery.com> <1293049334.14423.1.camel@powerslave>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 23 Dec 2010 13:05:05 +0200
Message-ID: <AANLkTinYmAi1xGQ38s8s1J7Y148cd00tf8uAKU+F5NfX@mail.gmail.com>
Subject: Re: [PATCH v2 01/18] wl1271: Add AP related configuration to conf_drv_settings
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 22:22, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
>> Rate class configuration has been split up for AP and STA modes.
>> Template related configuration likewise separated.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>> @@ -153,6 +153,45 @@ static struct conf_drv_settings default_conf = {
>>                               .tx_op_limit = 1504,
>>                       },
>>               },
>> +             .ap_rc_conf                  = {
>> +                     [0] = {
>> +                             .enabled_rates = 0x1EFF,
>> +                             .short_retry_limit = 10,
>> +                             .long_retry_limit = 10,
>> +                             .aflags      = 0,
>> +                     },
>> +                     [1] = {
>> +                             .enabled_rates = 0x1EFF,
>> +                             .short_retry_limit = 10,
>> +                             .long_retry_limit = 10,
>> +                             .aflags      = 0,
>> +                     },
>> +                     [2] = {
>> +                             .enabled_rates = 0x1EFF,
>> +                             .short_retry_limit = 10,
>> +                             .long_retry_limit = 10,
>> +                             .aflags      = 0,
>> +                     },
>> +                     [3] = {
>> +                             .enabled_rates = 0x1EFF,
>> +                             .short_retry_limit = 10,
>> +                             .long_retry_limit = 10,
>> +                             .aflags      = 0,
>> +                     },
>> +             },
>> +             .ap_mgmt_conf = {
>> +                     .enabled_rates       = 0x7,
>> +                     .short_retry_limit   = 10,
>> +                     .long_retry_limit    = 10,
>> +                     .aflags              = 0,
>> +             },
>> +             .ap_bcst_conf = {
>> +                     .enabled_rates       = 0x1,
>> +                     .short_retry_limit   = 10,
>> +                     .long_retry_limit    = 10,
>> +                     .aflags              = 0,
>> +             },
>> +
>
> All the enabled_rates values here look quite magic.  Is there any way
> these could be changed to macros or something more descriptive?

These are simply bitmasks of enabled rates. I can change these to
definitions and add some explanation about the limitations (basically
the FW supports up to 12 rates).

>
> Also, how do you deal with the different basic rates used by 11bg and
> 11a?

Currently AP mode is not supported for 11a. Obviously we'd need
different rate configuration there. This is controlled by the NVS file
right now, but its a good idea to hard-code only 11bg support for
AP-mode. We expect users to have only one NVS file on the device, and
we do want 11a support for STA.

Also looking at the rate config part made me realize that
"basic_rate_set" is not updated where it should be in AP mode. I'll
fix this as well.

Regards,
Arik
