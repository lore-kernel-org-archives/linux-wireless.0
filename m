Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51395 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab2IUQlP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 12:41:15 -0400
Message-ID: <505C98A3.9060109@qca.qualcomm.com> (sfid-20120921_184132_093986_B45D13E5)
Date: Fri, 21 Sep 2012 19:41:07 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] Fix uninitialized variable in ath6kl ath6kl_sdio_enable_scatter
References: <20120903201536.GA16230@one.firstfloor.org>
In-Reply-To: <20120903201536.GA16230@one.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/03/2012 11:15 PM, Andi Kleen wrote:
> gcc 4.8 warns
> 
> /backup/lsrc/git/linux-lto-2.6/drivers/net/wireless/ath/ath6kl/sdio.c:
> In function 'ath6kl_sdio_enable_scatter':
> /backup/lsrc/git/linux-lto-2.6/drivers/net/wireless/ath/ath6kl/sdio.c:748:16:
> warning: 'ret' may be used uninitialized in this function
> [-Wmaybe-uninitialized]
>   if (virt_scat || ret) {
>                 ^
> 
> The variable can indeed be uninitialized when the previous if branch is
> skipped. I just set it to zero for now. I'm not fully sure the fix is
> correct, maybe the || should be an && ? 

>From a quick look || should be correct, but of course I might be missing
something. I think your patch is correct way to fix this.

Thanks, applied to ath6kl.git. I just added "ath6kl:" prefix to the title.

Kalle
