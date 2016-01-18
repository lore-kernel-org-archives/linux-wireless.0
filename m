Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34337 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbcARIOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 03:14:33 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <aspriel@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	David Miller <davem@davemloft.net>
Subject: Re: [PATCH] brcmfmac: fix BRCMF_FW_NVRAM_DEF macro for older gcc compilers
References: <1452958753-12307-1-git-send-email-aspriel@gmail.com>
Date: Mon, 18 Jan 2016 10:14:27 +0200
In-Reply-To: <1452958753-12307-1-git-send-email-aspriel@gmail.com> (Arend van
	Spriel's message of "Sat, 16 Jan 2016 16:39:13 +0100")
Message-ID: <8737tv7198.fsf@kamboji.qca.qualcomm.com> (sfid-20160118_091436_505354_42C04EF8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <aspriel@gmail.com> writes:

> With gcc < 4.3 __UNIQUE_ID does not create unique ids with the macro
> BRCMF_FW_NVRAM_DEF. Fix this by removing the MODULE_FIRMWARE instance
> for the nvram file. This file is not in linux-firmware repo so it may
> not be needed anyway. Otherwise consider this as a temporary fix.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Arend van Spriel <aspriel@gmail.com>

Thanks. Geert, it would be great if you could test this.

Dave, if Geert says the patch is ok do you mind taking this directly? I
would like to fix this build breakage quickly.

https://patchwork.kernel.org/patch/8049181/

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
