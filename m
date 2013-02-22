Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:10677 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab3BVPGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 10:06:13 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Julien Massot <jmassot@aldebaran-robotics.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: ath6kl: AR6004 failed to start on computer boot
References: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com>
	<87ehghanxe.fsf@kamboji.qca.qualcomm.com>
	<CADGp=Qf=j+kWA4EM1Z-xyKkuutW64Fi0vfUNqm1tPM1+4WEKyQ@mail.gmail.com>
	<511E44B8.3000308@qca.qualcomm.com>
	<CADGp=QfOyyTpwEg1=XXiyvRE7ZOGsn6TfiPQHs3+Jc3C69RM6Q@mail.gmail.com>
	<51265413.9080609@lwfinger.net>
Date: Fri, 22 Feb 2013 17:06:06 +0200
In-Reply-To: <51265413.9080609@lwfinger.net> (Larry Finger's message of "Thu,
	21 Feb 2013 11:06:27 -0600")
Message-ID: <87mwuwqtgh.fsf@kamboji.qca.qualcomm.com> (sfid-20130222_160618_334872_BD6826A9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 02/21/2013 08:03 AM, Julien Massot wrote:
>> Hi,
>> I just find a quick and dirty patch to workaround this issue.
>> I just reset the device on initialization failure.
>>
>> I hope this helps to understand the real issue.
>>

[...]

> I am certain that the real problem here is that ath6kl is requesting
> firmware with a synchronous call using request_firmware() rather than
> with the asynchronous request_firmware_nowait(). That used to work,
> but updates to udev caused the firmware read operation to time out. It
> works after a reset because the file reading routines are now running;
> however, the correct fix is to rewrite the firmware reading section.

I haven't looked at all the details yet, but AFAIK this is about cold vs
warm booting the chip. When rebooting the host while maintaining the
power to ar6004 ("warm boot") ath6kl probe fails as the chip is in odd
state and needs to be reset. It's not about dowloading the firmware
image from user space, it's about starting the firmware inside the chip.

And besides, didn't udev finally fix that (after some "feedback" from
Linus) so that we don't need to change all the drivers?

-- 
Kalle Valo
