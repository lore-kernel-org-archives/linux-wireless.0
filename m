Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:35554 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaLURum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 12:50:42 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH 03/10] brcmfmac: Add support for bcm43340/1 wireless chipsets
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1419162233-19492-4-git-send-email-arend@broadcom.com>
Date: Sun, 21 Dec 2014 18:50:25 +0100
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Rob Herring <rob.herring@linaro.org>,
	John Stultz <john.stultz@linaro.org>
Message-Id: <B1CB9465-1353-411C-9B3C-42DEFBFDBBE0@holtmann.org> (sfid-20141221_185051_629601_22E81A60)
References: <1419162233-19492-1-git-send-email-arend@broadcom.com> <1419162233-19492-4-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index 0f01fe0..61f8318 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -29,6 +29,8 @@
> #define SDIO_DEVICE_ID_BROADCOM_4329		0x4329
> #define SDIO_DEVICE_ID_BROADCOM_4330		0x4330
> #define SDIO_DEVICE_ID_BROADCOM_4334		0x4334
> +#define SDIO_DEVICE_ID_BROADCOM_43340		43340
> +#define SDIO_DEVICE_ID_BROADCOM_43341		43341

the general preference is to have these values in hex. I get the fact that they map the marketing number, but that could be just stated in a comment after the hex number.

> #define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
> #define SDIO_DEVICE_ID_BROADCOM_43362		43362
> #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354

Is there any chance that you can also send patches against sdio.ids database from systemd:

http://cgit.freedesktop.org/systemd/systemd/tree/hwdb/sdio.ids

That would allow for udev to provide friendly names and they would also be shown using networkctl.

Regards

Marcel

