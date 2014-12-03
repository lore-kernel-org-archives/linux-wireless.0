Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43767 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaLCNAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 08:00:00 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so31292903wiv.12
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2014 04:59:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141203081054.31187.10953.stgit@potku.adurom.net>
References: <20141203080803.31187.85059.stgit@potku.adurom.net>
	<20141203081054.31187.10953.stgit@potku.adurom.net>
Date: Wed, 3 Dec 2014 13:59:59 +0100
Message-ID: <CA+BoTQmEG2UQdp=42qHMMQDE04xm2Xnss4su0TNav1Z_RQEX3Q@mail.gmail.com> (sfid-20141203_140006_101905_F86D1D42)
Subject: Re: [PATCH v4 6/8] ath10k: introduce wmi ops
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 December 2014 at 09:10, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index e0999cdaa18f..8c839f68beac 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
[...]
> @@ -612,6 +613,7 @@ struct ath10k {
>                 /* protected by conf_mutex */
>                 const struct firmware *utf;
>                 DECLARE_BITMAP(orig_fw_features, ATH10K_FW_FEATURE_COUNT);
> +               enum ath10k_fw_wmi_op_version orig_wmi_op_version;
>
>                 /* protected by data_lock */
>                 bool utf_monitor;
[...]
> diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
> index 483db9cb8c96..b084f88da102 100644
> --- a/drivers/net/wireless/ath/ath10k/testmode.c
> +++ b/drivers/net/wireless/ath/ath10k/testmode.c
> @@ -187,13 +187,14 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
>
>         memcpy(ar->testmode.orig_fw_features, ar->fw_features,
>                sizeof(ar->fw_features));
> +       ar->testmode.orig_wmi_op_version = ar->wmi.op_version;
>
>         /* utf.bin firmware image does not advertise firmware features. Do
>          * an ugly hack where we force the firmware features so that wmi.c
>          * will use the correct WMI interface.
>          */
>         memset(ar->fw_features, 0, sizeof(ar->fw_features));
> -       __set_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features);
> +       ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
>
>         ret = ath10k_hif_power_up(ar);
>         if (ret) {
> @@ -224,6 +225,7 @@ err_fw_features:
>         /* return the original firmware features */
>         memcpy(ar->fw_features, ar->testmode.orig_fw_features,
>                sizeof(ar->fw_features));
> +       ar->wmi.op_version = ar->testmode.orig_wmi_op_version;
>
>         release_firmware(ar->testmode.utf);
>         ar->testmode.utf = NULL;
> @@ -250,6 +252,7 @@ static void __ath10k_tm_cmd_utf_stop(struct ath10k *ar)
>         /* return the original firmware features */
>         memcpy(ar->fw_features, ar->testmode.orig_fw_features,
>                sizeof(ar->fw_features));
> +       ar->wmi.op_version = ar->testmode.orig_wmi_op_version;
>
>         release_firmware(ar->testmode.utf);
>         ar->testmode.utf = NULL;

Does testmode stuff really belong to this patchset? Shouldn't this be
done in the one that introduces WMI OP version?


Michał
