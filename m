Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36959 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab1G2VGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 17:06:21 -0400
Received: by gyh3 with SMTP id 3so2798092gyh.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 14:06:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rxMA9KDuWSPLmdNsS=zNJawkbX5-KYrRWq3Jn25gWhX7A@mail.gmail.com>
References: <1311376815-15755-1-git-send-email-hauke@hauke-m.de>
	<1311376815-15755-7-git-send-email-hauke@hauke-m.de>
	<CACna6rxMA9KDuWSPLmdNsS=zNJawkbX5-KYrRWq3Jn25gWhX7A@mail.gmail.com>
Date: Fri, 29 Jul 2011 23:06:20 +0200
Message-ID: <CACna6rzqm=NhsrUWZr8Mun5fNaz3x1Qa6Fv_-TMKw8iOsK=u-w@mail.gmail.com> (sfid-20110729_230624_629699_09734E7F)
Subject: Re: [PATCH 06/11] bcma: add serial console support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org, jonas.gorski@gmail.com,
	ralf@linux-mips.org, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, arnd@arndb.de,
	julian.calaby@gmail.com, sshtylyov@mvista.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 29 lipca 2011 23:04 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> 2011/7/23 Hauke Mehrtens <hauke@hauke-m.de>:
>> This adds support for serial console to bcma, when operating on an SoC.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/bcma/bcma_private.h                 |    8 ++++
>>  drivers/bcma/driver_chipcommon.c            |   48 +++++++++++++++++++++++++++
>>  drivers/bcma/driver_chipcommon_pmu.c        |   26 ++++++++++++++
>>  drivers/bcma/driver_mips.c                  |    1 +
>>  include/linux/bcma/bcma_driver_chipcommon.h |   14 ++++++++
>>  5 files changed, 97 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
>> index b97633d..22d3052 100644
>> --- a/drivers/bcma/bcma_private.h
>> +++ b/drivers/bcma/bcma_private.h
>> @@ -29,6 +29,14 @@ void bcma_init_bus(struct bcma_bus *bus);
>>  /* sprom.c */
>>  int bcma_sprom_get(struct bcma_bus *bus);
>>
>> +/* driver_chipcommon.c */
>> +#ifdef CONFIG_BCMA_DRIVER_MIPS
>> +void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
>> +#endif /* CONFIG_BCMA_DRIVER_MIPS */
>> +
>> +/* driver_chipcommon_pmu.c */
>> +u32 bcma_pmu_alp_clock(struct bcma_drv_cc *cc);
>> +
>>  #ifdef CONFIG_BCMA_HOST_PCI
>>  /* host_pci.c */
>>  extern int __init bcma_host_pci_init(void);
>
> Not sure, what do you think about this, feel free to comment.
>
> My idea was to use bcma_private.h for bcma-internal functions. For
> example, support for PCI host or SoC host, is something "internal" (as
> I call it) for bcma. Drivers in theory could be separated modules and
> I use include/linux/bcma/driver_*.h for them.
>
> If following this schema, declarations of
> bcma_pmu_alp_clock
> bcma_host_pci_init
> should be in include/linux/bcma/bcma_driver_chipcommon.h

Same goes to the
bcma_pmu_get_clockcpu
from patch 07/11.

Sorry for late-noticing this.

I don't have more comments against your patch set :) Hope John will
take it soon :)

-- 
Rafał
