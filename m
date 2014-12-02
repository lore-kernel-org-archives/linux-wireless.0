Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36767 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaLBI2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 03:28:35 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so16330528wgh.17
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 00:28:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141201144507.18248.9856.stgit@potku.adurom.net>
References: <20141201144400.18248.62714.stgit@potku.adurom.net>
	<20141201144507.18248.9856.stgit@potku.adurom.net>
Date: Tue, 2 Dec 2014 09:28:34 +0100
Message-ID: <CA+BoTQ=mx2PSX2uDKrN6pk+YN0e8s8Q1xGZpe0yG-4rT+Hn25Q@mail.gmail.com> (sfid-20141202_092838_897578_F2FD2C14)
Subject: Re: [PATCH v3 2/7] ath10k: add ATH10K_FW_IE_WMI_OP_VERSION
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 December 2014 at 15:45, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 514c219263a5..92b04fe73151 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -120,6 +120,7 @@ struct ath10k_mem_chunk {
>  };
>
>  struct ath10k_wmi {
> +       unsigned int op_version;

I wonder - can't we have this as `enum ath10k_fw_wmi_op_version op_version;` ?


> @@ -378,8 +379,9 @@ enum ath10k_fw_features {
>         /* Firmware does not support P2P */
>         ATH10K_FW_FEATURE_NO_P2P = 3,
>
> -       /* Firmware 10.2 feature bit. The ATH10K_FW_FEATURE_WMI_10X feature bit
> -        * is required to be set as well.
> +       /* Firmware 10.2 feature bit. The ATH10K_FW_FEATURE_WMI_10X feature
> +        * bit is required to be set as well. Deprecated, don't use in new
> +        * code.

Just out of curiosity - any plans how long this is going to be
depracated until removed/replaced?


>          */
>         ATH10K_FW_FEATURE_WMI_10_2 = 4,
>
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
> index dfedfd0e0f34..04aaf9af3ca0 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -58,6 +58,16 @@ enum ath10k_fw_ie_type {
>         ATH10K_FW_IE_FEATURES = 2,
>         ATH10K_FW_IE_FW_IMAGE = 3,
>         ATH10K_FW_IE_OTP_IMAGE = 4,
> +
> +       /* WMI "operations" interface version, 32 bit value. Supported from
> +        * FW API 4 and above. */
> +       ATH10K_FW_IE_WMI_OP_VERSION = 5,

Hmm.. shouldn't we bump up the firmware filename from -3 to -4 and try
loading 4..3..2..1?


Michał
