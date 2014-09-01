Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49646 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaIAUp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 16:45:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by arrakis.dune.hu (Postfix) with ESMTP id E20B128BB74
	for <linux-wireless@vger.kernel.org>; Mon,  1 Sep 2014 22:45:33 +0200 (CEST)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com [209.85.216.171])
	by arrakis.dune.hu (Postfix) with ESMTPSA id 608AD28BB92
	for <linux-wireless@vger.kernel.org>; Mon,  1 Sep 2014 22:45:27 +0200 (CEST)
Received: by mail-qc0-f171.google.com with SMTP id x3so5956358qcv.30
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 13:45:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4072992.6HB7sP7z87@wuerfel>
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com>
 <CACna6rwmNtS1JSi=VHXWHu6mOM72Y8sBrr5EqCRbpYUHFrMnCg@mail.gmail.com>
 <CACna6rwMovK133ZoFYsLcsnH39umU7=UAoyG6jmgM8ZVq0AYRA@mail.gmail.com> <4072992.6HB7sP7z87@wuerfel>
From: Jonas Gorski <jogo@openwrt.org>
Date: Mon, 1 Sep 2014 22:45:25 +0200
Message-ID: <CAOiHx==sRquiqrQW6T0S+UsOz5H8V1Wt7x1RD=SVo6=gu7M1Vg@mail.gmail.com> (sfid-20140901_224608_922620_571297FE)
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 1, 2014 at 4:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 01 September 2014 09:48:48 Rafał Miłecki wrote:
>> On 31 August 2014 11:20, Rafał Miłecki <zajec5@gmail.com> wrote:
>> So I think we'll need to change our vision of flash access in
>> bcm74xx_nvram driver. I guess we will have to:
>> 1) Register NAND core early
>> 2) Initialize NAND driver
>> 3) Use mtd/nand API in bcm47xx_nvram
>
> This would mean it's available really late. Is that a problem?

That's probably mostly fine (for MIPS), except for two places:
a) the kernel command line is stored in nvram, and used for finding
out the correct console tty.
b) on one specific chip, the configured system clock rate needs to be
read out from nvram.

Both can be also done through DT, but b) is somewhat important to do
right, as it will cause the time running fast/slow if the value is
wrong.

> A possible solution for this would be to use the boot wrapper
> I mentioned earlier, to put all the data from nvram into DT
> properties before the kernel gets started.

That sounds like quite a bit of effort, and a bit over-engineered for
just 2.5 platforms.


Jonas
