Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44083 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYLPRj4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 12:39:56 -0500
Subject: Re: [PATCH 3/3] libertas: if_spi, driver for libertas GSPI devices
From: Dan Williams <dcbw@redhat.com>
To: Angel Roman <angel.roman@mdesystems.com>
Cc: Colin McCabe <colin@cozybit.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org,
	Andrey Yurovsky <andrey@cozybit.com>
In-Reply-To: <4947241F.10305@mdesystems.com>
References: <1229398052-27465-1-git-send-email-colin@cozybit.com>
	 <1229398052-27465-2-git-send-email-colin@cozybit.com>
	 <1229398052-27465-3-git-send-email-colin@cozybit.com>
	 <1229398052-27465-4-git-send-email-colin@cozybit.com>
	 <4947241F.10305@mdesystems.com>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 12:38:49 -0500
Message-Id: <1229449129.7307.51.camel@localhost.localdomain> (sfid-20081216_184000_232315_F5D11739)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-15 at 22:44 -0500, Angel Roman wrote:
> Hi Colin,
> 
> I have support for the gspi as well. I've been trying to get in contact 
> with Dan Williams in order to contribute it to the list.

Sorry about that... it's in my queue and I'll try to get to do some
review in the next few days.  Doing the new interface isn't a ton of
code, and I'd expect both yours and Colin's drivers to be quite similar
as there's only a few ways this thing can be done :)

The submission process is basically just like Colin did; generate a
series of patches of your latest code (split into independent patches if
possible) based on a kernel version (ideally the latest kernel version
or better yet, wireless-testing.git) and then post it to linux-wireless
and maybe cc libertas-dev as well.

> If you want, you can take a look at the code via:
> 
>  svn list -R 
> svn://svn.buglabs.net/bug/trunk/bug-linux-2.6.27.2/drivers/net/wireless/libertas 
> 
> 
> This is currently working in the mx31 processor. Maybe we can work out a 
> way to merge the two drivers. The mx31 was a little tricky since there's 
> an error in the processor where one is not able to keep the chip select 
> signal active during multiple spi transfers as requried by the wifi 
> module. I've also abstracted the board interface from the GSPI code as 
> much as I could.

Is there a generic SPI layer that could be used for the board-specific
bits too, rather than putting that stuff in the libertas tree?  I assume
that the SPI bus is more or less generic on your hardware (ie you could
put something else on the other end instead of the 8686), and thus it
would be better if we could figure out way not to put some much board
specific logic into the libertas driver itself.

Dan

