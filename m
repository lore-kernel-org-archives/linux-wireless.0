Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37328 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732343AbeGJXmP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 19:42:15 -0400
Received: by mail-pf0-f195.google.com with SMTP id x10-v6so7258230pfm.4
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2018 16:40:49 -0700 (PDT)
Date: Tue, 10 Jul 2018 16:40:45 -0700
From: Brian Norris <briannorris@chromium.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: bjorn.andersson@linaro.org, david.brown@linaro.org,
        andy.gross@linaro.org, niklas.cassel@linaro.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: Re: [PATCH v3 2/6] ath10k: Add support to create boardname for
 non-bmi target
Message-ID: <20180710234043.GA40352@ban.mtv.corp.google.com> (sfid-20180711_014111_772270_94AE0728)
References: <20180706085622.27945-1-govinds@codeaurora.org>
 <20180706085622.27945-3-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180706085622.27945-3-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Govind,

On Fri, Jul 06, 2018 at 02:26:19PM +0530, Govind Singh wrote:
> From: Rakesh Pillai <pillair@codeaurora.org>
> 
> Add support to create the boardname for non-bmi targets
> like WCN3990, which uses qmi for bdf download. This
> boardname is used to parse the board data from board-2.bin.
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 8 ++++++++
>  drivers/net/wireless/ath/ath10k/core.h | 2 ++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 85c58ebbfb26..840e301b6a6e 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1440,6 +1440,14 @@ static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
>  		goto out;
>  	}
>  
> +	if (ar->id.qmi_ids_valid) {
> +		scnprintf(name, name_len,
> +			  "bus=%s,qmi-board-id=%x",
> +			  ath10k_bus_str(ar->hif.bus),
> +			  ar->id.qmi_board_id);
> +		goto out;
> +	}
> +
>  	scnprintf(name, name_len,
>  		  "bus=%s,vendor=%04x,device=%04x,subsystem-vendor=%04x,subsystem-device=%04x%s",
>  		  ath10k_bus_str(ar->hif.bus),
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 427ee5752bb0..20f03f3a7080 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -941,7 +941,9 @@ struct ath10k {
>  		u32 subsystem_device;
>  
>  		bool bmi_ids_valid;
> +		bool qmi_ids_valid;
>  		u8 bmi_board_id;
> +		u8 qmi_board_id;

IIUC, QMI board IDs may be more than 8 bits. (And your qmi.c code seems
to suggest this as well.) Should this be u32?

Brian

>  		u8 bmi_chip_id;
>  
>  		char bdf_ext[ATH10K_SMBIOS_BDF_EXT_STR_LENGTH];
> -- 
> 2.17.0
> 
