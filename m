Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:39267 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757365Ab3GEOo1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 10:44:27 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Daniel Drake' <dsd@laptop.org>, Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Fri, 5 Jul 2013 07:44:08 -0700
Subject: RE: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951035636351@SC-VEXCH1.marvell.com> (sfid-20130705_164429_931547_C202A1C9)
In-Reply-To: <CAMLZHHSSfPnWK957Yd+vrLrsPHtUDW3b4ZxSjMe2SdpaQPk5hQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

>Also, at which point do we wait upon all async commands to complete
>before shutting down? 

All sync and async commands are queued into same queue. Sync and async type indicates if the thread just queues the command or it queues the command and waits until command response is received.

Next command is sent to firmware only after receiving response of previous command. As we don't queue any command after SHUTDOWN command is queued, SHUTDOWN command is the last command sent to firmware. SHUTDOWN is a sync command. Hence remove handler thread waits until it's response.

Please let me know if there are any doubts.

Thanks,
Amit

