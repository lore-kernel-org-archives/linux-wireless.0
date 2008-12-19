Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:43628 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbYLSSRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 13:17:38 -0500
Received: by bwz14 with SMTP id 14so4125445bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 10:17:36 -0800 (PST)
Message-ID: <45e8e6c40812191017w799e04b7m4815caab94818766@mail.gmail.com> (sfid-20081219_191806_410132_AB04448E)
Date: Fri, 19 Dec 2008 10:17:36 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Peter Wippich" <pewi@gw-instruments.de>
Subject: Re: [PATCH 3/3] libertas: if_spi, driver for libertas GSPI devices
Cc: "Harald Welte" <laforge@gnumonks.org>,
	linux-wireless@vger.kernel.org, "Colin McCabe" <colin@cozybit.com>,
	"Stefan Schmidt" <stefan@datenfreihafen.org>,
	libertas-dev@lists.infradead.org
In-Reply-To: <Pine.LNX.4.63.0812191745460.18864@redbean.intranet.gw-instruments.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229398052-27465-1-git-send-email-colin@cozybit.com>
	 <1229398052-27465-2-git-send-email-colin@cozybit.com>
	 <1229398052-27465-3-git-send-email-colin@cozybit.com>
	 <1229398052-27465-4-git-send-email-colin@cozybit.com>
	 <20081219160836.GQ9285@prithivi.gnumonks.org>
	 <45e8e6c40812190831k7796e240w55c47d7ca6417437@mail.gmail.com>
	 <Pine.LNX.4.63.0812191745460.18864@redbean.intranet.gw-instruments.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Peter.  The Blackfin SPI controller provides built-in Chip
Select signals and one can choose to assign one of several CS lines to
a device.  However we need a GPIO-style CS rather than one generated
by the controller and while I see that there's certainly room to
implement that in the SPI controller driver, I don't see a way to have
both that and the automatically-generated CS as options.  That is, if
I understand correctly, there's no way to configure spi_board_info
with, say, a flag that tells the driver "hey, use this specific GPIO
line", instead you can pick between 0 and num_chipselect for your
chip_select value and, in Blackfin's case, this would configure one of
the automatically-generated lines.  We appreciate additional feedback
about this.  Thanks,

On Fri, Dec 19, 2008 at 8:57 AM, Peter Wippich <pewi@gw-instruments.de> wrote:
>
> Hi Andrey,
>
>> The '8686 requires us to assert CS# and then hold it asserted for the
>> entire transaction.  The transaction is an arbitrary number of SPI
>> transfers.  Most host controllers cannot do this (they'll toggle CS#
>> between individual transactions) and therefore we chose to not use the
>> controller CS# line and use a GPIO.  Can you suggest a different way
>> to do this given the current SPI framework?
>
> This can be handled by the SPI driver. See pxa2xx_spi.c as an example.
> Look for cs_control() to get the picture.....
> Perhaps this should go to the general driver and not be handled by the
> chip specific code. Seems a problem general enough.
>
> Chears,
>
> Peter
>



-- 
Andrey Yurovsky
cozybit Inc.
