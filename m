Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:60095 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751699AbdBMGiU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 01:38:20 -0500
Subject: Re: [PATCH] Make EN2 pin optional in the TRF7970A driver
To: Rob Herring <robh@kernel.org>
References: <1486444924-18444-1-git-send-email-hs@denx.de>
 <20170210155114.pvjahqqjqurw5jdc@rob-hp-laptop>
Cc: netdev@vger.kernel.org, Guan Ben <ben.guan@cn.bosch.com>,
        Mark Jonas <mark.jonas@de.bosch.com>,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Mark Rutland <mark.rutland@arm.com>
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
Message-ID: <58A15454.4030602@denx.de> (sfid-20170213_073903_327971_6326A160)
Date: Mon, 13 Feb 2017 07:38:12 +0100
MIME-Version: 1.0
In-Reply-To: <20170210155114.pvjahqqjqurw5jdc@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Rob,

Am 10.02.2017 um 16:51 schrieb Rob Herring:
> On Tue, Feb 07, 2017 at 06:22:04AM +0100, Heiko Schocher wrote:
>> From: Guan Ben <ben.guan@cn.bosch.com>
>>
>> Make the EN2 pin optional. This is useful for boards,
>> which have this pin fix wired, for example to ground.
>>
>> Signed-off-by: Guan Ben <ben.guan@cn.bosch.com>
>> Signed-off-by: Mark Jonas <mark.jonas@de.bosch.com>
>> Signed-off-by: Heiko Schocher <hs@denx.de>
>>
>> ---
>>
>>   .../devicetree/bindings/net/nfc/trf7970a.txt       |  4 ++--
>>   drivers/nfc/trf7970a.c                             | 26 ++++++++++++----------
>>   2 files changed, 16 insertions(+), 14 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
>> index 32b35a0..5889a3d 100644
>> --- a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
>> +++ b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
>> @@ -5,8 +5,8 @@ Required properties:
>>   - spi-max-frequency: Maximum SPI frequency (<= 2000000).
>>   - interrupt-parent: phandle of parent interrupt handler.
>>   - interrupts: A single interrupt specifier.
>> -- ti,enable-gpios: Two GPIO entries used for 'EN' and 'EN2' pins on the
>> -  TRF7970A.
>> +- ti,enable-gpios: One or two GPIO entries used for 'EN' and 'EN2' pins on the
>> +  TRF7970A. EN2 is optional.
>
> Could EN ever be optional/fixed? If so, perhaps deprecate this property
> and do 2 properties, one for each pin.

The hardware I have has the EN2 pin fix connected to ground. Looking
into http://www.ti.com/lit/ds/slos743k/slos743k.pdf page 19 table 6-3
and 6-4 the EN2 pin is a don;t core if EN = 1. If EN = 0 EN2 pin
selects between Power Down and Sleep Mode ... I see no reason why
this is not possible/allowed ...

Hmm.. I do not like the idea of deprecating the "ti,enable-gpios"
property into 2 seperate properties ... but if this would be a reason
for not accepting this patch, I can do this ... How should I name
the 2 new properties?

"ti,pin-enable"  and "ti,pin-enable2" ?

bye,
Heiko
-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
