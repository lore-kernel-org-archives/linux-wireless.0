Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65225 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754196Ab2CID3A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 22:29:00 -0500
MIME-Version: 1.0
In-Reply-To: <4F58F2D0.5060805@lwfinger.net>
References: <CAHaq0gKf+VE9T15J91rvyxbF8=rNCExTZfE-WcwHjUN1afjnTA@mail.gmail.com>
	<CAHaq0gLOPpDKazM0WPmkkOmJ1gR-vqOX9Q+J3nXArD5N0MgmMw@mail.gmail.com>
	<4F581AF8.4080001@lwfinger.net>
	<CAHaq0gKxw9Lir2bB__jNmmZPzbgq7Ky6v9Ps2RVexbnRjd8a2g@mail.gmail.com>
	<4F585BA9.6020903@amd.com>
	<2A76B9D36150BE4293842BC2FE8FF165016A31@SCYBEXDAG04.amd.com>
	<CAHaq0g+hXKdCaMm8dXiQhzqCsjAa0vihd2YE3gbw-xrMrxmOgw@mail.gmail.com>
	<CAHaq0gJRr5p2d=P_J9+NQ0=PqaCu6NLSwJ_LSjFn7HffkX-Odg@mail.gmail.com>
	<4F58F2D0.5060805@lwfinger.net>
Date: Fri, 9 Mar 2012 11:28:59 +0800
Message-ID: <CAHaq0gKSSgYX19BH92Pg+gXifSEmjvubc_nd5brO8QeLCpr1yA@mail.gmail.com> (sfid-20120309_042906_216696_EE6BCAD3)
Subject: Re: rt8192cu on USB3
From: jerome huang <jerome.syno@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Xu, Andiry" <Andiry.Xu@amd.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 March 2012 01:56, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 03/08/2012 05:26 AM, jerome huang wrote:
>>
>>
>> I found a interesting thing.
>>
>> Here is my original test steps:
>> 1. plugin 8192 =>  at this step, modules will be inserted
>> 2. ifconfig wlan0 up =>  at this step, firmware will be uploaded
>> 3. iwlist wlan0 scanning =>  check if wlan0 works
>>
>> The original problem occurs at last step,
>> there is "always" no ap list result.
>>
>> And I found a way to make it work "always":
>> 1. plugin 8192
>> 2. ifconfig wlan0 up
>> 3. ifconfig wlan0 down
>> 4. ifconfig wlan0 up
>> 5. iwlist wlan0 scanning
>> If I up->down->up sequentially, (without scanning after first up),
>> and then scanning(step 5),
>> it works!
>>
>> Does this mean the firmware is not transfered or written correctly?
>
>
> I did a bit of testing with debug level 4. For kernels 3.2 and older, the
> firmware file is read by the kernel when the driver is loaded using the
> synchronous method. I confirm that it is not loaded into the device until
> the interface is brought up. The upload mechanism is supposed to be waiting
> while the firmware is uploaded, but that may not be happening.
>
> When you did the original 3-step process, was there any delay between steps
> 2 and 3? Does anything change if you wait for 30 sec between steps 2 and 3?
>
> with kernels 3.3 and later, there is a major change in the firmware loading
> in that an asynchronous method is used. The probe routine run when the
> driver is loaded places a firmware read request, but does not wait. The
> interface startup is delayed until the callback routine is entered. This
> change will not affect when the firmware is loaded into the device.
>
> Larry

It still got no any result if I wait for 30 sec (or longer) between
(original) step 2 and 3.
I double confirmed that it always does not work for steps: plugin ->
up -> scanning
and always works for steps: plugin -> up -> down -> up -> scanning.

And sometimes it works for next down->up->scanning, sometimes it doesn't.

Is the change of firmware loading in kernel 3.3 made by rtlwifi only,
or ring expansion in xhci is also necessary?

BR,
Jerome
