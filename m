Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33098 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab0GaJhM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 05:37:12 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luke-Jr <luke@dashjr.org>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] p54spi: replace internal "cx3110x" name with "p54spi"
References: <201006012117.00432.luke@dashjr.org>
	<1275465299.3915.0.camel@jlt3.sipsolutions.net>
	<201006021406.15393.luke@dashjr.org>
	<1275640607.9953.15.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 31 Jul 2010 12:37:07 +0300
In-Reply-To: <1275640607.9953.15.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Fri\, 04 Jun 2010 10\:36\:47 +0200")
Message-ID: <87iq3wdmbg.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2010-06-02 at 14:06 -0500, Luke-Jr wrote:
>
>> > >  	.driver = {
>> > > -		/* use cx3110x name because board-n800.c uses that for the
>> > > -		 * SPI port */
>> > > -		.name		= "cx3110x",
>> > > +		.name		= "p54spi",
>> > >  		.bus		= &spi_bus_type,
>> > 
>> > maybe that comment wasn't clear enough ... it needs to be that way to be
>> > properly linked up against SPI.
>> 
>> I don't understand what you mean here. Does the hardware-side of SPI use 
>> string identifiers? These are the only two instances of "cx3110x" in the 
>> kernel source; N8x0 board files expect "p54spi"
>
> Hm, ok, I thought that the board stuff needed cx3110x. Hopefully it
> doesn't differ in n810s?

I changed the n8x0 board files (for both n800 and n810) in mainline to
use p54spi. So this patch is correct.

The old maemo kernels and the closed driver used cx3110x to identify
the spi device.

-- 
Kalle Valo
