Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51974 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbcCWPwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 11:52:44 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] bcma: fix building without OF_IRQ
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1458206432-3039552-1-git-send-email-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160323155243.D408161506@smtp.codeaurora.org> (sfid-20160323_165303_402274_7582F9A0)
Date: Wed, 23 Mar 2016 15:52:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The bcma driver core can be built with or without DT support, but
> it fails to build when CONFIG_OF=y and CONFIG_OF_IRQ=n, which
> can happen on platforms that do not support IRQ domains.
> 
> ERROR: "irq_create_of_mapping" [drivers/bcma/bcma.ko] undefined!
> ERROR: "of_irq_parse_raw" [drivers/bcma/bcma.ko] undefined!
> ERROR: "of_irq_parse_one" [drivers/bcma/bcma.ko] undefined!
> 
> This adds another compile-time check for OF_IRQ, but also
> gets rid of now unneeded #ifdef checks: Using the simpler
> IS_ENABLED() check for OF_IRQ also covers the case of not
> having CONFIG_OF enabled. The check for CONFIG_OF_ADDRESS
> was added to allow building on architectures without
> OF_ADDRESS, but that has been addressed already in
> b1d06b60e90c ("of: Provide static inline function for
> of_translate_address if needed").
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied to wireless-drivers.git.

Kalle Valo
