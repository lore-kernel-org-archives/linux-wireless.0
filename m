Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35169 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbZKFPQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 10:16:03 -0500
Received: by yxe17 with SMTP id 17so969379yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 07:16:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20091106T135746-452@post.gmane.org>
References: <loom.20091106T135746-452@post.gmane.org>
Date: Fri, 6 Nov 2009 10:16:07 -0500
Message-ID: <b6c5339f0911060716n538268f6w1300e3400e0bd2c8@mail.gmail.com>
Subject: Re: [PATCH] Wifi led does not work on Acer Aspire One D250 (ath5k
	driver)
From: Bob Copeland <me@bobcopeland.com>
To: Carlo Parata <carlo_parata@hotmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 8:00 AM, Carlo Parata <carlo_parata@hotmail.com> wrote:
> With this patch, a Acer Aspire One D250 can turn on the wifi led. The array of
> compatible devices in ath5k driver now includes the hardware present in this
> computer, as well as the led pin and polarity.
>
> --- ../led.c    2009-11-06 06:16:39.000000000 +0100
> +++ ./drivers/net/wireless/ath/ath5k/led.c      2009-11-06 12:37:44.000000000 +0100
> @@ -73,6 +73,8 @@
>        { ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x0137b), ATH_LED(3, 1) },
>        /* IBM-specific AR5212 (all others) */
>        { PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
> +        /* Acer Aspire One D250 AR5007EG */
> +       { PCI_VDEVICE(ATHEROS, 0x001c), ATH_LED(3, 1) },

No, this should be based on the subdevice instead
(there are lots of ath:001c with different LED settings).

Also, please add your email to the appropriate stanza.

-- 
Bob Copeland %% www.bobcopeland.com
