Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:61000 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249Ab3GERGH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 13:06:07 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Daniel Drake' <dsd@laptop.org>
CC: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Fri, 5 Jul 2013 10:05:42 -0700
Subject: RE: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951035636354@SC-VEXCH1.marvell.com> (sfid-20130705_190622_349655_A98ED411)
In-Reply-To: <CAMLZHHSZvKWnaBXycNsh64oExhpa0amcUi-6eC-FOaeNZ-TP1A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Daniel,

>There is no point in the one case that you mention. But there is a
>very good reason to do so in the case that I am talking about. So why
>not do it? There is no harm to do it if the hardware is not present,
>right?

I got your point. We didn't test the behavior of sdio_read/sdio_write API's when hardware is not present. But they should just return an error.

>This doesn't make much sense to me either. Why don't we just disable
>the interrupt handler at the point when interrupts can no longer be
>correctly handled by the driver?

Agreed. Following change will fix the issue. Right? Instead of going for your earlier changes to ack interrupts until we disable them.


@@ -152,6 +152,9 @@ mwifiex_sdio_remove(struct sdio_func *func)
 		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
 	}
 
+	/* Disable host interrupt mask register for SDIO */
+	mwifiex_sdio_disable_host_int(adapter);
+
 	mwifiex_remove_card(card->adapter, &add_remove_card_sem);
 	kfree(card);
 }


Thanks,
Amitkumar Karwar
