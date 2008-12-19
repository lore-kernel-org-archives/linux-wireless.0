Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:4276 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYLSQbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 11:31:15 -0500
Received: by fk-out-0910.google.com with SMTP id 18so571986fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 08:31:13 -0800 (PST)
Message-ID: <45e8e6c40812190831k7796e240w55c47d7ca6417437@mail.gmail.com> (sfid-20081219_173121_279920_AFF813AC)
Date: Fri, 19 Dec 2008 08:31:13 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Harald Welte" <laforge@gnumonks.org>
Subject: Re: [PATCH 3/3] libertas: if_spi, driver for libertas GSPI devices
Cc: "Colin McCabe" <colin@cozybit.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org,
	"Stefan Schmidt" <stefan@datenfreihafen.org>
In-Reply-To: <20081219160836.GQ9285@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229398052-27465-1-git-send-email-colin@cozybit.com>
	 <1229398052-27465-2-git-send-email-colin@cozybit.com>
	 <1229398052-27465-3-git-send-email-colin@cozybit.com>
	 <1229398052-27465-4-git-send-email-colin@cozybit.com>
	 <20081219160836.GQ9285@prithivi.gnumonks.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Harald,

On Fri, Dec 19, 2008 at 8:08 AM, Harald Welte <laforge@gnumonks.org> wrote:
> Hi Colin,
>
> thanks a lot for your patch, it is greatly appreciated.
>
> Stefan Schmidt (see Cc) and myself are currently working on using a 8686
> attached t o SPI of a S3C2442 SoC.
>
> Let me make some comments on the actual code:
>
> On Mon, Dec 15, 2008 at 07:27:32PM -0800, Colin McCabe wrote:
>
>> +struct libertas_spi_platform_data {
>> +     u16 host_irq_num;
>> +
>> +     u16 gpio_cs;
>> +};
>
>> +     gpio_set_value(card->gpio_cs, 0); /* assert CS */
>> +     gpio_set_value(card->gpio_cs, 1); /* drop CS */
>
> Typically, in the Linux SPI framework, it is the SPI host controller
> driver that exercises the chipselect GPIO, not the client (device) driver.

The '8686 requires us to assert CS# and then hold it asserted for the
entire transaction.  The transaction is an arbitrary number of SPI
transfers.  Most host controllers cannot do this (they'll toggle CS#
between individual transactions) and therefore we chose to not use the
controller CS# line and use a GPIO.  Can you suggest a different way
to do this given the current SPI framework?

> Also, the host_irq_num is typically passed by the '.irq' member of
> spi_board_info structure, since it is board specific data (see e.g.
> arch/arm/mach-pxa/spitz.c)

The IRQ in question is a GPIO line asserted by the '8686 and it is not
otherwise an SPI line, however I see now that it should be set in
spi_board_info as you mention, we'll fix that.

  -Andrey
