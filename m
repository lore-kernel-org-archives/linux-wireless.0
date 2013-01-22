Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:48895 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3AVVMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 16:12:38 -0500
Received: by mail-bk0-f42.google.com with SMTP id ji2so4034772bkc.29
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2013 13:12:37 -0800 (PST)
Message-ID: <50FF00C0.1010402@gmail.com> (sfid-20130122_221242_706524_A513D374)
Date: Tue, 22 Jan 2013 22:12:32 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Stanislaw Gruszka <stf_xl@wp.pl>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: print chip and firmware version by default
References: <20130122164914.GB25134@localhost.localdomain> <2BB3EFC8-0B36-47DA-9FE2-13159E367F85@gmail.com>
In-Reply-To: <2BB3EFC8-0B36-47DA-9FE2-13159E367F85@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/22/2013 07:58 PM, Gertjan van Wingerde wrote:

> On 22 jan. 2013, at 17:49, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> 
>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
>> Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>> drivers/net/wireless/rt2x00/rt2x00.h    |    2 +-
>> drivers/net/wireless/rt2x00/rt2x00mac.c |    6 +++---
>> 2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
>> index 3e37c19..bef449c 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00.h
>> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
>> @@ -92,7 +92,7 @@
>> #define NOTICE(__dev, __msg, __args...) \
>>    DEBUG_PRINTK(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
>> #define INFO(__dev, __msg, __args...) \
>> -    DEBUG_PRINTK(__dev, KERN_INFO, "Info", __msg, ##__args)
>> +    DEBUG_PRINTK_MSG(__dev, KERN_INFO, "Info", __msg, ##__args)
>> #define DEBUG(__dev, __msg, __args...) \
>>    DEBUG_PRINTK(__dev, KERN_DEBUG, "Debug", __msg, ##__args)
>> #define EEPROM(__dev, __msg, __args...) \
> 

> I think this change is good, but we should also change WARNING and
> NOTICE. Otherwise they won't be displayed if CONFIG_RT2X00_DEBUG is
> disabled, but INFO will, which would be strange.

I believe this patch is so useful and trivial enough to be included,
as is, in the next 3.8-rc .

The next steps can be done for 3.9
