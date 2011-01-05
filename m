Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45983 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1AERs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 12:48:29 -0500
Message-ID: <4D24AEE3.6030202@candelatech.com>
Date: Wed, 05 Jan 2011 09:48:19 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Show some live tx-queue values in debugfs.
References: <1291744549-7646-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1291744549-7646-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2010 09:55 AM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> I thought this might help track down stuck queues, etc.

Any comments on this one?  Seems it was never picked up...

Thanks,
Ben

>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
> ---
> :100644 100644 3586c43... 5075faa... M	drivers/net/wireless/ath/ath9k/debug.c
>   drivers/net/wireless/ath/ath9k/debug.c |   16 ++++++++++++++++
>   1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> index 3586c43..5075faa 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.c
> +++ b/drivers/net/wireless/ath/ath9k/debug.c
> @@ -589,6 +589,16 @@ static const struct file_operations fops_wiphy = {
>   		sc->debug.stats.txstats[WME_AC_VO].elem); \
>   } while(0)
>
> +#define PRX(str, elem)							\
> +do {									\
> +	len += snprintf(buf + len, size - len,				\
> +			"%s%13u%11u%10u%10u\n", str,			\
> +			(unsigned int)(sc->tx.txq[WME_AC_BE].elem),	\
> +			(unsigned int)(sc->tx.txq[WME_AC_BK].elem),	\
> +			(unsigned int)(sc->tx.txq[WME_AC_VI].elem),	\
> +			(unsigned int)(sc->tx.txq[WME_AC_VO].elem));	\
> +} while(0)
> +
>   static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
>   			      size_t count, loff_t *ppos)
>   {
> @@ -619,6 +629,12 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
>   	PR("TX-Pkts-All:     ", tx_pkts_all);
>   	PR("TX-Bytes-All:    ", tx_bytes_all);
>
> +	PRX("axq-qnum:        ", axq_qnum);
> +	PRX("axq-depth:       ", axq_depth);
> +	PRX("axq-stopped      ", stopped);
> +	PRX("tx-in-progress   ", axq_tx_inprogress);
> +	PRX("pending-frames   ", pending_frames);
> +
>   	if (len>  size)
>   		len = size;
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

