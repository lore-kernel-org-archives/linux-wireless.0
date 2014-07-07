Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:51656 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaGGNmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 09:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1407041225290.6607-100000@netrider.rowland.org>
References: <CAE4k23-Ut3ypV3FSccpbBoxHQRHxAeDEY9Ng4v0ay_MpTRs42g@mail.gmail.com>
	<Pine.LNX.4.44L0.1407041225290.6607-100000@netrider.rowland.org>
Date: Mon, 7 Jul 2014 15:42:55 +0200
Message-ID: <CAE4k23_wQvGhVCf2LxqnjnooimCE2pvbrD+PQRh4s3fx0_L1AA@mail.gmail.com> (sfid-20140707_154301_426668_F160234A)
Subject: Re: ath9k -> bogus usb xfer on at91
From: Anders Darander <anders.darander@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 July 2014 18:30, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 4 Jul 2014, Anders Darander wrote:
-oe-linux-gnueabi/linux-yocto-ccu/3.14+gitAUTOINC+7b03bd3dfd-r0/linux/drivers/usb/core/urb.c:450
>> usb_submit_urb+0x2ac/0x460()
>> usb 1-1: BOGUS urb xfer, pipe 1 != type 3

>
> I can't tell exactly where the fault is, but this message means that an
> URB was submitted for a bulk endpoint with a pipe of type
> PIPE_INTERRUPT.
>
>> After temporarily reverting commit
>> 3482528e9aced9234d4e2a4a9538c882a9aa5aa2, which enables debug checks
>> on all USB urb's (previously is was only enabled for a
>> CONFIG_USB_DEBUG enabled kernel), the WiFi chip starts to work
>> correctly. The chip in question is a ar9721.
>>
>>  The same USB stick works without these messages on my laptop; while
>> another USB stick, based on an rtl8187 chip, works without these
>> messages on the target system (at91sam9g20)
>>
>> Any pointers to what it could be? Or suggestions on how to attack the issue?
>
> Fix the URB submission to use the correct pipe type.

Yeah, that's the plan. At least to try and fix it, I just have to find
the spot where the
wrong pipe type is selected. (And the summer vacation is approaching fast).

Thanks for confirming my suspicion regarding the pipe type.

Cheers,
Anders

-- 
Anders Darander
EPO guidelines 1978: "If the contribution to the known art resides
solely in a computer program then the subject matter is not
patentable in whatever manner it may be presented in the claims."
