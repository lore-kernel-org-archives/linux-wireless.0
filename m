Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46477 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab2DKNU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 09:20:26 -0400
Received: by bkcik5 with SMTP id ik5so653925bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 06:20:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109141900.00624.chunkeey@googlemail.com>
References: <CAEh_CyWdC+-mV+YhmoxS6dubWVN10utDim+GWmDLYCX9K9AkkQ@mail.gmail.com>
	<201109141150.30247.chunkeey@googlemail.com>
	<CAEh_CyWovAnrF1N0h-iJn72yFUX5e_E4TbEhDuDgbqfoxYCs-Q@mail.gmail.com>
	<201109141900.00624.chunkeey@googlemail.com>
Date: Wed, 11 Apr 2012 09:20:24 -0400
Message-ID: <CAEh_CyUjaQ5vx99EmRp-DM+rzAjdSWheiLP73FAyRTh+gdfVUA@mail.gmail.com> (sfid-20120411_152031_066347_8C6030C2)
Subject: Re: Carl9170 Firmware
From: J Igrap <jigrap.code@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 14, 2011 at 1:00 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Wednesday, September 14, 2011 03:09:14 PM J Igrap wrote:
>> On Wed, Sep 14, 2011 at 5:50 AM, Christian Lamparter
>>> On Tuesday, September 13, 2011 11:18:23 PM J Igrap wrote:
>>>> While using the past days the carl9170 firmware with a USB card under a
>>>> linux guest running different kernel and driver versions I kept running into
>>>> the issue of a usb disconnect when the card was put under load:
>>> linux guest? You are not using carl9170 in a VM, are you?
>>>
>> It is in a VM. I was working on a VM for ease of debugging the issue.
> So, I presume you have already tried running the driver natively
> and it fails in a similar fashion, right? [I just want to rule out
> a bug in the VM layers]
>

Yes, it appears to fail in slow/older physicals too.


>>>>  usb 1-1: no command feedback received (-110).
>>>>  carl9170 cmd: 08 01 00 00 f0 36 1c 00 00 24 00 00              .....6...$..
>>>>  usb 1-1: restart device (6)
>>>>
>>>> No matter what kernel driver/firmware I tried I will still get it. I decided
>>>> to look into it a bit more and I narrowed it down to be a firmware issue
>>>> with the following code snippet:
>>> Or it could be a problem with the USB PHY. However, the driver
>>> seems to be able to handle the situation and restarts the device
>>> accordingly.
>>>
>> I tried with several physical devices and they all seemed to have the
>> same behavior. The device does restart however you lose connectivity
>> and state of what you were doing.
> Any transmission protocol should be able to handle loss of connectivity.
> Furthermore all connection managers [wpa_supplicant, NetworkManager, wicd]
> will automatically reestablish the link if the device was put out by a
> catastrophic failure.
>
>>>> void handle_cmd(struct carl9170_rsp *resp) in src/cmd.c
>>>>
>>>>         case CARL9170_CMD_WREG:
>>>> esp->hdr.len = 0;
>>>>                 for (i = 0; i < (cmd->hdr.len / 8); i++)
>>>>                         set(cmd->wreg.regs[i].addr, cmd->wreg.regs[i].val);
>>>>                 break;
>>>>
>>>> That code appears to handle event 1 which is a write into a register. In
>>>> some cases that write appeared to cause a failure and a reset into the card.
>>>> I added a simple delay loop before the switch statement and that seemed to
>>>> fix the issue and I don't lose the card anymore even under a lot of load.
>>>> Obviously that's not a real fix and something else more reliable needs to be
>>>> in place.
>>> Any idea what this "something" else might be?
>>
>> I'm not very familiar with how USB works, maybe someone with more
>> experience can shed some light here? It seems to me that the event
>> handling needs to be slowed down a little or add some kind of
>> verification.
> the usb protocol already incorporates some verification
> http://www.beyondlogic.org/usbnutshell/usb3.shtml
>
> furthermore, the driver counts each command frame, therefore it can
> detect whenever a frame was lost.


It does detect it and restarts the device, however when running under
VMware or slower physicals it gets in the way since the device resets
very often.
I tried build various firmware's as an experiment and I noticed that
the higher I set the Max Frame Length the more resistant it becomes.
The script I wrote basically sends
a beacon packet multiple times in monitor mode and has a counter of
how many packets went through before the card resets. Any ideas what
could be causing this?




>
> Regards,
>        Chr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


On Wed, Sep 14, 2011 at 1:00 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Wednesday, September 14, 2011 03:09:14 PM J Igrap wrote:
>> On Wed, Sep 14, 2011 at 5:50 AM, Christian Lamparter
>>> On Tuesday, September 13, 2011 11:18:23 PM J Igrap wrote:
>>>> While using the past days the carl9170 firmware with a USB card under a
>>>> linux guest running different kernel and driver versions I kept running into
>>>> the issue of a usb disconnect when the card was put under load:
>>> linux guest? You are not using carl9170 in a VM, are you?
>>>
>> It is in a VM. I was working on a VM for ease of debugging the issue.
> So, I presume you have already tried running the driver natively
> and it fails in a similar fashion, right? [I just want to rule out
> a bug in the VM layers]
>
>>>>  usb 1-1: no command feedback received (-110).
>>>>  carl9170 cmd: 08 01 00 00 f0 36 1c 00 00 24 00 00              .....6...$..
>>>>  usb 1-1: restart device (6)
>>>>
>>>> No matter what kernel driver/firmware I tried I will still get it. I decided
>>>> to look into it a bit more and I narrowed it down to be a firmware issue
>>>> with the following code snippet:
>>> Or it could be a problem with the USB PHY. However, the driver
>>> seems to be able to handle the situation and restarts the device
>>> accordingly.
>>>
>> I tried with several physical devices and they all seemed to have the
>> same behavior. The device does restart however you lose connectivity
>> and state of what you were doing.
> Any transmission protocol should be able to handle loss of connectivity.
> Furthermore all connection managers [wpa_supplicant, NetworkManager, wicd]
> will automatically reestablish the link if the device was put out by a
> catastrophic failure.
>
>>>> void handle_cmd(struct carl9170_rsp *resp) in src/cmd.c
>>>>
>>>>         case CARL9170_CMD_WREG:
>>>> esp->hdr.len = 0;
>>>>                 for (i = 0; i < (cmd->hdr.len / 8); i++)
>>>>                         set(cmd->wreg.regs[i].addr, cmd->wreg.regs[i].val);
>>>>                 break;
>>>>
>>>> That code appears to handle event 1 which is a write into a register. In
>>>> some cases that write appeared to cause a failure and a reset into the card.
>>>> I added a simple delay loop before the switch statement and that seemed to
>>>> fix the issue and I don't lose the card anymore even under a lot of load.
>>>> Obviously that's not a real fix and something else more reliable needs to be
>>>> in place.
>>> Any idea what this "something" else might be?
>>
>> I'm not very familiar with how USB works, maybe someone with more
>> experience can shed some light here? It seems to me that the event
>> handling needs to be slowed down a little or add some kind of
>> verification.
> the usb protocol already incorporates some verification
> http://www.beyondlogic.org/usbnutshell/usb3.shtml
>
> furthermore, the driver counts each command frame, therefore it can
> detect whenever a frame was lost.
>
> Regards,
>        Chr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
