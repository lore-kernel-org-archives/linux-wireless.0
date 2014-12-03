Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63965 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbaLCNBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 08:01:46 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so31227503wiv.11
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2014 05:01:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141203081132.31187.53311.stgit@potku.adurom.net>
References: <20141203080803.31187.85059.stgit@potku.adurom.net>
	<20141203081132.31187.53311.stgit@potku.adurom.net>
Date: Wed, 3 Dec 2014 14:01:45 +0100
Message-ID: <CA+BoTQk=EHwqAT-VFeaQS5Q55HsiycwPfE9p-8dj6v8RZyNmsg@mail.gmail.com> (sfid-20141203_140158_408425_99193AF3)
Subject: Re: [PATCH v4 8/8] ath10k: implement wmi-tlv backend
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 December 2014 at 09:11, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 0f4369e4f358..815d6e27aa53 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -844,6 +844,10 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
>                 ar->max_num_stations = TARGET_10X_NUM_STATIONS;
>                 ar->htt.max_num_pending_tx = TARGET_10X_NUM_MSDU_DESC;
>                 break;
> +       case ATH10K_FW_WMI_OP_VERSION_TLV:
> +               ar->max_num_peers = TARGET_TLV_NUM_PEERS;
> +               ar->max_num_stations = TARGET_TLV_NUM_STATIONS;
> +               ar->htt.max_num_pending_tx = TARGET_TLV_NUM_MSDU_DESC;

Missing break?


Michał
