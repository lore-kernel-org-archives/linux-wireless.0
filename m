Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:36677 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751974Ab1ITAEV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 20:04:21 -0400
Subject: Re: [PATCH 20/20] staging: brcm80211: reduced checkpatch warnings
 to zero
From: Joe Perches <joe@perches.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Date: Mon, 19 Sep 2011 17:04:19 -0700
In-Reply-To: <1316467568-27683-21-git-send-email-frankyl@broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	 <1316467568-27683-21-git-send-email-frankyl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1316477060.27998.4.camel@Joe-Laptop> (sfid-20110920_020424_362903_5428D56B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-19 at 14:26 -0700, Franky Lin wrote:
> Both community and Broadcom patches introduced checkpatch warnings.
> ---
> diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> index 1cbdb80..bff5066 100644
> --- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> +++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> @@ -96,7 +96,8 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
>  						    (sdiodev->func[2]);
>  						if (err_ret)
>  							brcmf_dbg(ERROR,
> -								  "enable F2 failed:%d\n",
> +								  "enable F2 "
> +								  "failed:%d\n",

Just about all of this patch is not good.

Splitting format strings is poor style, makes
error messages difficult to find via grep and
is error prone.

You should update your checkpatch version.
Current checkpatch doesn't warn about this.

It'd be better if you could find some way
to reduce the 6 tab indentation rather than
split 20 char format strings into pieces.

> @@ -105,7 +106,8 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
> -								  "Disable F2 failed:%d\n",
> +								  "Disable F2 "
> +								  "failed:%d\n",

etc.


