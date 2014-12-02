Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:52164 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLBGi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 01:38:28 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so15877708wgh.26
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 22:38:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141201144639.18248.27619.stgit@potku.adurom.net>
References: <20141201144400.18248.62714.stgit@potku.adurom.net>
	<20141201144639.18248.27619.stgit@potku.adurom.net>
Date: Tue, 2 Dec 2014 07:38:26 +0100
Message-ID: <CA+BoTQk2p54jJAxdKS3p3+YyU+6dHibyQ=sxrVpHtwMLjzuU0g@mail.gmail.com> (sfid-20141202_073834_360155_11417DDB)
Subject: Re: [PATCH v3 7/7] ath10k: implement wmi-tlv backend
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 December 2014 at 15:46, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index b1cb90bb4c1c..ac7fbe8605bc 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -833,6 +833,11 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
>                 ar->max_num_stations = TARGET_10X_NUM_STATIONS;
>                 ar->htt.max_num_pending_tx = TARGET_10X_NUM_MSDU_DESC;
>                 break;
> +       case ATH10K_FW_WMI_OP_VERSION_TLV:
> +               ar->max_num_peers = TARGET_TLV_NUM_PEERS;
> +               ar->max_num_stations = TARGET_TLV_NUM_STATIONS;
> +               ar->htt.max_num_pending_tx = TARGET_NUM_MSDU_DESC;

Just a quick note: TARGET_TLV_NUM_MSDU_DESC should be used for
max_num_pending_tx here.


Michał
