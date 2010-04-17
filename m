Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:31746 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab0DQLAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 07:00:32 -0400
Received: by fg-out-1718.google.com with SMTP id d23so809179fga.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Apr 2010 04:00:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87633qmylr.fsf@purkki.valot.fi>
References: <1271413332-2979-1-git-send-email-notasas@gmail.com>
	 <87633qmylr.fsf@purkki.valot.fi>
Date: Sat, 17 Apr 2010 14:00:30 +0300
Message-ID: <r2h6ed0b2681004170400ica97a74azda3ace32c152b973@mail.gmail.com>
Subject: Re: [PATCH] wl1251: add support for dedicated IRQ line
From: Grazvydas Ignotas <notasas@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 17, 2010 at 8:34 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Grazvydas Ignotas <notasas@gmail.com> writes:
>
>> wl1251 has WLAN_IRQ pin for generating interrupts to host processor,
>> which is mandatory in SPI mode and optional in SDIO mode (which can
>> use SDIO interrupts instead). However TI recommends using deditated
>> IRQ line for SDIO too.
>>
>> Add support for using dedicated interrupt line with SDIO, but also leave
>> ability to switch to SDIO interrupts in case it's needed.
>
> For spi the irq number delivered through struct spi_device, I assume
> sdio didn't have any similar mechanism and that's why you added it to
> struct wl12xx_platform_data.

Yes, SDIO currently only reads the card itself for information and
doesn't use any board data at all. This is enough for typical SDIO
card but not in this case, where we have additional signals for power
control and IRQ.

> Only minor comment is that it would be better to mention also in the
> code that the gpio interrupt is the recommended method. But I can add
> that comment later.

Will have that in mind too if I send something more, thanks.

>> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
>
> Acked-by: Kalle Valo <kvalo@adurom.com>
>
> Thank you again.
>
> --
> Kalle Valo
>
