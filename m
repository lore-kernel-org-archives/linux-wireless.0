Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:34059 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbbGAEp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 00:45:28 -0400
Received: by iebmu5 with SMTP id mu5so26789566ieb.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2015 21:45:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55930E01.6070909@hauke-m.de>
References: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
	<55930E01.6070909@hauke-m.de>
Date: Wed, 1 Jul 2015 06:45:28 +0200
Message-ID: <CACna6rz4zoDbhK48cRcRUrPpV+DXrGA0Lq-cRGOeB=A=ZnCbvg@mail.gmail.com> (sfid-20150701_064532_044969_4231995B)
Subject: Re: [PATCH] bcma: populate bus DT subnodes as platform_device-s
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 June 2015 at 23:45, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 06/28/2015 05:17 PM, Rafał Miłecki wrote:
>> Our bus should allow defining children nodes as we may want to specify
>> devices attached to the bus. This is required e.g. to specify NAND or
>> ChipCommon cores and use bus's address and IRQ mappings.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/bcma/main.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>
> Rafał have you solved the IRQ problem? Is it possible to assign all the
> sub devices the same IRQ number as the chipcommon core?

Not yet. The only working solution I have so far is:
serial0: serial@0300 {
        compatible = "ns16550";
        reg = <0x0300 0x100>;
        interrupt-parent = <&gic>;
        interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
        clock-frequency = <100000000>;
};
(plus adding compatible = "simple-bus" to the chipcommon).

-- 
Rafał
