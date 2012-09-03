Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54321 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2ICTPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 15:15:46 -0400
Received: by wicr5 with SMTP id r5so4468646wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2012 12:15:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346427485-12801-3-git-send-email-hauke@hauke-m.de>
References: <1346427485-12801-1-git-send-email-hauke@hauke-m.de>
	<1346427485-12801-3-git-send-email-hauke@hauke-m.de>
Date: Mon, 3 Sep 2012 21:15:44 +0200
Message-ID: <CACna6rwb15pfbM6rM5ros0yCSW+uv1CbwWz5pUz8OgvONKKrvg@mail.gmail.com> (sfid-20120903_211548_825285_DDD8A04E)
Subject: Re: [PATCH v3 2/3] bcma: add GPIO driver for SoCs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: ralf@linux-mips.org, john@phrozen.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, florian@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/31 Hauke Mehrtens <hauke@hauke-m.de>:
> +u32 bcma_gpio_in(struct bcma_bus *bus, u32 mask)
> +{
> +       unsigned long flags;
> +       u32 res = 0;
> +
> +       spin_lock_irqsave(&bus->gpio_lock, flags);
> +       res = bcma_chipco_gpio_in(&bus->drv_cc, mask);
> +       spin_unlock_irqrestore(&bus->gpio_lock, flags);
> +
> +       return res;
> +}
> +EXPORT_SYMBOL(bcma_gpio_in);


Could we put here direct ops on ChipCommon regs and drop GPIO
functions from driver_chipcommon.c?

-- 
Rafał
