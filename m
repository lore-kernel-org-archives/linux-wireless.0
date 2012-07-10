Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:32768 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2GJVnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 17:43:12 -0400
Received: by wgbdr13 with SMTP id dr13so390233wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 14:43:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FFB62DA.9000706@hauke-m.de>
References: <1341751888-12679-1-git-send-email-zajec5@gmail.com>
	<4FFB62DA.9000706@hauke-m.de>
Date: Tue, 10 Jul 2012 23:43:09 +0200
Message-ID: <CACna6ry-Hxt56DCn8amKUxnqF+X8juZK26j5bJaRk-ubh7didA@mail.gmail.com> (sfid-20120710_234316_886192_C40720F8)
Subject: Re: [RFC][PATCH] bcma: add trivial GBIT MAC COMMON driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/10 Hauke Mehrtens <hauke@hauke-m.de>:
> On 07/08/2012 02:51 PM, Rafał Miłecki wrote:
>> GMAC COMMON core is present on BCM4706 and is used for example to access
>> board PHYs (PHYs can not be accessed directly using GBIT MAC core).
>
> I think this is the cleanest way of doing this. I thought about handling
> this in the Ethernet driver, but as we need locking, an extra driver
> would be needed, just for this stupid locking.
>
> You should not register an external device for this core in
> bcma_register_cores().

I've just noticed my BCM4706 doesn't have GBIT MAC CMN... but AFAIK
BCM4706 GMAC (0x52d) can not operate without GMAC CMN (0x5dc)...

Hauke: does it make any sense to you?

Found chip with id 0x5300, rev 0x01 and package 0x00
Core 0 found: BCM4706 ChipCommon (manuf 0x4BF, id 0x500, rev 0x1F,
class 0x0)
Core 3 found: MIPS 74K (manuf 0x4A7, id 0x82C, rev 0x00, class 0x0)
...
Core 1 found: BCM4706 GBit MAC (manuf 0x4BF, id 0x52D, rev 0x00, class
0x0)
Core 2 found: BCM4706 GBit MAC (manuf 0x4BF, id 0x52D, rev 0x00, class
0x0)
Core 4 found: USB 2.0 Host (manuf 0x4BF, id 0x819, rev 0x04, class
0x0)
Core 5 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0E, class 0x0)
Core 6 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0E, class 0x0)
Core 7 found: AMEMC (DDR) (manuf 0x4BF, id 0x52E, rev 0x00, class 0x0)
Core 8 found: BCM4706 SOC RAM (manuf 0x4BF, id 0x50E, rev 0x05, class
0x0)
Core 9 found: ALTA (I2S) (manuf 0x4BF, id 0x534, rev 0x00, class 0x0)

-- 
Rafał
