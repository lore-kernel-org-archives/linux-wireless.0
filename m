Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48026 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089Ab2CHL1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 06:27:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAHaq0g+hXKdCaMm8dXiQhzqCsjAa0vihd2YE3gbw-xrMrxmOgw@mail.gmail.com>
References: <CAHaq0gKf+VE9T15J91rvyxbF8=rNCExTZfE-WcwHjUN1afjnTA@mail.gmail.com>
	<CAHaq0gLOPpDKazM0WPmkkOmJ1gR-vqOX9Q+J3nXArD5N0MgmMw@mail.gmail.com>
	<4F581AF8.4080001@lwfinger.net>
	<CAHaq0gKxw9Lir2bB__jNmmZPzbgq7Ky6v9Ps2RVexbnRjd8a2g@mail.gmail.com>
	<4F585BA9.6020903@amd.com>
	<2A76B9D36150BE4293842BC2FE8FF165016A31@SCYBEXDAG04.amd.com>
	<CAHaq0g+hXKdCaMm8dXiQhzqCsjAa0vihd2YE3gbw-xrMrxmOgw@mail.gmail.com>
Date: Thu, 8 Mar 2012 19:26:58 +0800
Message-ID: <CAHaq0gJRr5p2d=P_J9+NQ0=PqaCu6NLSwJ_LSjFn7HffkX-Odg@mail.gmail.com> (sfid-20120308_122707_560024_EA961BDD)
Subject: Re: rt8192cu on USB3
From: jerome huang <jerome.syno@gmail.com>
To: "Xu, Andiry" <Andiry.Xu@amd.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 March 2012 18:32, jerome huang <jerome.syno@gmail.com> wrote:
> On 8 March 2012 15:23, Xu, Andiry <Andiry.Xu@amd.com> wrote:
>> I don't know why my email is mangled so I remove all the receivers.
>> Please reply the mail adding Larry, Sarah and USB list.
>>
>>> -----Original Message-----
>>> From: Andiry Xu [mailto:andiry.xu@amd.com]
>>> Sent: Thursday, March 08, 2012 3:12 PM
>>> To: jerome huang
>>> Cc: Larry Finger; linux-wireless@vger.kernel.org; Sarah Sharp; linux-
>>> usb@vger.kernel.org
>>> Subject: Re: rt8192cu on USB3
>>>
>>> On 03/08/2012 02:35 PM, jerome huang wrote:
>>> >
>>> > I also tried to slow down between each write during firmware upload,
>>> > and enlarge the ring size in xhci_endpoint_init(),
>>> > but it seems that the trbs in the ring are not processed and
>>> > the incoming trb is always queued till ring full.
>>> >
>>>
>>
>> This is interesting thing. How do you find out the trbs in the ring are
>> not processed? Do you see handle_tx_event() triggers and urbs are
>> givenback in the irq handler?
>>
>> There is a new version of ring expansion patchset:
>>
>> www.spinics.net/lists/linux-usb/msg59391.html
>>
>> But I'm not sure if it helps in your case. if the trbs are continuously
>> queued but without completion, ring expansion will loop until memory is
>> depleted.
>>
>> Thanks,
>> Andiry
>>
>>
>
> Hi all,
> I tried to print more information for firmware upload,
> and handle_tx_event is triggered and urbs are givenback.
>
> This time I found the first "no room on ep ring"
> is before "Loading firmware file" (line 176)
> and there is no error during firmware upload,
> after firmware upload completion,
> "no room on ep ring" appears continuously (line 264).
>
> So the problem is not in firmware upload,
> but in the other place after firmware upload?
>
> Please let me know if you need other debug messages.
>
> BR,
> Jerome

Hi all,

I found a interesting thing.

Here is my original test steps:
1. plugin 8192 => at this step, modules will be inserted
2. ifconfig wlan0 up => at this step, firmware will be uploaded
3. iwlist wlan0 scanning => check if wlan0 works

The original problem occurs at last step,
there is "always" no ap list result.

And I found a way to make it work "always":
1. plugin 8192
2. ifconfig wlan0 up
3. ifconfig wlan0 down
4. ifconfig wlan0 up
5. iwlist wlan0 scanning
If I up->down->up sequentially, (without scanning after first up),
and then scanning(step 5),
it works!

Does this mean the firmware is not transfered or written correctly?

BR,
Jerome
