Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:58025 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbZAIIFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 03:05:31 -0500
Received: by bwz14 with SMTP id 14so28545544bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 00:05:29 -0800 (PST)
To: Dan Williams <dcbw@redhat.com>
Cc: Colin McCabe <colin@cozybit.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: Re: [PATCH v2 3/3] libertas: if_spi, driver for libertas GSPI devices
References: <1230951623-26998-1-git-send-email-colin@cozybit.com>
	<1230951623-26998-2-git-send-email-colin@cozybit.com>
	<1230951623-26998-3-git-send-email-colin@cozybit.com>
	<1230951623-26998-4-git-send-email-colin@cozybit.com>
	<1231435046.21643.53.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 09 Jan 2009 10:05:27 +0200
In-Reply-To: <1231435046.21643.53.camel@localhost.localdomain> (Dan Williams's message of "Thu\, 08 Jan 2009 12\:17\:25 -0500")
Message-ID: <87ljtk29bs.fsf@litku.valot.fi> (sfid-20090109_090537_357531_9913A298)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> On Fri, 2009-01-02 at 19:00 -0800, Colin McCabe wrote:
>> Add initial support for libertas devices using a GSPI interface.  This has
>> been tested with the 8686.  At this time, as far as we know, GSPI firmware for
>> this device is not publicly distributable, but we expect this to change.
>> 
>> GSPI is intended to be used on embedded systems. Board-specific parameters are
>> required (see libertas_spi.h).
>
> One thing we found we *really* wanted with SDIO was the ability to reset
> the card completely, is there any ability to do that with the SPI
> interface, or do you need to rely on board-specific methods to do that?

For stlc45xx (which currently uses SPI) where's a separate power gpio
line. To reset it, put the line down, wait a bit and put it back up. I
would guess that to be a common practise, at least in the embedded
world.

-- 
Kalle Valo
