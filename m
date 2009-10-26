Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbZJZUCX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 16:02:23 -0400
Subject: Re: libertas sdio firmware
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1256541398.28230.2.camel@johannes.local>
References: <1256541398.28230.2.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 13:02:21 -0700
Message-Id: <1256587341.2110.18.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-10-26 at 08:16 +0100, Johannes Berg wrote:
> Hi,
> 
> Was just looking at the libertas driver and noticed that the SPI part
> loads firmware as such:
> 
> snprintf(helper_fw, IF_SPI_FW_NAME_MAX, "libertas/gspi%d_hlp.bin", ...
> etc.
> 
> while the SDIO part just uses
> ret = request_firmware(&fw, card->helper, &card->func->dev);
> 
> which ends up requesting sd8686_helper.bin instead of
> libertas/sd8686_helper.bin, as far as I can tell. That means the
> linux-firmware git repo won't work out of the box, I think?

Correct.  I stuffed all the firmware into the git repo that I could
find, but because I didn't quite get around to doing firmware name
fallbacks in the driver (so we don't break existing installs) the driver
hasn't been updated yet.

I'd like to do a couple fallbacks actually; something like a priority
ordering of [<old name>, libertas/sd8686_helper_v9.bin,
libertas/sd8686_helper_v8.bin] so that we can use either v8 and v9
firmware if we need to; not all the v9 functionality has been added yet.
v10 is out there too but I haven't seen it in the wild yet.

Dan


