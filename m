Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35338 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753918AbeFSWqJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 18:46:09 -0400
Received: by mail-lf0-f67.google.com with SMTP id i15-v6so1964208lfc.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 15:46:08 -0700 (PDT)
Date: Wed, 20 Jun 2018 00:46:05 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, Rakesh Pillai <pillair@codeaurora.org>
Subject: Re: [PATCH v2 2/6] ath10k: Add support to create boardname for
 non-bmi target
Message-ID: <20180619224605.GB1635@centauri.lan> (sfid-20180620_004617_778622_951DC4A9)
References: <20180605123448.32331-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180605123448.32331-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked-by: Niklas Cassel <niklas.cassel@linaro.org>

On Tue, Jun 05, 2018 at 06:04:48PM +0530, Govind Singh wrote:
> From: Rakesh Pillai <pillair@codeaurora.org>
> 
> Add support to create the boardname for non-bmi targets
> like WCN3990, which uses qmi for bdf download. This
> boardname is used to parse the board data from board-2.bin.
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 14 ++++++++++++++
>  drivers/net/wireless/ath/ath10k/core.h |  2 ++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 4cf54a7ef09a..8a592019cc4d 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1429,6 +1429,20 @@ static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
>  		goto out;
>  	}
>  
> +	if (ar->id.qmi_ids_valid) {
> +		if (ar->id.qmi_board_id > 0x99)
> +			scnprintf(name, name_len,
> +				  "bus=%s,qmi-board-id=%03x",
> +				  ath10k_bus_str(ar->hif.bus),
> +				  ar->id.qmi_board_id);
> +		else
> +			scnprintf(name, name_len,
> +				  "bus=%s,qmi-board-id=b%02x",
> +				  ath10k_bus_str(ar->hif.bus),
> +				  ar->id.qmi_board_id);
> +		goto out;
> +	}
> +
>  	scnprintf(name, name_len,
>  		  "bus=%s,vendor=%04x,device=%04x,subsystem-vendor=%04x,subsystem-device=%04x%s",
>  		  ath10k_bus_str(ar->hif.bus),
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 951dbdd1c9eb..0a2e4a5c3612 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -940,7 +940,9 @@ struct ath10k {
>  		u32 subsystem_device;
>  
>  		bool bmi_ids_valid;
> +		bool qmi_ids_valid;
>  		u8 bmi_board_id;
> +		u8 qmi_board_id;
>  		u8 bmi_chip_id;
>  
>  		char bdf_ext[ATH10K_SMBIOS_BDF_EXT_STR_LENGTH];
> -- 
> 2.17.0
> 
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
