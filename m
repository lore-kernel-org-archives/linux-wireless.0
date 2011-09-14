Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65330 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159Ab1INRAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 13:00:14 -0400
Received: by fxe4 with SMTP id 4so1928849fxe.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 10:00:13 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: J Igrap <jigrap.code@gmail.com>
Subject: Re: Carl9170 Firmware
Date: Wed, 14 Sep 2011 19:00:00 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAEh_CyWdC+-mV+YhmoxS6dubWVN10utDim+GWmDLYCX9K9AkkQ@mail.gmail.com> <201109141150.30247.chunkeey@googlemail.com> <CAEh_CyWovAnrF1N0h-iJn72yFUX5e_E4TbEhDuDgbqfoxYCs-Q@mail.gmail.com>
In-Reply-To: <CAEh_CyWovAnrF1N0h-iJn72yFUX5e_E4TbEhDuDgbqfoxYCs-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109141900.00624.chunkeey@googlemail.com> (sfid-20110914_190045_557375_56345777)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, September 14, 2011 03:09:14 PM J Igrap wrote:
> On Wed, Sep 14, 2011 at 5:50 AM, Christian Lamparter
>> On Tuesday, September 13, 2011 11:18:23 PM J Igrap wrote:
>>> While using the past days the carl9170 firmware with a USB card under a
>>> linux guest running different kernel and driver versions I kept running into
>>> the issue of a usb disconnect when the card was put under load:
>> linux guest? You are not using carl9170 in a VM, are you?
>>
> It is in a VM. I was working on a VM for ease of debugging the issue.
So, I presume you have already tried running the driver natively
and it fails in a similar fashion, right? [I just want to rule out
a bug in the VM layers]

>>>  usb 1-1: no command feedback received (-110).
>>>  carl9170 cmd: 08 01 00 00 f0 36 1c 00 00 24 00 00              .....6...$..
>>>  usb 1-1: restart device (6)
>>>
>>> No matter what kernel driver/firmware I tried I will still get it. I decided
>>> to look into it a bit more and I narrowed it down to be a firmware issue
>>> with the following code snippet:
>> Or it could be a problem with the USB PHY. However, the driver
>> seems to be able to handle the situation and restarts the device
>> accordingly.
>> 
> I tried with several physical devices and they all seemed to have the
> same behavior. The device does restart however you lose connectivity
> and state of what you were doing.
Any transmission protocol should be able to handle loss of connectivity.
Furthermore all connection managers [wpa_supplicant, NetworkManager, wicd]
will automatically reestablish the link if the device was put out by a
catastrophic failure.

>>> void handle_cmd(struct carl9170_rsp *resp) in src/cmd.c
>>>
>>>         case CARL9170_CMD_WREG:
>>> esp->hdr.len = 0;
>>>                 for (i = 0; i < (cmd->hdr.len / 8); i++)
>>>                         set(cmd->wreg.regs[i].addr, cmd->wreg.regs[i].val);
>>>                 break;
>>>
>>> That code appears to handle event 1 which is a write into a register. In
>>> some cases that write appeared to cause a failure and a reset into the card.
>>> I added a simple delay loop before the switch statement and that seemed to
>>> fix the issue and I don't lose the card anymore even under a lot of load.
>>> Obviously that's not a real fix and something else more reliable needs to be
>>> in place.
>> Any idea what this "something" else might be?
> 
> I'm not very familiar with how USB works, maybe someone with more
> experience can shed some light here? It seems to me that the event
> handling needs to be slowed down a little or add some kind of
> verification.
the usb protocol already incorporates some verification
http://www.beyondlogic.org/usbnutshell/usb3.shtml

furthermore, the driver counts each command frame, therefore it can
detect whenever a frame was lost.

Regards,
	Chr
