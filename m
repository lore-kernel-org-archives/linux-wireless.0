Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40187 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab3AKKer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 05:34:47 -0500
Received: by mail-wi0-f182.google.com with SMTP id hn14so927446wib.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2013 02:34:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BLU0-SMTP170F868AA41C395F4961031AC290@phx.gbl>
References: <BLU0-SMTP170F868AA41C395F4961031AC290@phx.gbl>
Date: Fri, 11 Jan 2013 11:34:45 +0100
Message-ID: <CACna6rwmOBqmzjvAv3n5MLdZxtfBOK3RjY4M3p5Hwm3Hbta2GA@mail.gmail.com> (sfid-20130111_113451_163575_19C4F5B6)
Subject: Re: [PATCH] bcma: fix bcm4716/bcm4748 i2s irqflag
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Nathan Hintz <nlhintz@hotmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	hauke@hauke-m.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/1/11 Nathan Hintz <nlhintz@hotmail.com>:
> +       if ((cpu && pcie && i2s) &&

Braces not needed


> +           (bcma_aread32(cpu, BCMA_MIPS_OOBSELINA74) == 0x08060504 &&
> +            bcma_aread32(pcie, BCMA_MIPS_OOBSELINA74) == 0x08060504 &&
> +            bcma_aread32(i2s, BCMA_MIPS_OOBSELOUTA30) == 0x88)) {
> +               bcma_awrite32(cpu, BCMA_MIPS_OOBSELINA74, 0x07060504);
> +               bcma_awrite32(pcie, BCMA_MIPS_OOBSELINA74, 0x07060504);
> +               bcma_awrite32(i2s, BCMA_MIPS_OOBSELOUTA30, 0x87);
> +               bcma_info(bus,
> +                         "Moved i2s interrupt to oob line 7 instead of 8\n");

I just wonder if it's worth "info" level?

-- 
Rafał
