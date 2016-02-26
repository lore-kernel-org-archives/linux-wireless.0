Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43372 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbcBZKsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 05:48:23 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [RESEND] ssb: host_soc depends on sprom
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1456433869-3919332-1-git-send-email-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-arm-kernel@lists.infradead.org, Michael Buesch <m@bues.ch>,
	linux-wireless@vger.kernel.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Message-Id: <20160226104822.9A27C6089A@smtp.codeaurora.org> (sfid-20160226_114852_960224_0D7E8D38)
Date: Fri, 26 Feb 2016 10:48:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


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

Thanks, applied to wireless-drivers.git.

Kalle Valo
