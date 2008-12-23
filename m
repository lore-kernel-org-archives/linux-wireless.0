Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:44277 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYLWUZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 15:25:43 -0500
Received: by bwz14 with SMTP id 14so10498501bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 12:25:40 -0800 (PST)
Message-ID: <314b98fa0812231225x2bf6f3faudeedfa65adbc1cb0@mail.gmail.com> (sfid-20081223_212547_007635_C0F92DC9)
Date: Tue, 23 Dec 2008 12:25:40 -0800
From: "Colin McCabe" <colin@cozybit.com>
To: "Peter Wippich" <pewi@gw-instruments.de>
Subject: Re: [PATCH 3/3] libertas: if_spi, driver for libertas GSPI devices
Cc: "Andrey Yurovsky" <andrey@cozybit.com>,
	"Harald Welte" <laforge@gnumonks.org>,
	linux-wireless@vger.kernel.org,
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

Hi Peter,

If you look in include/linux/spi/spi.h, there is a comment that says:
/*
 * likely need more hooks for more protocol options affecting how
 * the controller talks to each chip, like:
 *  - memory packing (12 bit samples into low bits, others zeroed)
 *  - priority
 *  - drop chipselect after each word
 *  - chipselect delays
 *  - ...
 */

So the chip select features that our hardware needs (don't drop
chipselect after each word, busy-waits during the transaction) are not
yet part of the generic SPI layer. But they are "TBD."

I agree that we should move them into the generic SPI layer. Maybe
I'll come up with a patch to the SPI layer itself to do exactly that,
once I get back from vacation.

cheers,
Colin.


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
