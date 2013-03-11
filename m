Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45775 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3CKLLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 07:11:14 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Julien Massot <jmassot@aldebaran-robotics.com>
CC: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ath6kl: cold reset target after host warm boot
References: <20130309100031.432.94974.stgit@localhost6.localdomain6>
	<20130309100150.432.50619.stgit@localhost6.localdomain6>
	<CADGp=QeRNuJLeDBWPH=z89R18-sEMy6qYsfaseyLG9qR+M4AbQ@mail.gmail.com>
Date: Mon, 11 Mar 2013 13:11:07 +0200
In-Reply-To: <CADGp=QeRNuJLeDBWPH=z89R18-sEMy6qYsfaseyLG9qR+M4AbQ@mail.gmail.com>
	(Julien Massot's message of "Mon, 11 Mar 2013 11:26:07 +0100")
Message-ID: <87mwuachtg.fsf@kamboji.qca.qualcomm.com> (sfid-20130311_121119_633348_83788C9B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julien Massot <jmassot@aldebaran-robotics.com> writes:

>> Julien reported that ar6004 usb device fails to initialise
>> after host has been rebooted and power is still on for the ar6004 device. He
>> found out that doing a cold reset fixes the issue.
>>
>> I wasn't sure what would be the best way to detect if target needs a reset so I
>> settled on checking a timeout from htc_wait_recv_ctrl_message().
>>
>> Reported-by: Julien Massot <jmassot@aldebaran-robotics.com>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>
> This patch fix the issue, now my adapter works after a soft reboot.
> The log are also better: (here is what happen on soft reboot)
>
> [   17.328029] ath6kl: htc pipe control receive timeout!
> [   17.328033] ath6kl: htc wait target timed out, resetting device
> [   17.332178] ath6kl: Failed to start hardware: -110
> [   17.332208] ath6kl: Failed to init ath6kl core: -110
> [   17.332270] ath6kl_usb: probe of 2-1:1.0 failed with error -110
> [   17.332306] usbcore: registered new interface driver ath6kl_usb
> [   19.040315] ath6kl: ar6004 hw 1.3 usb fw 3.5.0.2356\x01 api 3

Oh, I also need to fix that \x01 in the firmware version, the null
termination is incorrect. But this is a separate issue.

> Tested-by: Julien Massot <jmassot@aldebaran-robotics.com>

Thank you. I add that to the patch.

-- 
Kalle Valo
