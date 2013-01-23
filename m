Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:50961 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab3AWSDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 13:03:35 -0500
Received: by mail-bk0-f44.google.com with SMTP id j4so956722bkw.31
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 10:03:33 -0800 (PST)
References: <20130122164914.GB25134@localhost.localdomain> <2BB3EFC8-0B36-47DA-9FE2-13159E367F85@gmail.com> <50FF00C0.1010402@gmail.com> <20130122221935.GA2193@localhost.localdomain>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130122221935.GA2193@localhost.localdomain>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <B39E4F0F-E03F-4230-83BE-7C379A0BA90D@gmail.com> (sfid-20130123_190339_058186_4CC23777)
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: print chip and firmware version by default
Date: Wed, 23 Jan 2013 19:03:30 +0100
To: Stanislaw Gruszka <stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

Sent from my iPad

On 22 jan. 2013, at 23:19, Stanislaw Gruszka <stf_xl@wp.pl> wrote:

> On Tue, Jan 22, 2013 at 10:12:32PM +0100, Xose Vazquez Perez wrote:
>> On 01/22/2013 07:58 PM, Gertjan van Wingerde wrote:
>> 
>>> On 22 jan. 2013, at 17:49, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
>>> 
>>>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
>>>> Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>>>> ---
>>>> drivers/net/wireless/rt2x00/rt2x00.h    |    2 +-
>>>> drivers/net/wireless/rt2x00/rt2x00mac.c |    6 +++---
>>>> 2 files changed, 4 insertions(+), 4 deletions(-)
>>>> 
>>>> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
>>>> index 3e37c19..bef449c 100644
>>>> --- a/drivers/net/wireless/rt2x00/rt2x00.h
>>>> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
>>>> @@ -92,7 +92,7 @@
>>>> #define NOTICE(__dev, __msg, __args...) \
>>>>   DEBUG_PRINTK(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
>>>> #define INFO(__dev, __msg, __args...) \
>>>> -    DEBUG_PRINTK(__dev, KERN_INFO, "Info", __msg, ##__args)
>>>> +    DEBUG_PRINTK_MSG(__dev, KERN_INFO, "Info", __msg, ##__args)
>>>> #define DEBUG(__dev, __msg, __args...) \
>>>>   DEBUG_PRINTK(__dev, KERN_DEBUG, "Debug", __msg, ##__args)
>>>> #define EEPROM(__dev, __msg, __args...) \
>> 
>>> I think this change is good, but we should also change WARNING and
>>> NOTICE. Otherwise they won't be displayed if CONFIG_RT2X00_DEBUG is
>>> disabled, but INFO will, which would be strange.
> 
> We have those "TX status report missed" messages which spam logs,
> I think we should move them to DEBUG level then.
> 
> NOTICE is only used in suspend/resume, it should be DEBUG too and NOTICE
> macro could be removed.
> 
>> I believe this patch is so useful and trivial enough to be included,
>> as is, in the next 3.8-rc .
>> 
>> The next steps can be done for 3.9
> 
> If Gertjan will be so kind and ACK this patch, I'll post further
> changes as incremental patch :-)

As I mentioned to Xose already yesterday, I think this is only appropriate for -next, so we can do this properly. I can see this being handled as a series of patches, which first change the loglevels of the existing log lines, then remove NOTICE, and them change the macro of WARNING to not be covered by CONFIG_RT2X00_DEBUG.

---
Gertjan