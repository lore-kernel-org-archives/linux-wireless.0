Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38549 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1GRToH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 15:44:07 -0400
Received: by wyg8 with SMTP id 8so2324010wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2011 12:44:06 -0700 (PDT)
Date: Mon, 18 Jul 2011 22:42:15 +0300
From: Dan Carpenter <error27@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 12/19] staging: brcm80211: remove code for unsupported
 chip
Message-ID: <20110718194215.GD4010@shale.localdomain> (sfid-20110718_214411_473551_4D3629ED)
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
 <1310999405-10062-13-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1310999405-10062-13-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 18, 2011 at 04:29:58PM +0200, Arend van Spriel wrote:
> @@ -1058,12 +1028,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
>  		sdio_func_0.num = 0;
>  		sdio_func_0.card = func->card;
>  		gInstance->func[0] = &sdio_func_0;
> -		if (func->device == 0x4) {	/* 4318 */
> -			gInstance->func[2] = NULL;
> -			sd_trace(("NIC found, calling brcmf_sdio_probe...\n"));
> -			ret = brcmf_sdio_probe(&sdmmc_dev);
> -		}
> -		atomic_set(&brcmf_mmc_suspend, false);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Did you intend to delete that?

>  	}
>  

regards,
dan carpenter

