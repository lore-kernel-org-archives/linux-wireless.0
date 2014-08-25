Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38692 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbaHYPCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 11:02:16 -0400
MIME-Version: 1.0
In-Reply-To: <8344390.rjnOcYBCET@wuerfel>
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de>
 <1408915485-8078-5-git-send-email-hauke@hauke-m.de> <8344390.rjnOcYBCET@wuerfel>
From: Jonas Gorski <jogo@openwrt.org>
Date: Mon, 25 Aug 2014 17:01:27 +0200
Message-ID: <CAOiHx=kcnZqkUxTc64oWWnyet2wXZe+3A1Lt2C5kvjgVjgwcVw@mail.gmail.com> (sfid-20140825_170221_058550_F9E75CD6)
Subject: Re: [RFC 3/7] bcm47xx-sprom: add Broadcom sprom parser driver
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	MIPS Mailing List <linux-mips@linux-mips.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 25, 2014 at 9:52 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 24 August 2014 23:24:41 Hauke Mehrtens wrote:
>> This driver needs an nvram driver and fetches the sprom values from the
>> nvram and provides it to any other driver. The calibration data for the
>> wifi chip the mac address and some more board description data is
>> stores in the sprom.
>>
>> This is based on a copy of arch/mips/bcm47xx/sprom.c and my plan is to
>> make the bcm47xx MIPS SoCs also use this driver some time later.
>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  .../devicetree/bindings/misc/bcm47xx-sprom.txt     |  16 +
>
> I'd prefer not to list the binding in a 'misc' category. Maybe we can
> have a new category and move the misc/sram.txt into the same?
>
>>  drivers/misc/Kconfig                               |  14 +
>>  drivers/misc/Makefile                              |   1 +
>>  drivers/misc/bcm47xx-sprom.c                       | 690 +++++++++++++++++++++
>
> On a similar note, putting the driver into drivers/misc seems
> suboptimal: misc drivers should by definition be something that
> is for some odd hardware with no external dependencies on it,
> whereas your driver seems to be used by multiple other drivers.
>
> Would it make sense to put it into drivers/bcma when that is the
> only bus it is used on?

If the driver will be used for bcm47xx/mips, it will be used for two
busses, bcma and ssb, so it will need to be at a common
location.


Jonas
