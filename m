Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55996 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbcBZHLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 02:11:42 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Michael Buesch <m@bues.ch>,
	linux-wireless@vger.kernel.org,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND] ssb: host_soc depends on sprom
References: <1456433869-3919332-1-git-send-email-arnd@arndb.de>
Date: Fri, 26 Feb 2016 09:11:36 +0200
In-Reply-To: <1456433869-3919332-1-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Thu, 25 Feb 2016 21:57:43 +0100")
Message-ID: <8737sgndxz.fsf@purkki.adurom.net> (sfid-20160226_081157_205309_FDBA5B11)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> Drivers that use the SSB sprom functionality typically 'select SSB_SPROM'
> from Kconfig, but CONFIG_SSB_HOST_SOC misses this, which results in
> a build failure unless at least one of the other drivers that selects
> it is enabled:
>
> drivers/built-in.o: In function `ssb_host_soc_get_invariants':
> (.text+0x459494): undefined reference to `ssb_fill_sprom_with_fallback'
>
> This adds the same select statement that is used elsewhere.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 541c9a84cd85 ("ssb: pick SoC invariants code from MIPS BCM47xx arch")
> ---
>  drivers/ssb/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> I just noticed this hasn't shown up in linux-next yet, so I'm resending
> it to ensure it's still on someone's radar. Please ignore the resend
> if it's already in a tree that is not part of linux-next but will
> be merged eventually.
>
> See https://patchwork.linux-mips.org/patch/12091/ for the original
> submission.

Sorry, I didn't notice that linux-wireless was not CCed and I missed the
patch because it was not in my patchwork queue. But the patch is now
there and I should get to it in few days:

https://patchwork.kernel.org/patch/8426571/

-- 
Kalle Valo
