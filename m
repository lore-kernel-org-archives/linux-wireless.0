Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f201.google.com ([209.85.210.201]:38661 "EHLO
	mail-yx0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZFLAXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 20:23:15 -0400
Received: by yxe39 with SMTP id 39so128531yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 17:23:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890906111720g314c433djee8eb03d1307cb4b@mail.gmail.com>
References: <43e72e890906111559p614e83fdnec245fb806e01fc3@mail.gmail.com>
	<1244763159.27363.103.camel@violet> <43e72e890906111659h7649529dobf20b937661da8aa@mail.gmail.com>
	<1244765167.27395.1.camel@violet> <43e72e890906111713q338c178ah34d263db43693c58@mail.gmail.com>
	<43e72e890906111720g314c433djee8eb03d1307cb4b@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Jun 2009 17:22:54 -0700
Message-ID: <43e72e890906111722h678221dfrf2d4d7e082a0cd16@mail.gmail.com>
Subject: Re: rfkill on T61
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2009 at 5:20 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Thu, Jun 11, 2009 at 5:13 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
>> On Thu, Jun 11, 2009 at 5:06 PM, Marcel Holtmann<marcel@holtmann.org> wrote:
>>> Hi Luis,
>>>
>>>> >> When I hit rfkill, I get:
>>>> >>
>>>> >> [18493.777231] btusb_intr_complete: hci0 urb cbe20000 failed to resubmit (19)
>>>> >> [18493.777553] btusb_send_frame: hci0 urb f7d3c700 submission failed
>>>> >>
>>>> >> When I hit it again I get:
>>>> >>
>>>> >> [18531.488091] usb 1-1: new full speed USB device using uhci_hcd and address 7
>>>> >> [18531.651409] usb 1-1: configuration #1 chosen from 1 choice
>>>> >>
>>>> >> The device that disappears upon rfkill is my bluetooth controller:
>>>> >>
>>>> >> mcgrof@tesla ~ $ diff -u before-rfkill after-rfkill
>>>> >> --- 1   2009-06-11 15:37:37.000000000 -0700
>>>> >> +++ 2   2009-06-11 15:37:49.000000000 -0700
>>>> >> @@ -6,7 +6,6 @@
>>>> >>  Bus 003 Device 004: ID 046d:c040 Logitech, Inc. Corded Tilt-Wheel Mouse
>>>> >>  Bus 003 Device 003: ID 04b3:4485 IBM Corp.
>>>> >>  Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>>>> >> -Bus 001 Device 006: ID 0a5c:2110 Broadcom Corp. Bluetooth Controller
>>>> >>  Bus 001 Device 004: ID 0483:2016 SGS Thomson Microelectronics
>>>> >> Fingerprint Reader
>>>> >>  Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>>>> >>  Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>>>> >>
>>>> >> Granted I tested this on 2.6.27 with bleeding edge compat-wireless but
>>>> >> I think this is the same behaviour I will get with bleeding edge, will
>>>> >> try now on wireless-testing.
>>>> >
>>>> > what are you trying to tell us.
>>>>
>>>> my 802.11 device is not rfkill'ed on the T61, some patches recently
>>>> went in to add support for rfkill on ath5k. I do have thinkpad_acpi
>>>> loaded on this ancient 2.6.27 kernel.
>>>>
>>>> I'll try on wireless-testing next, build is almost done.
>>>
>>> still are not getting what you wanna tell us. What has Bluetooh RFKILL
>>> switch to do with WiFi.
>>
>> Nothing, I really was just unaware we rfkilled bluetooth as well. Plus
>> like I said my 802.11 device is not being rfkilled, which is what I
>> actually did expect.
>
> Yeah same thing with wireless-testing.

Heh nevermind me, the 802.11 rfkill button is in a different place. Doh!

  Luis
