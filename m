Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:43470 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135Ab1H2OTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 10:19:20 -0400
Received: by mail-bw0-f49.google.com with SMTP id 17so6628508bke.22
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 07:19:18 -0700 (PDT)
Subject: Re: Problem with wl1271
From: Luciano Coelho <coelho@ti.com>
To: Ilya Ledvich <ilya@compulab.co.il>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	linux-wireless@vger.kernel.org,
	Igor Grinberg <grinberg@compulab.co.il>
In-Reply-To: <4E5B9B44.6080508@compulab.co.il>
References: <4E5B9B44.6080508@compulab.co.il>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 17:19:15 +0300
Message-ID: <1314627555.2296.353.camel@cumari> (sfid-20110829_161923_150405_0D07F482)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-29 at 16:59 +0300, Ilya Ledvich wrote: 
> Hi,

Hi Ilya,

[...]


> I load the wl12xx_sdio module and then set the interface up; no obvious 
> error
> is seen. When I run any other command (e.g. interface down/up, iwlist scan).
> I have "/wl1271: ERROR ELP wakeup timeout!/" error. Then the driver 
> tries to
> recover the chip; this eventually leads to the
> "/wl1271: ERROR sdio read failed (-110)/" error. The log file for
> ifconfig wlan0 up - down - up sequence is attached.

This looks like an SDIO power management problem.  Do you have
CONFIG_PM_RUNTIME enabled in your kernel?

Can you send us your .config and the patch where you modified the
board-cm-t35.c file?

-- 
Cheers,
Luca.

