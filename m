Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41788 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab0DQFeM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 01:34:12 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH] wl1251: add support for dedicated IRQ line
References: <1271413332-2979-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 17 Apr 2010 08:34:08 +0300
In-Reply-To: <1271413332-2979-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Fri\, 16 Apr 2010 13\:22\:12 +0300")
Message-ID: <87633qmylr.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> wl1251 has WLAN_IRQ pin for generating interrupts to host processor,
> which is mandatory in SPI mode and optional in SDIO mode (which can
> use SDIO interrupts instead). However TI recommends using deditated
> IRQ line for SDIO too.
>
> Add support for using dedicated interrupt line with SDIO, but also leave
> ability to switch to SDIO interrupts in case it's needed.

For spi the irq number delivered through struct spi_device, I assume
sdio didn't have any similar mechanism and that's why you added it to
struct wl12xx_platform_data.

Only minor comment is that it would be better to mention also in the
code that the gpio interrupt is the recommended method. But I can add
that comment later.

> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

Thank you again.

-- 
Kalle Valo
