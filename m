Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:29594 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2LMRqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 12:46:55 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Julien Massot <jmassot@aldebaran-robotics.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: ath6kl: AR6004 failed to start on computer boot
References: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com>
Date: Thu, 13 Dec 2012 19:46:53 +0200
In-Reply-To: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com>
	(Julien Massot's message of "Mon, 10 Dec 2012 15:39:09 +0100")
Message-ID: <87wqwl3kvm.fsf@qca.qualcomm.com> (sfid-20121213_184659_371742_8295EC96)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julien,

Julien Massot <jmassot@aldebaran-robotics.com> writes:

> I have some problem with the AR6004 (hw 1.3) initialisation.

Just to be clear I think a problem with USB code/hardware, most likely
SDIO doesn't have this issue.

> I'm using the compat wireless 3.6.6-1 package, with the ath6kl driver from
>  https://github.com/kvalo/ath6kl.git. (master branch)
>
> The device seems not to respond after the firmware upload.
> "ath6kl: htc_wait_recv_ctrl_message: Timeout!"
> Increasing the timeout doesn't help.
> Here is the log at startup.
> http://pastebin.com/DsivqdDP
>
> If I unplug and re-plug the adapter, every thing is going well.
> http://pastebin.com/BTz0w5QL.

Finally I got working USB boards again and I see the same thing:

Dec 13 01:43:21 x201 kernel: [   24.843691] ath6kl: Failed to start hardware: -5
Dec 13 01:43:21 x201 kernel: [   24.843781] ath6kl: Failed to init ath6kl core: -5
Dec 13 01:43:21 x201 kernel: [   24.843849] ath6kl_usb: probe of 2-1.2:1.0 failed with error -5

> Any Idea on how to fix or workaround this issue ?

I remember seeing a test patch which did some low level reset on the
hardware. I need to dig that up and see if it helps.

Also adding delay to various places would be good to test, in case
hardware needs some time to initialise itself.

> (I've also tried the recovery options recovery_enable=1 heart_beat_poll=200)

I doubt this helps as we are not even able to upload the firmware.

Kalle
