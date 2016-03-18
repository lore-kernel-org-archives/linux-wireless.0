Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59934 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbcCRIuW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 04:50:22 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Marty Faltesek <mfaltesek@google.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mwifiex: fw download does not release sdio bus during
 failure
Date: Fri, 18 Mar 2016 08:50:19 +0000
Message-ID: <cd30cf252c5f4d18b7d72ab59853dcb9@SC-EXCH04.marvell.com> (sfid-20160318_095052_909932_FF9D23D2)
References: <1457997561-14357-1-git-send-email-mfaltesek@google.com>
In-Reply-To: <1457997561-14357-1-git-send-email-mfaltesek@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Marty Faltesek [mailto:mfaltesek@google.com]
> Sent: Tuesday, March 15, 2016 4:49 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org
> Subject: [PATCH] mwifiex: fw download does not release sdio bus during
> failure
> 
> ---
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c
> b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index 4c8cae6..d6ef34f 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -1026,13 +1026,12 @@ static int mwifiex_prog_fw_w_helper(struct
> mwifiex_adapter *adapter,
>  		offset += txlen;
>  	} while (true);
> 
> -	sdio_release_host(card->func);
> -
>  	mwifiex_dbg(adapter, MSG,
>  		    "info: FW download over, size %d bytes\n", offset);
> 
>  	ret = 0;
>  done:
> +	sdio_release_host(card->func);
>  	kfree(fwbuf);
>  	return ret;
>  }
> --
> 2.7.0.rc3.207.g0ac5344

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
