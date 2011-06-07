Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1759 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab1FGKao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 06:30:44 -0400
Message-ID: <4DEDFDC8.50005@broadcom.com> (sfid-20110607_123047_361978_4A005058)
Date: Tue, 7 Jun 2011 12:30:32 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"mb@bu3sch.de" <mb@bu3sch.de>,
	"george@znau.edu.ua" <george@znau.edu.ua>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"bernhardloos@googlemail.com" <bernhardloos@googlemail.com>
Subject: Re: [RFC][PATCH 03/10] bcma: add embedded bus
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
 <1307311658-15853-4-git-send-email-hauke@hauke-m.de>
 <BANLkTi=T6xO9q+vOCk5Fu+2J_nUTwX3dcg@mail.gmail.com>
 <4DED4DEB.5030802@hauke-m.de>
 <BANLkTikATEB7zoDPBcc4Ubh7ONyHXWBW+w@mail.gmail.com>
In-Reply-To: <BANLkTikATEB7zoDPBcc4Ubh7ONyHXWBW+w@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2011 02:33 AM, Rafał Miłecki wrote:
> W dniu 7 czerwca 2011 00:00 użytkownik Hauke Mehrtens
> <hauke@hauke-m.de>  napisał:
>> On 06/06/2011 12:22 PM, Rafał Miłecki wrote:
>>>> +       if (bus->hosttype == BCMA_HOSTTYPE_EMBEDDED) {
>>>> +               iounmap(bus->mmio);
>>>> +               mmio = ioremap(BCMA_ADDR_BASE, BCMA_CORE_SIZE * bus->nr_cores);
>>>> +               if (!mmio)
>>>> +                       return -ENOMEM;
>>>> +               bus->mmio = mmio;
>>>> +
>>>> +               mmio = ioremap(BCMA_WRAP_BASE, BCMA_CORE_SIZE * bus->nr_cores);
>>>> +               if (!mmio)
>>>> +                       return -ENOMEM;
>>>> +               bus->host_embedded = mmio;
>>> Do we really need both? mmio and host_embedded? What about keeping
>>> mmio only and using it in calculation for read/write[8,16,32]?
>> These are two different memory regions, it should be possible to
>> calculate the other address, but I do not like that. As host_embedded is
>> in a union this does not waste any memory.
> Ah, OK, I can see what does happen here. You are using:
> 1) bus->mmio for first core
> 2) bus->host_embedded for first agent/wrapper
>
> I'm not sure if this is a correct approach. Doing "core_index *
> BCMA_CORE_SIZE" comes from ssb, where it was the way to calculate
> offset. In case of BCMA we are reading all the info from (E)EPROM,
> which also includes addresses of the cores.
>
> IMO you should use core->addr and core->wrap for read/write ops. I
> believe this is approach Broadcom decided to use for BCMA, when
> designing (E)EPROM.

Agree. There is no guarantee for the core index to relate to the 
physical address. Chip designer may be systematic in this and the 
index*size method may work, but not by design.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


