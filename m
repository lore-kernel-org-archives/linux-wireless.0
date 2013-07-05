Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:33621 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754701Ab3GEO3Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 10:29:24 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Daniel Drake' <dsd@laptop.org>, Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Fri, 5 Jul 2013 07:26:51 -0700
Subject: RE: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951035636350@SC-VEXCH1.marvell.com> (sfid-20130705_162930_705448_6C180E1B)
In-Reply-To: <CAMLZHHSSfPnWK957Yd+vrLrsPHtUDW3b4ZxSjMe2SdpaQPk5hQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

>> Followings are the actions taken for driver unload.
>>
>>    a) If device is connected, sync deauth command is sent.
>>    b) Auto deep sleep is cancelled by sending sync command
>>    c) Sync shutdown command is queued and HW_STATUS is changed to reset.
>>    d) Now no other command gets queued based on HW_STATUS.
>>    e) Wait for shutdown command response and handle it.
>>    f) Set surprise_removed flag which blocks SDIO interrupts
>>
>> As per our design, we don't send any command to firmware after SHUTDOWN command. Also, firmware doesn't send any interrupt after SHUTDOWN command response.

>I cannot see how the driver behaviour matches the above description
>for when the card is removed as the system is suspended. For example I
>cannot see where the SHUTDOWN command gets sent in such cases.

This behavior (i.e. mwifiex_sdio_remove() handler) is for driver unload(rmmod mwifiex_sdio) or when the system is powering down.

Our mwifiex_sdio_suspend() handler gets called when system is supended. It just informs firmware/hardware that host is going into sleep state by sending a command. The sleep is cancelled in mwifiex_sdio_resume() handler when sytem resumes.
We support wake-on-lan feature. User can configure wol conditions(using 'ethtool wol' or 'iw wowlan') before system suspend. Firmware wakes up the host if Rx packet matching configured condition is received.

I think, we should probably look into mwifiex_sdio_suspend() routine instead of mwifiex_sdio_remove() to debug interrupt storm issue. Please correct me if I am missing something.

We have wait_event_interruptible() call in suspend handler to make sure that we don't return from the handler until we get host sleep activated event from firmware. Firmware is not supposed to send any event after this.
We can't disable interrupts at this point, because we expect wakeup event from firmware upon packet arrival

Can you please share system suspend logs with dynamic debug enabled for mwifiex?

Thanks,
Amitkumar Karwar
