Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f178.google.com ([209.85.210.178]:48912 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3A2N0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 08:26:40 -0500
Received: by mail-ia0-f178.google.com with SMTP id y26so549121iab.9
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2013 05:26:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6ry0xPuzEAcDRB=hrTT71A5+WoJTZMGwaUS3RjSE4CcgLw@mail.gmail.com>
References: <CACna6ry0xPuzEAcDRB=hrTT71A5+WoJTZMGwaUS3RjSE4CcgLw@mail.gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Tue, 29 Jan 2013 14:26:19 +0100
Message-ID: <CAOiHx=k4h-ZHijqbuN+95GjVxs-FLGZsnh3vc_x2W6bO-n1P_w@mail.gmail.com> (sfid-20130129_142643_929546_832EF501)
Subject: Re: Handling serial flashes on Broadcom SOCs
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Paul Fertser <fercerpav@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 January 2013 12:37, Rafał Miłecki <zajec5@gmail.com> wrote:
> (snip)
> I don't think extending m25p80.c to support SSB/BCMA is acceptable, so
> we've two options now:
>
> 1) Just implement serial flashes support in separated driver operating
> on ssb/bcma buses.
> Easy to do, but requires some code duplication with m25p80.c
>
> 2) Fake SPI master in ssb & bcma and use m25p80.c
> I think it's much more complicated, as there probably isn't any real
> SPI on Broadcom devices. We have to fake/emulate it's operations. From
> early overview, some words-tips are: struct spi_master,
> spi_alloc_master, spi_register_master.
> I also don't know well m25p80.c is going to support chipsets on
> Broadcom devices. With some luck, we will have to extend it's database
> only. But it may happen we will have to add some/many modifications in
> m25p80.c as well.
> Another problem is early flash access. To boot properly we need to
> access serial flash very early to read NVRAM from it (plain text
> partition with board settings). This may be required even before we
> get "alloc" available, which may require additional extra hacks in
> m25p80.c.

Going from my experience in implementing/rewriting an SPI controller
driver, and having played around with the Broadcom sflash driver, I'd
definitely vote for 1). The expectations to an SPI controller are
quite broad, and the possibilities of the serial flash controller are
quite limited, so making it work with m25p80 will be likely add more
code than could be saved by emulating an SPI controller.

What I think might be doable is to export the SPI flashes list of
m25p80 list and letting both drivers use it. Not sure how much there
is to gain, though.


Jonas
