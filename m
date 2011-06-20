Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47452 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab1FTVNf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 17:13:35 -0400
Message-ID: <4DFFB7F5.1070705@hauke-m.de> (sfid-20110620_231340_721161_C608B6BD)
Date: Mon, 20 Jun 2011 23:13:25 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	linux-mips@linux-mips.org, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, arnd@arndb.de, sshtylyov@mvista.com
Subject: Re: [RFC v2 03/12] bcma: add functions to scan cores needed on SoCs
References: <1308520209-668-1-git-send-email-hauke@hauke-m.de> <1308520209-668-4-git-send-email-hauke@hauke-m.de> <BANLkTinfFHwd++rxb0wn266dQhF=7ANmhQ@mail.gmail.com>
In-Reply-To: <BANLkTinfFHwd++rxb0wn266dQhF=7ANmhQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

Thank you for your review. The issues you pointed out will be fixed in
the next round.

On 06/20/2011 12:52 AM, Julian Calaby wrote:
> Hauke,
> 
> Couple of minor points
> 
> On Mon, Jun 20, 2011 at 07:50, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> The chip common and mips core have to be setup early in the boot
>> process to get the cpu clock.
>> bcma_bus_earyl_register() gets pointers to some space to store the core
> 
> Spelling: s/earyl/early/
Fixed
> 
>> data and searches for the chip common and mips core and initializes
>> chip common. After that was done and the kernel is out of early boot we
>> just have to run bcma_bus_register() and it will search for the other
>> cores, initialize and register them.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
>> index 12a75ab..6416bbc 100644
>> --- a/drivers/bcma/bcma_private.h
>> +++ b/drivers/bcma/bcma_private.h
>> @@ -15,9 +15,16 @@ struct bcma_bus;
>>  /* main.c */
>>  extern int bcma_bus_register(struct bcma_bus *bus);
>>  extern void bcma_bus_unregister(struct bcma_bus *bus);
>> +int __init bcma_bus_earyl_register(struct bcma_bus *bus,
>> +                                  struct bcma_device *core_cc,
>> +                                  struct bcma_device *core_mips);
> 
> Here too.
Also fixed now.
> 
>> diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
>> index 7970553..4ebb186 100644
>> --- a/drivers/bcma/scan.c
>> +++ b/drivers/bcma/scan.c
>> @@ -332,9 +361,10 @@ int bcma_bus_scan(struct bcma_bus *bus)
>>        u32 erombase;
>>        u32 __iomem *eromptr, *eromend;
>>
>> -       int err;
>> +       int err, core_num = 0;
>>
>> -       bcma_init_bus(bus);
>> +       if (!bus->init_done)
>> +               bcma_init_bus(bus);
> 
> For consistency with the core init functions, should this test go in
> bcma_init_bus()?
Fixed: Yes it is better to do this only in one function.
> 
> Thanks,
> 

Hauke
