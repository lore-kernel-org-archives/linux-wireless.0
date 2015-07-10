Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:36420 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbbGJKFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 06:05:43 -0400
Received: by iecvh10 with SMTP id vh10so193638634iec.3
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2015 03:05:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559F7B31.7000907@atmel.com>
References: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com>
 <1436507759-4546-2-git-send-email-johnny.kim@atmel.com> <CAGRGNgX4xctq0XmEt-g3fnLG_PyUj6kHxEf1=hd41tjxcWEnCw@mail.gmail.com>
 <559F7B31.7000907@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 10 Jul 2015 20:05:23 +1000
Message-ID: <CAGRGNgU3srgcWsmr6ofXbRDLAguVaHvX6v2NOpRAObMgbDnZfw@mail.gmail.com> (sfid-20150710_120546_914625_57AFD91A)
Subject: Re: [PATCH 1/3] staging: wilc1000: wilc_wlan_cfg_commit(): replace
 integer with pointer
To: Johnny Kim <johnny.kim@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Chris Park <chris.park@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>, tony.cho@atmel.com,
	Nicolas.FERRE@atmel.com, Dean Lee <dean.lee@atmel.com>,
	austin.shin@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johnny,

On Fri, Jul 10, 2015 at 5:58 PM, Johnny Kim <johnny.kim@atmel.com> wrote:
>
> On 2015년 07월 10일 15:20, Julian Calaby wrote:
>>
>> Hi Johnny,
>>
>> On Fri, Jul 10, 2015 at 3:55 PM, Johnny Kim <johnny.kim@atmel.com> wrote:
>>>
>>> A argument of wilc_wlan_cfg_commit() is address of structure.
>>> But because the size is restricted to 32bit, it is not correct
>>> for 64bit machine.
>>>
>>> So, this changes the interger value to obvious structure pointer.
>>>
>>> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
>>> ---
>>>   drivers/staging/wilc1000/wilc_wlan.c | 8 ++++----
>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/staging/wilc1000/wilc_wlan.c
>>> b/drivers/staging/wilc1000/wilc_wlan.c
>>> index def72fd..d32e45e 100644
>>> --- a/drivers/staging/wilc1000/wilc_wlan.c
>>> +++ b/drivers/staging/wilc1000/wilc_wlan.c
>>> @@ -1862,13 +1862,13 @@ static void wilc_wlan_cleanup(void)
>>>
>>>   }
>>>
>>> -static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
>>> +static int wilc_wlan_cfg_commit(int type, tstrWILC_WFIDrv *drvHandler)
>>>   {
>>>          wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
>>>          wilc_cfg_frame_t *cfg = &p->cfg_frame;
>>>          int total_len = p->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
>>>          int seq_no = p->cfg_seq_no % 256;
>>> -       int driver_handler = (u32)drvHandler;
>>> +       uintptr_t driver_handler = (uintptr_t)drvHandler;
>>
>> Er, why not just remove this variable and use drvHandler directly?
>
> A control packet with the address value is sent to chipset.
> Namely, it is used to distinguish various packet via the address finally.

Yes, and why does this require another variable?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
