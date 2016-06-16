Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36180 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbcFPLvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 07:51:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wei-Ning Huang <wnhuang@google.com>
Cc: linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [wireless-drivers-next:master 13/19] main.c:undefined reference to `sdio_claim_host'
References: <201606151546.PqypdveZ%fengguang.wu@intel.com>
	<CABicQ-U4HEpkShO+P2RMFsDAt3Fda5YZ6nmxR0rmh7NhrEheZA@mail.gmail.com>
Date: Thu, 16 Jun 2016 14:51:02 +0300
In-Reply-To: <CABicQ-U4HEpkShO+P2RMFsDAt3Fda5YZ6nmxR0rmh7NhrEheZA@mail.gmail.com>
	(Wei-Ning Huang's message of "Wed, 15 Jun 2016 15:20:05 +0800")
Message-ID: <8760t9z715.fsf@kamboji.qca.qualcomm.com> (sfid-20160616_135113_342709_F330C050)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei-Ning Huang <wnhuang@google.com> writes:

> Hi Kalle,

Please send mails to the list, not to me privately

> This patch is replaced by a new version: https://patchwork.kernel.org/patch/
> 9138245/
> and should build fine.

[...]

>     tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/
>     wireless-drivers-next.git master
>     head:   c62d50a4062e586855a68c3acfbc2a2c299270cd
>     commit: 65c71efe1c59c111a7b9e6d9540f111663b975b2 [13/19] mwifiex: fix
>     racing condition when downloading firmware
>     config: x86_64-randconfig-s1-06151332 (attached as .config)
>     compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
>     reproduce:
>             git checkout 65c71efe1c59c111a7b9e6d9540f111663b975b2
>             # save the attached .config to linux build tree
>             make ARCH=x86_64
>
>     All errors (new ones prefixed by >>):
>
>        drivers/built-in.o: In function `mwifiex_fw_dpc':
>     >> main.c:(.text+0x496d83): undefined reference to `sdio_claim_host'
>     >> main.c:(.text+0x496da8): undefined reference to `sdio_release_host'

So I accidentally commited v1 when there was v2 available? It would have
been a very good idea to send a _public_ reply to v1 that I should drop
it, that avoids mistakes like this.

v1: https://patchwork.kernel.org/patch/9123771/

v2: https://patchwork.kernel.org/patch/9138245/

There was no changelog (always add that!), what changed in v2?

I see that Arnd already sent a fix for this patch. Is that enough or do
we need more?

mwifiex: fix link error against sdio

https://patchwork.kernel.org/patch/9180095/

-- 
Kalle Valo
