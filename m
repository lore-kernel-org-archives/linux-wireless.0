Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:55021 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbbKBVfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 16:35:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Cho <tony.cho@atmel.com>
Cc: glen lee <glen.lee@atmel.com>, linux-wireless@vger.kernel.org,
	Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Leo Kim <leo.kim@atmel.com>
Subject: Re: [PATCH 00/19] staging/wilc1000 cleanups
Date: Mon, 02 Nov 2015 22:34:57 +0100
Message-ID: <8161154.QXKLTXIdJW@wuerfel> (sfid-20151102_223533_412600_BBEAEFE3)
In-Reply-To: <5629E6F1.502@atmel.com>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de> <56298F43.7000909@atmel.com> <5629E6F1.502@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 October 2015 16:51:13 Tony Cho wrote:
> Hi Arnd,
> First of all, I would like to say "thank you" for your efforts and 
> contributions.
> We are updating the driver because new revision came up and making new 
> patches
> to make it stable and elegant as Linux driver. In these days, we are 
> sending big changes
> while testing such patches and also doing updates at once.
> 
> As you did, we are scheduled to provide the patches making device tree 
> and delete all of platform
> dependencies as you removed WILC_SDIO_IRQ_GPIO as well as other things. 
> So, I would like to
> discuss with you for your series of patch.
> 
> In this time, I think it's important to make the driver to be compiled 
> even if the link problem
> happens as you reported. So, how about deleting all of SPI related files 
> from source tree and
> even from Kconfig for the time being because new bus driver will come or 
> revert
> the Kconfig and then can we expect the best patch in the near feature?
> 
> I respect your efforts and patches, so your opinion is very important to me.

Hi Tony,

I've seen you have merged the patches that you mentioned into Greg's
tree. I have now rebased my patches on top, including the separate SPI
driver. Once we merge those, it should work fine, and having multiple
front-end drivers gives a nice template for adding future hardware
specific variations like another bus, or a newer model on the same
bus. I'll post my patches after some more testing.

	Arnd
