Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49688 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab0HCORi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 10:17:38 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=vhWV1RNyemtfppfjvLYAbzd3aRjFOVgLLpG3Z@mail.gmail.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<1279733634-21974-4-git-send-email-ohad@wizery.com>
	<AANLkTimzA_JJ-byTDWznbL3YzeJ8LAP4M50onf2_3fBF@mail.gmail.com>
	<AANLkTi=Oy8X1xMOwWL_cKBB1LWULT6=p+adUgB+AuSJS@mail.gmail.com>
	<AANLkTi=BUX59heXAW2Uf4wZo2dSS19Je54dkQ5u2YGAW@mail.gmail.com>
	<AANLkTimZQKj7H_GeE=+O9cwxEMTR+LhfFbt=AyXGzN3d@mail.gmail.com>
	<AANLkTikfRja-h9mz7uyRXCZNZjKdU_yB8e58XQucUzrn@mail.gmail.com>
	<AANLkTi=vhWV1RNyemtfppfjvLYAbzd3aRjFOVgLLpG3Z@mail.gmail.com>
Date: Tue, 3 Aug 2010 16:17:37 +0200
Message-ID: <AANLkTin4m8gJR50zwMB2b0jRMHdNA6CQToKBTAhOL9wF@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] mmc: support embedded data field in mmc_host
From: Vitaly Wool <vitalywool@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Pandita Vikram <vikram.pandita@ti.com>, linux@arm.linux.org.uk,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ohad,

On Mon, Aug 2, 2010 at 11:35 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:

> I'm honestly trying to understand your concerns, but I'm afraid that
> just saying "it's a hack" is not too informative. Can you please
> explain what do you think is technically wrong with the proposed
> solution ? is it not general enough for other use cases ? will it
> break something ?

let's summarize the solution you're proposing.

You're trying to add embedded_data which will be scattered all over
the place. The patches you introduce do the following:
- add the pointer to the mmc core header;
- add the primitive to set it from the controller driver;
- add the pointer to the board-specific header;
- add the structure to the board-specific C file and propagate its
pointer to the controller driver;
- add setting the pointer in the core structure into the controller driver.

So if I'd like to set the *same* structure for the *same* WL1271
driver, provided that I'm working with the other platform, I'll need
to do the following:
- add the pointer to the board-specific header;
- add the structure to the board-specific C file and propagate its
pointer to the controller driver;
- add setting the pointer in the core structure into the controller driver.

This is far from being intuitive. This means we need to hack,
generally speaking, all the MMC controller drivers to get it working
on all platforms. This is error prone.

And I'm not even speaking about the fact that MMC controller driver
should not deal with such things at all.

Thanks,
   Vitaly
