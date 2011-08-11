Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34721 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab1HKR5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 13:57:32 -0400
Received: by pzk37 with SMTP id 37so4037567pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 10:57:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E4408F6.2040606@broadcom.com>
References: <1313055255-3088-1-git-send-email-zajec5@gmail.com>
	<4E4408F6.2040606@broadcom.com>
Date: Thu, 11 Aug 2011 19:57:32 +0200
Message-ID: <CACna6rzwBEtujQEmBbq7sLA0bSEg7igE9KHCNF_f7LZTEt68Ww@mail.gmail.com> (sfid-20110811_195736_109810_7818DD72)
Subject: Re: [PATCH] bcma: implement BCM4331 workaround for external PA lines
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 11 sierpnia 2011 18:53 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 08/11/2011 11:34 AM, Rafał Miłecki wrote:
>>
>> We need to disable ext. PA lines for reading SPROM. It's disabled by
>> default, but this patch allows using bcma after loading wl, which leaves
>> workaround enabled.
>>
>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>> ---
>>  drivers/bcma/driver_chipcommon_pmu.c        |   20 +++++++++++++++++++-
>>  drivers/bcma/sprom.c                        |    6 ++++++
>>  include/linux/bcma/bcma_driver_chipcommon.h |   18 ++++++++++++++++++
>>  3 files changed, 43 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/bcma/driver_chipcommon_pmu.c
>> b/drivers/bcma/driver_chipcommon_pmu.c
>> index 5940c81..a3854ff 100644
>> --- a/drivers/bcma/driver_chipcommon_pmu.c
>> +++ b/drivers/bcma/driver_chipcommon_pmu.c
>> @@ -90,6 +90,24 @@ void bcma_pmu_swreg_init(struct bcma_drv_cc *cc)
>>        }
>>  }
>>
>> +/* Disable to allow reading SPROM. Don't know the adventages of enabling
>> it. */
>> +void bcma_chipco_bcm4331_exp_pa_lines_ctl(struct bcma_drv_cc *cc, bool
>> enable)
>
> Would 'ext_pa' iso 'exp_pa' be better here?

Of course, thanks for reviewing. Will submit V2.

-- 
Rafał
