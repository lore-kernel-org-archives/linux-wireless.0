Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47774 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbcFRNgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2016 09:36:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: fix link error against sdio
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160616090206.932870-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160618133652.BF4046144A@smtp.codeaurora.org> (sfid-20160618_153742_017215_77557B8A)
Date: Sat, 18 Jun 2016 13:36:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:
> Calling sdio_claim_host() from the interface independent part of
> the mwifiex driver is not only a layering violation, but also causes
> a link error if MMC support is disabled, or if CONFIG_MMC=m
> and CONFIG_MWIFIEX=y:
> 
> drivers/net/built-in.o: In function `mwifiex_fw_dpc':
> :(.text+0xff138): undefined reference to `sdio_claim_host'
> :(.text+0xff158): undefined reference to `sdio_release_host'
> 
> The right way to do this is to have the sdio specific code in the
> sdio driver front-end, and we already have a callback pointer that
> we can use for this after exporting the generic fw download
> function from the core driver.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 65c71efe1c59 ("mwifiex: fix racing condition when downloading firmware")

Thanks, 1 patch applied to wireless-drivers-next.git:

2095b1426c9c mwifiex: fix link error against sdio

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9180095/

