Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58407 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab1FFKeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 06:34:31 -0400
Received: by qwk3 with SMTP id 3so1577149qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 03:34:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307311658-15853-7-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	<1307311658-15853-7-git-send-email-hauke@hauke-m.de>
Date: Mon, 6 Jun 2011 12:34:30 +0200
Message-ID: <BANLkTim74Km0T3XRo+W8jCrb2n-dv3XxNg@mail.gmail.com> (sfid-20110606_123433_617680_9C06B0DF)
Subject: Re: [RFC][PATCH 06/10] bcma: get CPU clock
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/6 Hauke Mehrtens <hauke@hauke-m.de>:
> +u32 bcma_cpu_clock(struct bcma_drv_mips *mcore)
> +{
> +       struct bcma_bus *bus = mcore->core->bus;
> +
> +       if (bus->drv_cc.capabilities & BCMA_CC_CAP_PMU)
> +               return bcma_pmu_get_clockcpu(&bus->drv_cc);
> +
> +       pr_err("No PMU available, need this to get the cpu clock\n");
> +       return 0;
> +}
> +EXPORT_SYMBOL(bcma_cpu_clock);

Are you really going to use this in some separated driver? If you're,
I heard that exporting symbol should go in pair with patch enabling
usage of such a symbol.

-- 
Rafał
