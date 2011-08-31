Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8871 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab1HaLtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 07:49:25 -0400
Date: Wed, 31 Aug 2011 17:19:08 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: Re: [PATCH 1/2] ath6kl: Fix endianness with chip register values
Message-ID: <20110831114907.GA1958@vasanth-laptop> (sfid-20110831_134928_207070_4DDBFD1C)
References: <1314785895-18808-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314785895-18808-1-git-send-email-vthiagar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 03:48:14PM +0530, Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/main.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
> index 5e807a9..0bcfd46 100644
> --- a/drivers/net/wireless/ath/ath6kl/main.c
> +++ b/drivers/net/wireless/ath/ath6kl/main.c
> @@ -234,6 +234,7 @@ static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
>  int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value)
>  {
>  	int ret;
> +	__le32 reg_val = 0;
>  
>  	/* set window register to start read cycle */
>  	ret = ath6kl_set_addrwin_reg(ar, WINDOW_READ_ADDR_ADDRESS, address);
> @@ -241,8 +242,10 @@ int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value)
>  		return ret;
>  
>  	/* read the data */
> -	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) value,
> -				  sizeof(*value), HIF_RD_SYNC_BYTE_INC);
> +	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) &reg_val,
> +				  sizeof(reg_val), HIF_RD_SYNC_BYTE_INC);
> +	*value = le32_to_cpu(reg_val);
> +

This would break your fw_log patch where it is assumed that
the register value read through ath6kl_diag_read32() is LE.
Shall I remove endian conversion from your patch and send it
as a separate one which would be part of this series?.
Having endian conversion in a single place would be simple
and bug free.

Vasanth
