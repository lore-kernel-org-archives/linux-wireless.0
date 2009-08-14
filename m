Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:20791 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbZHNNCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 09:02:54 -0400
Received: by fg-out-1718.google.com with SMTP id e21so337368fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 06:02:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A855FEA.7030907@lwfinger.net>
References: <4A854FDF.5020208@gmail.com> <4A855FEA.7030907@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 14 Aug 2009 15:02:35 +0200
Message-ID: <69e28c910908140602x3873f30bt95b5c148305a5e1e@mail.gmail.com>
Subject: Re: [PATCH] b43: Add LP-PHY firmware loading support
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/14 Larry Finger <Larry.Finger@lwfinger.net>:
> Gábor Stefanik wrote:
>> Add support for loading LP-PHY firmware to b43_try_request_fw.
>>
>> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> ---
>> For anyone hoping that the channel switch patches will make their LP
>> card work - this is also definitely required.
>>
>> Mark, this doesn't fix your problem specifically, but it will be needed
>> after your problem is fixed.
>>
>> drivers/net/wireless/b43/main.c |   24 +++++++++++++++++++++++-
>> 1 files changed, 23 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/main.c
>> b/drivers/net/wireless/b43/main.c
>> index fbcbe4f..1e657fe 100644
>> --- a/drivers/net/wireless/b43/main.c
>> +++ b/drivers/net/wireless/b43/main.c
>> @@ -2062,8 +2062,12 @@ static int b43_try_request_fw(struct
>> b43_request_fw_context *ctx)
>>         filename = "ucode5";
>>     else if ((rev >= 11) && (rev <= 12))
>>         filename = "ucode11";
>> -    else if (rev >= 13)
>> +    else if (rev == 13)
>>         filename = "ucode13";
>> +    else if (rev == 14)
>> +        filename = "ucode14";
>> +    else if (rev >= 15)
>> +        filename = "ucode15";
>
> As shown by http://bcm-v4.sipsolutions.net/802.11/Init/Firmware, one
> should also have "ucode16".
>
>>     else
>>         goto err_no_ucode;
>>     err = b43_do_request_fw(ctx, filename, &fw->ucode);
>> @@ -2111,6 +2115,15 @@ static int b43_try_request_fw(struct
>> b43_request_fw_context *ctx)
>>         else
>>             goto err_no_initvals;
>>         break;
>> +    case B43_PHYTYPE_LP:
>> +        if (rev == 13)
>> +            filename = "lp0initvals13";
>> +        else if (rev == 14)
>> +            filename = "lp0initvals14";
>> +        else if (rev >= 15)
>> +            filename = "lp0initvals15";
>> +        else
>
> Same for lp0initvals16.
>
>> +            goto err_no_initvals;
>>     default:
>>         goto err_no_initvals;
>>     }
>> @@ -2145,6 +2158,15 @@ static int b43_try_request_fw(struct
>> b43_request_fw_context *ctx)
>>         else
>>             goto err_no_initvals;
>>         break;
>> +    case B43_PHYTYPE_LP:
>> +        if (rev == 13)
>> +            filename = "lp0bsinitvals13";
>> +        else if (rev == 14)
>> +            filename = "lp0bsinitvals14";
>> +        else if (rev >= 15)
>> +            filename = "lp0bsinitvals15";
>
> and lp0bsinitvals16.
>
>> +        else
>> +            goto err_no_initvals;
>>     default:
>>         goto err_no_initvals;
>>     }
>
> Larry
>

Is rev.16 firmware available anywhere?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
