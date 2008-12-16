Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:55575 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYLPSOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 13:14:07 -0500
Received: by gxk9 with SMTP id 9so5160507gxk.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 10:14:04 -0800 (PST)
Message-ID: <45e8e6c40812161008t3c0e04adge22382dd4b6f13f9@mail.gmail.com> (sfid-20081216_191411_067878_EC97A579)
Date: Tue, 16 Dec 2008 10:08:39 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH 3/3] libertas: if_spi, driver for libertas GSPI devices
Cc: "Angel Roman" <angel.roman@mdesystems.com>,
	"Colin McCabe" <colin@cozybit.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <1229449129.7307.51.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229398052-27465-1-git-send-email-colin@cozybit.com>
	 <1229398052-27465-2-git-send-email-colin@cozybit.com>
	 <1229398052-27465-3-git-send-email-colin@cozybit.com>
	 <1229398052-27465-4-git-send-email-colin@cozybit.com>
	 <4947241F.10305@mdesystems.com>
	 <1229449129.7307.51.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 16, 2008 at 9:38 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2008-12-15 at 22:44 -0500, Angel Roman wrote:
>> Hi Colin,
>>
>> I have support for the gspi as well. I've been trying to get in contact
>> with Dan Williams in order to contribute it to the list.
>
> Sorry about that... it's in my queue and I'll try to get to do some
> review in the next few days.  Doing the new interface isn't a ton of
> code, and I'd expect both yours and Colin's drivers to be quite similar
> as there's only a few ways this thing can be done :)
>
> The submission process is basically just like Colin did; generate a
> series of patches of your latest code (split into independent patches if
> possible) based on a kernel version (ideally the latest kernel version
> or better yet, wireless-testing.git) and then post it to linux-wireless
> and maybe cc libertas-dev as well.

We've been working/testing against a kernel that's pretty close to
upstream and then also against wireless-testing to make this driver
upstream-friendly and hopefully easy to merge.  If you have access to
a Blackfin development board, you can also clone our tree with the
driver integrated:
http://git.cozybit.com/
however it should be simple enough to build for other embedded platforms.

> Is there a generic SPI layer that could be used for the board-specific
> bits too, rather than putting that stuff in the libertas tree?  I assume
> that the SPI bus is more or less generic on your hardware (ie you could
> put something else on the other end instead of the 8686), and thus it
> would be better if we could figure out way not to put some much board
> specific logic into the libertas driver itself.

The exception is the GPIO-based chip select signal that the '8686
requires, we otherwise use the generic SPI layer.  The protocol
requires the host to assert the CS# line and then hold it low for the
entire transaction (which can be of arbitrary length).  Most SPI host
controllers cannot do this and therefore a plain GPIO is used.  The
board-specific config for this is not much different from configuring
your SPI chips in your mach-xxxx/board.c

-- 
Andrey Yurovsky
cozybit Inc.
