Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40788 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab1FFVkQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 17:40:16 -0400
Message-ID: <4DED493A.8050209@hauke-m.de> (sfid-20110606_234020_418632_62AC743A)
Date: Mon, 06 Jun 2011 23:40:10 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	zajec5@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com
Subject: Re: [RFC][PATCH 03/10] bcma: add embedded bus
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de> <1307311658-15853-4-git-send-email-hauke@hauke-m.de> <BANLkTi=atiB_=_N3xSJBAjRGXjTV8a97CA@mail.gmail.com>
In-Reply-To: <BANLkTi=atiB_=_N3xSJBAjRGXjTV8a97CA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2011 01:22 AM, Julian Calaby wrote:
> Hauke,
> 
> Minor nit:
> 
> On Mon, Jun 6, 2011 at 08:07, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> This patch adds support for using bcma on an embedded bus. An embedded
>> system like the bcm4716 could register this bus and it searches for the
>> bcma cores then.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>> diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
>> index 70b39f7..9229615 100644
>> --- a/drivers/bcma/scan.c
>> +++ b/drivers/bcma/scan.c
>> @@ -219,9 +219,34 @@ int bcma_bus_scan(struct bcma_bus *bus)
>>        bus->chipinfo.id = (tmp & BCMA_CC_ID_ID) >> BCMA_CC_ID_ID_SHIFT;
>>        bus->chipinfo.rev = (tmp & BCMA_CC_ID_REV) >> BCMA_CC_ID_REV_SHIFT;
>>        bus->chipinfo.pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
>> +       bus->nr_cores = (tmp & BCMA_CC_ID_NRCORES) >> BCMA_CC_ID_NRCORES_SHIFT;
>> +
>> +       /* If we are an embedded device we now know the number of avaliable
>> +        * core and ioremap the correct space.
>> +        */
>> +       if (bus->hosttype == BCMA_HOSTTYPE_EMBEDDED) {
>> +               iounmap(bus->mmio);
>> +               mmio = ioremap(BCMA_ADDR_BASE, BCMA_CORE_SIZE * bus->nr_cores);
>> +               if (!mmio)
>> +                       return -ENOMEM;
>> +               bus->mmio = mmio;
>> +
>> +               mmio = ioremap(BCMA_WRAP_BASE, BCMA_CORE_SIZE * bus->nr_cores);
>> +               if (!mmio)
>> +                       return -ENOMEM;
>> +               bus->host_embedded = mmio;
>> +       }
>> +       /* reset it to 0 as we use it for counting */
>> +       bus->nr_cores = 0;
> 
> Would it make sense to use a local variable for nr_cores, and only use
> it within the BCMA_HOSTTYPE_EMBEDDED if statement, rather than
> re-using bus->nr_cores and having to reset it?
Yes that looks better.

Hauke
