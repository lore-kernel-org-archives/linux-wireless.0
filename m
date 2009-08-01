Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:40311 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZHAMae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 08:30:34 -0400
Received: by ewy10 with SMTP id 10so2055556ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 05:30:34 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [rt2800pci] Problems with (and without) rfkill
Date: Sat, 1 Aug 2009 14:30:30 +0200
Cc: linux-wireless@vger.kernel.org
References: <5088EED148%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <5088EED148%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200908011430.30634.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x
> index 8a22e65..f934325 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -380,7 +380,12 @@ static int rt2800pci_rfkill_poll(struct rt2x00_dev *rt2x00d
>         u32 reg;
>  
>         rt2x00pci_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
> -       return rt2x00_get_field32(reg, GPIO_CTRL_CFG_BIT2);
> +       /*return rt2x00_get_field32(reg, GPIO_CTRL_CFG_BIT2);*/
> +       if (rt2x00_get_field32(reg, GPIO_CTRL_CFG_BIT2)) {
> +               rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT2, 0);
> +               rt2x00pci_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
> +       }
> +       return 0;       
>  }

Writing to the GPIO isn't the solution, the entire register is read-only, so
the chip will ignore it. The reason why the RFKILL bit is apparently set
while it shouldn't is that the device isn't initialized correctly and the
entire device isn't ready to handle anything at this time.

Ivo
