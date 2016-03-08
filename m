Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39805 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048AbcCHKda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 05:33:30 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [10/14] wireless: cw1200: use __maybe_unused to hide pm functions_
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1456934350-1389172-11-git-send-email-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Solomon Peachy <pizza@shaftnet.org>,
	linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160308103329.5480960885@smtp.codeaurora.org> (sfid-20160308_113424_833955_A50BE50F)
Date: Tue,  8 Mar 2016 10:33:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The cw1200 uses #ifdef to check for CONFIG_PM, but then
> uses SIMPLE_DEV_PM_OPS, which leaves the references out when
> CONFIG_PM_SLEEP is not defined, so we get a warning with
> PM=y && PM_SLEEP=n:
> 
> drivers/net/wireless/st/cw1200/cw1200_spi.c:450:12: error: 'cw1200_spi_suspend' defined but not used [-Werror=unused-function]
> 
> This removes the incorrect #ifdef and instead uses a __maybe_unused
> annotation to let the compiler know it can silently drop
> the function definition.
> 
> For the DEV_PM_OPS definition, we can use an IS_ENABLED() check
> to avoid defining the structure when CONFIG_PM is not set without
> the #ifdef.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
