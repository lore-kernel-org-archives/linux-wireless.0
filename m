Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36826 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759348Ab3BYTjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 14:39:52 -0500
Received: by mail-oa0-f46.google.com with SMTP id k1so3626126oag.33
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 11:39:52 -0800 (PST)
Message-ID: <512BBE05.9010006@lwfinger.net> (sfid-20130225_203955_977332_89860356)
Date: Mon, 25 Feb 2013 13:39:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Yvan <yvan.labadie@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath6kl: AR6004 failed to start on computer boot
References: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com> <87ehghanxe.fsf@kamboji.qca.qualcomm.com> <CADGp=Qf=j+kWA4EM1Z-xyKkuutW64Fi0vfUNqm1tPM1+4WEKyQ@mail.gmail.com> <511E44B8.3000308@qca.qualcomm.com> <CADGp=QfOyyTpwEg1=XXiyvRE7ZOGsn6TfiPQHs3+Jc3C69RM6Q@mail.gmail.com> <51265413.9080609@lwfinger.net> <87mwuwqtgh.fsf@kamboji.qca.qualcomm.com> <loom.20130225T175854-850@post.gmane.org>
In-Reply-To: <loom.20130225T175854-850@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2013 11:19 AM, Yvan wrote:
> Kalle Valo <kvalo@...> writes:
>
>>
>> Larry Finger <Larry.Finger@...> writes:
>>
>>> On 02/21/2013 08:03 AM, Julien Massot wrote:
>>>> Hi,
>>>> I just find a quick and dirty patch to workaround this issue.
>>>> I just reset the device on initialization failure.
>>>>
>>>> I hope this helps to understand the real issue.
>>>>
>>
>> [...]
>>
>>> I am certain that the real problem here is that ath6kl is requesting
>>> firmware with a synchronous call using request_firmware() rather than
>>> with the asynchronous request_firmware_nowait(). That used to work,
>>> but updates to udev caused the firmware read operation to time out. It
>>> works after a reset because the file reading routines are now running;
>>> however, the correct fix is to rewrite the firmware reading section.
>>
>> I haven't looked at all the details yet, but AFAIK this is about cold vs
>> warm booting the chip. When rebooting the host while maintaining the
>> power to ar6004 ("warm boot") ath6kl probe fails as the chip is in odd
>> state and needs to be reset. It's not about dowloading the firmware
>> image from user space, it's about starting the firmware inside the chip.
>>
>> And besides, didn't udev finally fix that (after some "feedback" from
>> Linus) so that we don't need to change all the drivers?
>>
>
> Hi,
>
> I'm having the exact same problem than Julien, (my kernel log are _exactly_ the
> same than his).
>
> A difference on the behavior: the problem is not on reboot, it's always present
> (normal boot and reboot...).
>
> But the "quick fix" witch consist in adding "reset_device" doesn't work, it just
> goes into a loop (hardware_init fail->reset device->hardware_init fail->...)
>
> Main difference is the linux system:
> the architecture is ARM9 (armv4) with a buildroot system and kernel 3.6.7
> note: hardware USB port is usb_v1.1 only.
>
> I've tried ath6kl drivers from the kernel and the one from compat-
> driver_next(2013-02-20)
> =>same result.
>
> The wireless USB dongle is working properly on my linux computer with the same
> compat-driver and same firmware files, so it shouldn't have hardware problem
>
> Another wireless dongle based on RALINK chipset is working properly on my ARM
> system, so this shouldn't be an hardware problem from the board.

Does 'modprobe -rv ath6kl' followed by 'modprobe -r ath6kl' make it work? If so, 
then my idea about firmware loading might be correct. If not, then the problem 
is somewhere else.

Larry

