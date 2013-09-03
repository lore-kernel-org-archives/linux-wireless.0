Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47415 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759455Ab3ICHFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 03:05:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] ath10k: update wal_dbg_tx_stats structure with missing parameter.
References: <1377778061-22331-1-git-send-email-bartosz.markowski@tieto.com>
	<1377778061-22331-2-git-send-email-bartosz.markowski@tieto.com>
Date: Tue, 3 Sep 2013 10:05:04 +0300
In-Reply-To: <1377778061-22331-2-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Thu, 29 Aug 2013 14:07:39 +0200")
Message-ID: <87eh961j33.fsf@kamboji.qca.qualcomm.com> (sfid-20130903_090514_220246_E19C976F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> It's very imporatant to keep these structs up to date with FW abi,
> due to the arithmetic we use while read the fw_stats.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.h |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
> index 08860c4..5b94707 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -1767,6 +1767,9 @@ struct wal_dbg_tx_stats {
>  	/* wal pdev resets  */
>  	__le32 pdev_resets;
>  
> +	/* frames dropped due to non-availability of stateless TIDs */
> +	__le32 stateless_tid_alloc_failure;
> +
>  	__le32 phy_underrun;

I still wonder if this needs a feature bit. At least you should mention
in the commit log why it's not needed.

-- 
Kalle Valo
