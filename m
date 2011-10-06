Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56011 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935422Ab1JFLDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 07:03:02 -0400
Received: by pzk1 with SMTP id 1so6555399pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 04:03:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8D8766.1030809@qca.qualcomm.com>
References: <1317824077-13476-1-git-send-email-sangwook.lee@linaro.org>
	<4E8D8766.1030809@qca.qualcomm.com>
Date: Thu, 6 Oct 2011 12:03:02 +0100
Message-ID: <CADPsn1bR+esqTPB649Lo+GFzcMCXrbe6aYHnvQS_YSBhTxBnhQ@mail.gmail.com> (sfid-20111006_130313_518150_F8F9FDE3)
Subject: Re: [PATCH] ath6kl:Fix execution address of OTP AR6003 HW2.0
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle

On 6 October 2011 11:48, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> On 10/05/2011 05:14 PM, Sangwook Lee wrote:
>> Fix OTP execution address for AR6003 HW2.0
>>
>> ath6kl: writing otp to 0x543180 (3689 B)
>> ath6kl: bmi LZ stream start: addr: 0x543180)
>> ath6kl: bmi send LZ data: len: 3688)
>> ath6kl: bmi send LZ data: len: 4)
>> ath6kl: bmi LZ stream start: addr: 0x0)
>> ath6kl: bmi read memory: device: addr: 0x54061c, len: 4
>> ath6kl: app_start_override_addr 0x0
>> ath6kl: executing OTP at 0x0
>> ath6kl: bmi execute: addr: 0x0, param: 0)
>> ath6kl: bmi_recv_buf FIFO empty
>> ath6kl: Unable to read from the device: -22
>
> Ah, now I understand. So this patch broke it:
>
> commit 639d0b8996aa5913402b846932d57a51a23a40c9
> Author: Kalle Valo <kvalo@qca.qualcomm.com>
> Date:   Mon Sep 12 12:48:09 2011 +0300
>
>    ath6kl: read firmware start address from hardware
>
>    It's actually possible to read the firmware start address from hardware,
>    that way there's no need to hardcode the address in hardware.
>
>
> So the firmware start address detections doesn't actually work with hw
> 2.0, too bad.
>
> Actually I would like to fix this a bit differently, can you please try
> the attached patch? Compile tested only. If it works, please send me a
> Tested-by tag.

Yes I will do it.

>
> BTW, do you still need to enable debug logs to get hw2.0 working properly?
Yes, I still have to use debug but want to fix it now, so please let me debug
 as  based on your last advice and then report to you.

>
> Kalle
>

Sangwook
