Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28711 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab1IOOCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 10:02:45 -0400
Message-ID: <4E72057E.8090306@qca.qualcomm.com> (sfid-20110915_160248_686719_C0DE9B25)
Date: Thu, 15 Sep 2011 17:02:38 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Deinitialize wiphy on error.
References: <1316073466-3971-1-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1316073466-3971-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preferable style for the subject is:

ath6kl: deinitialise wiphy on error

On 09/15/2011 10:57 AM, Vivek Natarajan wrote:
> This fixes the panic observed on card removal.

Please add information about the crash. For example, you could copy the
stack trace.

> @@ -853,6 +854,8 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
>  
>  err_off:
>  	ath6kl_sdio_power_off(ar_sdio);
> +err_sdio:
> +	ath6kl_cfg80211_deinit(ar_sdio->ar);
>  err_dma:
>  	kfree(ar_sdio->dma_buffer);
>  err_hif:

err_cfg80211, or something like that, would be a better name for the label.

But this change actually has an architectural issue. The idea is that
sdio.c only calls functions either from hif.h or core.h. It should not
use any functions from cfg80211.c.

A better fix would be to add new set of functions:

ath6kl_core_free() which can be called after ath6kl_core_alloc() is executed

ath6kl_core_cleanup() which can be called after ath6kl_core_init() is
executed. This would replace the current ath6kl_destroy() function.

But I can do the architecture change because it's more work. Please
address the minor issues I commented above and then I can take the patch.

Kalle
