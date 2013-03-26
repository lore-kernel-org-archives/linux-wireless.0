Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:36856 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964792Ab3CZOzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 10:55:45 -0400
Message-ID: <5151B106.6020800@dpets.co.uk> (sfid-20130326_155551_432404_472ED8EB)
Date: Tue, 26 Mar 2013 14:30:30 +0000
From: John Talbut <jt@dpets.co.uk>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: brcmsmac in kernel driver on a Samsung NC110
References: <51514F1B.1080207@dpets.co.uk> <5151639F.4010700@broadcom.com> <51516BC2.5010004@dpets.co.uk> <515173A4.7030607@broadcom.com> <515179C5.50406@dpets.co.uk> <51517E28.5000303@broadcom.com> <515182C6.5030305@dpets.co.uk> <51518682.7060503@broadcom.com> <515189C6.7070003@dpets.co.uk> <51518E14.3050500@broadcom.com>
In-Reply-To: <51518E14.3050500@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/03/13 12:01, Arend van Spriel wrote:
> On 03/26/2013 12:43 PM, John Talbut wrote:
>> On 26/03/13 11:29, Arend van Spriel wrote:
>>> On 03/26/2013 12:13 PM, John Talbut wrote:
>>>>
>>>> On 26/03/13 10:53, Arend van Spriel wrote:
>>>>> On 03/26/2013 11:34 AM, John Talbut wrote:
>>>>>> Kernel log attached.
>>>>>>
>>>>>
>>>>> Now this is weird. I do not see any BCMA log messages. Can you give
>>>>> output of following command:
>>>>>
>>>>> $ lspci -n -s 1:0.0
>>>>
>>>> 01:00.0 0280: 14e4:4357 (rev 01)
>>>
>>> Ok, no problem there.
>>>
>>> digging further in sysfs. Can you execute the following commands:
>>>
>>> if it exists:
>>> $ ls /sys/bus/bcma
>>> $ ls /sys/bus/bcma/devices
>>> $ ls /sys/bus/bcma/drivers
>>>
>>> if it exists also following:
>>> $ ls -l /sys/bus/bcma/drivers/brcmsmac
>>
>> root@johnwtnc110:/usr/src/linux-source-3.8# ls /sys/bus/bcma
>> devices  drivers  drivers_autoprobe  drivers_probe  uevent
>> root@johnwtnc110:/usr/src/linux-source-3.8# ls /sys/bus/bcma/devices
> 
> The fact that there are no devices detected under bcma is suspicious.
> Adding bcma developer to the list. Maybe he knows about issues when
> having bcma compiled in kernel image.
> 
> Regards,
> Arend

I have just noticed that with a previous version of the kernel which I
had compiled with
# CONFIG_BCMA is not set

there are references to brcmsmac in the kernel log.  It complains about
failing to find the firmware, though.

Regards
John
