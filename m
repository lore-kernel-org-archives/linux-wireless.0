Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:47235 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaHaJUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2014 05:20:42 -0400
Received: by mail-ie0-f171.google.com with SMTP id rp18so4807662iec.16
        for <linux-wireless@vger.kernel.org>; Sun, 31 Aug 2014 02:20:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5882203.GXbhhcHqjK@wuerfel>
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com>
	<53FF9D9B.30106@hauke-m.de>
	<CACna6rzaXHww2UXoP4Fi-zA3uNve4NQ48DeChF8zoBS-_-mtyw@mail.gmail.com>
	<5882203.GXbhhcHqjK@wuerfel>
Date: Sun, 31 Aug 2014 11:20:41 +0200
Message-ID: <CACna6rwmNtS1JSi=VHXWHu6mOM72Y8sBrr5EqCRbpYUHFrMnCg@mail.gmail.com> (sfid-20140831_112045_957828_23F33530)
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 August 2014 22:04, Arnd Bergmann <arnd@arndb.de> wrote:
> You mentioned that the 'boot_device' variable in your code snippet
> comes from a hardware register that can be accessed easily, right?
> A possible way to handle it would then be to have two DT entries
> like
>
>         nvram@1c000000 {
>                 compatible = "bcm,bcm4710-nvram";
>                 reg = <0x1c000000 0x1000000>;
>                 bcm,boot-device = BCMA_BOOT_DEV_NAND;
>         };
>
>         nvram@1c000000 {
>                 compatible = "bcm,bcm4710-nvram";
>                 reg = <0x1e000000 0x1000000>;
>                 bcm,boot-device = BCMA_BOOT_DEV_SERIAL;
>         };

This sounds like a nice consensus for me! Actually it seems to be
similar to what we already do for other hardware parts.

E.g. in bcm4708.dtsi Hauke put registers location of 4 Ethernet cores
(gmac@0, gmac@1, gmac@2, gmac@3). I believe this board is ready for 4
Ethernet cores so DT matches hardware capabilities. Then most vendors
use/activate only one (maybe up to 2?) Ethernet cores. It's up to the
driver to detect if core is activated/used.

AFAIU having two flash mappings (as suggested above) would follow this
logic. It would match hardware capabilities. And then it would be up
to driver to detect which one mapping is really in use for this
particular board.

Does it make sense?

-- 
Rafał
