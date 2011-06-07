Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48222 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab1FGAd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 20:33:29 -0400
Received: by qyk7 with SMTP id 7so1077317qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 17:33:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DED4DEB.5030802@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	<1307311658-15853-4-git-send-email-hauke@hauke-m.de>
	<BANLkTi=T6xO9q+vOCk5Fu+2J_nUTwX3dcg@mail.gmail.com>
	<4DED4DEB.5030802@hauke-m.de>
Date: Tue, 7 Jun 2011 02:33:28 +0200
Message-ID: <BANLkTikATEB7zoDPBcc4Ubh7ONyHXWBW+w@mail.gmail.com> (sfid-20110607_023341_319977_30EDFEA8)
Subject: Re: [RFC][PATCH 03/10] bcma: add embedded bus
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 7 czerwca 2011 00:00 użytkownik Hauke Mehrtens
<hauke@hauke-m.de> napisał:
> On 06/06/2011 12:22 PM, Rafał Miłecki wrote:
>>> +       if (bus->hosttype == BCMA_HOSTTYPE_EMBEDDED) {
>>> +               iounmap(bus->mmio);
>>> +               mmio = ioremap(BCMA_ADDR_BASE, BCMA_CORE_SIZE * bus->nr_cores);
>>> +               if (!mmio)
>>> +                       return -ENOMEM;
>>> +               bus->mmio = mmio;
>>> +
>>> +               mmio = ioremap(BCMA_WRAP_BASE, BCMA_CORE_SIZE * bus->nr_cores);
>>> +               if (!mmio)
>>> +                       return -ENOMEM;
>>> +               bus->host_embedded = mmio;
>>
>> Do we really need both? mmio and host_embedded? What about keeping
>> mmio only and using it in calculation for read/write[8,16,32]?
>
> These are two different memory regions, it should be possible to
> calculate the other address, but I do not like that. As host_embedded is
> in a union this does not waste any memory.

Ah, OK, I can see what does happen here. You are using:
1) bus->mmio for first core
2) bus->host_embedded for first agent/wrapper

I'm not sure if this is a correct approach. Doing "core_index *
BCMA_CORE_SIZE" comes from ssb, where it was the way to calculate
offset. In case of BCMA we are reading all the info from (E)EPROM,
which also includes addresses of the cores.

IMO you should use core->addr and core->wrap for read/write ops. I
believe this is approach Broadcom decided to use for BCMA, when
designing (E)EPROM.

You should not need bus->host_embedded then, maybe you could even do
not set bus->mmio?

-- 
Rafał
