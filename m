Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51781 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1FFKkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 06:40:11 -0400
Received: by qwk3 with SMTP id 3so1578982qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 03:40:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTim74Km0T3XRo+W8jCrb2n-dv3XxNg@mail.gmail.com>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	<1307311658-15853-7-git-send-email-hauke@hauke-m.de>
	<BANLkTim74Km0T3XRo+W8jCrb2n-dv3XxNg@mail.gmail.com>
Date: Mon, 6 Jun 2011 12:40:10 +0200
Message-ID: <BANLkTimdAoB=ye27qfxzdj2K-VBS6ch+ow@mail.gmail.com> (sfid-20110606_124016_213233_5F5312A7)
Subject: Re: [RFC][PATCH 06/10] bcma: get CPU clock
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 6 czerwca 2011 12:34 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> 2011/6/6 Hauke Mehrtens <hauke@hauke-m.de>:
>> +u32 bcma_cpu_clock(struct bcma_drv_mips *mcore)
>> +{
>> +       struct bcma_bus *bus = mcore->core->bus;
>> +
>> +       if (bus->drv_cc.capabilities & BCMA_CC_CAP_PMU)
>> +               return bcma_pmu_get_clockcpu(&bus->drv_cc);
>> +
>> +       pr_err("No PMU available, need this to get the cpu clock\n");
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL(bcma_cpu_clock);
>
> Are you really going to use this in some separated driver? If you're,
> I heard that exporting symbol should go in pair with patch enabling
> usage of such a symbol.

I've just read patch 09/10, sorry for the noise :)

-- 
Rafał
