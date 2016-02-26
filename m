Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56622 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbcBZHSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 02:18:09 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Michael Buesch <m@bues.ch>,
	linux-wireless@vger.kernel.org,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND] ssb: host_soc depends on sprom
References: <1456433869-3919332-1-git-send-email-arnd@arndb.de>
Date: Fri, 26 Feb 2016 09:18:04 +0200
In-Reply-To: <1456433869-3919332-1-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Thu, 25 Feb 2016 21:57:43 +0100")
Message-ID: <87twkwlz2r.fsf@purkki.adurom.net> (sfid-20160226_081827_159684_E148D2D5)
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

I'm planning to queue this to 4.5.

-- 
Kalle Valo
