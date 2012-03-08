Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56190 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378Ab2CHR4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 12:56:36 -0500
Message-ID: <4F58F2D0.5060805@lwfinger.net> (sfid-20120308_185642_313437_5A5D4AEF)
Date: Thu, 08 Mar 2012 11:56:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: jerome huang <jerome.syno@gmail.com>
CC: "Xu, Andiry" <Andiry.Xu@amd.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: rt8192cu on USB3
References: <CAHaq0gKf+VE9T15J91rvyxbF8=rNCExTZfE-WcwHjUN1afjnTA@mail.gmail.com> <CAHaq0gLOPpDKazM0WPmkkOmJ1gR-vqOX9Q+J3nXArD5N0MgmMw@mail.gmail.com> <4F581AF8.4080001@lwfinger.net> <CAHaq0gKxw9Lir2bB__jNmmZPzbgq7Ky6v9Ps2RVexbnRjd8a2g@mail.gmail.com> <4F585BA9.6020903@amd.com> <2A76B9D36150BE4293842BC2FE8FF165016A31@SCYBEXDAG04.amd.com> <CAHaq0g+hXKdCaMm8dXiQhzqCsjAa0vihd2YE3gbw-xrMrxmOgw@mail.gmail.com> <CAHaq0gJRr5p2d=P_J9+NQ0=PqaCu6NLSwJ_LSjFn7HffkX-Odg@mail.gmail.com>
In-Reply-To: <CAHaq0gJRr5p2d=P_J9+NQ0=PqaCu6NLSwJ_LSjFn7HffkX-Odg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2012 05:26 AM, jerome huang wrote:
>
> I found a interesting thing.
>
> Here is my original test steps:
> 1. plugin 8192 =>  at this step, modules will be inserted
> 2. ifconfig wlan0 up =>  at this step, firmware will be uploaded
> 3. iwlist wlan0 scanning =>  check if wlan0 works
>
> The original problem occurs at last step,
> there is "always" no ap list result.
>
> And I found a way to make it work "always":
> 1. plugin 8192
> 2. ifconfig wlan0 up
> 3. ifconfig wlan0 down
> 4. ifconfig wlan0 up
> 5. iwlist wlan0 scanning
> If I up->down->up sequentially, (without scanning after first up),
> and then scanning(step 5),
> it works!
>
> Does this mean the firmware is not transfered or written correctly?

I did a bit of testing with debug level 4. For kernels 3.2 and older, the 
firmware file is read by the kernel when the driver is loaded using the 
synchronous method. I confirm that it is not loaded into the device until the 
interface is brought up. The upload mechanism is supposed to be waiting while 
the firmware is uploaded, but that may not be happening.

When you did the original 3-step process, was there any delay between steps 2 
and 3? Does anything change if you wait for 30 sec between steps 2 and 3?

with kernels 3.3 and later, there is a major change in the firmware loading in 
that an asynchronous method is used. The probe routine run when the driver is 
loaded places a firmware read request, but does not wait. The interface startup 
is delayed until the callback routine is entered. This change will not affect 
when the firmware is loaded into the device.

Larry
