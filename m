Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:38069 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaCRQDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 12:03:46 -0400
MIME-Version: 1.0
In-Reply-To: <CANUX_P2Nj=Mv+DPuZvRrWxn74LSmW2X7_OvSbv=L733jNidc8A@mail.gmail.com>
References: <CANqatMD5-vD0m+YAsMqYRPNRKQrKSWthv=Gx+sRRO_Ouw7usZQ@mail.gmail.com>
 <CANUX_P15ryyg3RGqm5pW0oZKTptKHspW=4S76BpMg2GT0nGbUQ@mail.gmail.com>
 <CANqatMAgkVqQY3wX_MEj8vjZ2qeOuLFmef8ABtkKmv6j8hO7Dw@mail.gmail.com>
 <CANUX_P2+jN0Wa+G6ZjXGkbsxFgeTCb4AY9vJeJ4qp7y2nh3U7Q@mail.gmail.com>
 <CANqatMCGoS6M+ss4ezeAQi7PY7LPV6hfHC+CWtHM652rv5cmkg@mail.gmail.com>
 <CANUX_P2qUr7m2-K-i0FmXaimkgcs5bR8g9d+XZcBitNqR-PXUw@mail.gmail.com>
 <CANqatMDjzBfuzFYZLSp67YROpnYAqvZGe9pY2C5qTqxu0RnOMw@mail.gmail.com> <CANUX_P2Nj=Mv+DPuZvRrWxn74LSmW2X7_OvSbv=L733jNidc8A@mail.gmail.com>
From: Shuduo Sang <sangshuduo@gmail.com>
Date: Wed, 19 Mar 2014 00:03:05 +0800
Message-ID: <CANqatMDC7DjJE3kgD5f91UHaDGcjv51BKqFZquy7gR3k9BnjgA@mail.gmail.com> (sfid-20140318_170351_856066_1C110EA1)
Subject: Re: wifi driver or USB might leads suspend/resume failure on thinkpad
 X1 carbon
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-usb <linux-usb@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tedd <tedd.an@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 10, 2014 at 9:52 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Mon, Mar 10, 2014 at 3:20 PM, Shuduo Sang <sangshuduo@gmail.com> wrote:
>> On Mon, Mar 10, 2014 at 6:50 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On Mon, Mar 10, 2014 at 7:05 AM, Shuduo Sang <sangshuduo@gmail.com> wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> Sorry for cross posting. I'm suffering an issue my Thinkpad X1 Carbon
>>>>>>>> can't resume after suspend recently. I tried many ways including
>>>>>>>> latest vanilla kernel, latest stable 3.13 and 3.11 kernel but it still
>>>>>>>> happens. I found it will not happen when I turn off WIFI device or USB
>>>>>>>> 3.0 in BIOS. So I suspect something need fix in either wifi driver or
>>>>>>>> USB side. Since Windows 7 works good so I suppose no hardware issue.
>>>>>>>> Anyone has some ideas to fix it or debug it?
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Shuduo
>>>>>>>>
>>>>>>>
>>>>>>> If you disable WiFi only (without touching USB 3.0 in BIOS), it works?
>>>>>>> How do you disable WiFi? Rfkill or removing iwlwifi?
>>>>>>>
>>>>>>
>>>>>> I have disabled WIFI device in BIOS, then its suspend/resume works.
>>>>>>
>>>>>
>>>>> Do you have any logs to share?
>>>>> I supposed you tested 3.13.6 right?
>>>>
>>>> Attach dmesg output. If any other log you need, I can capture too.
>>>> Actually I tried 3.14-rc6, 3.13.6 and 3.11.10.
>>>
>>> This looks healthy.
>>>
>>>     Suspending console(s) (use no_console_suspend to debug)
>>>
>>> can you use no_console_suspend?
>>
>> Yes, this log is already output from the kernel I compile with
>> no_console_suspend.
>
> Hmm... weird...
> Don't know how we can debug this further then...

Update: The defect in BIOS be found finally.
