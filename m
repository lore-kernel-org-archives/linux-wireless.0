Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42960 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaIVKF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 06:05:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: print wmi version info
References: <1411046721-20510-1-git-send-email-michal.kazior@tieto.com>
	<1411046721-20510-2-git-send-email-michal.kazior@tieto.com>
Date: Mon, 22 Sep 2014 13:05:35 +0300
In-Reply-To: <1411046721-20510-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 18 Sep 2014 15:25:19 +0200")
Message-ID: <87fvfkm0ls.fsf@kamboji.qca.qualcomm.com> (sfid-20140922_120600_274138_8BD56ACD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> HTT version is already printed so print WMI
> version as well for consistency.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/debug.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index 3756feb..f1e5916 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -126,14 +126,18 @@ EXPORT_SYMBOL(ath10k_info);
>  
>  void ath10k_print_driver_info(struct ath10k *ar)
>  {
> -	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
> +	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d.%d.%d.%d\n",

Heh, I have been thinking about to add something similar.

But if in the future we add the u32 FW IE for WMI version I would like
to print that as well. I guess we could do that with "%d/%d.%d.%d.%d",
the %d being the u32. The idea here being that both version numbers are
good to know.

But of course for now the above is good, just thinking aloud here.

-- 
Kalle Valo
