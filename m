Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36386 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932926AbeGCPkf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 11:40:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, Rakesh Pillai <pillair@codeaurora.org>
Subject: Re: [PATCH v2 2/6] ath10k: Add support to create boardname for non-bmi target
References: <20180605123448.32331-1-govinds@codeaurora.org>
Date: Tue, 03 Jul 2018 18:40:30 +0300
In-Reply-To: <20180605123448.32331-1-govinds@codeaurora.org> (Govind Singh's
        message of "Tue, 5 Jun 2018 18:04:48 +0530")
Message-ID: <87sh50nx8x.fsf@kamboji.qca.qualcomm.com> (sfid-20180703_174058_646022_8BD01BE6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> writes:

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

Why not just use %d? What benefit would hexadecimal format bring?

And why %02 and %03? I don't see the need for that.

-- 
Kalle Valo
