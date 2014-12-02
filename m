Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62991 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbaLBMQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 07:16:35 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so1264024wid.5
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 04:16:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141201144507.18248.9856.stgit@potku.adurom.net>
References: <20141201144400.18248.62714.stgit@potku.adurom.net>
	<20141201144507.18248.9856.stgit@potku.adurom.net>
Date: Tue, 2 Dec 2014 13:16:33 +0100
Message-ID: <CA+BoTQkXnHnMsLvRt2PnnDCAv8P8gDsJTLNFPmf+CNaDX0frfg@mail.gmail.com> (sfid-20141202_131638_697793_7F509358)
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
> @@ -801,11 +812,24 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
>         }
>
>         if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
> -               ar->max_num_peers = TARGET_10X_NUM_PEERS;
> -               ar->max_num_stations = TARGET_10X_NUM_STATIONS;
> +               if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
> +                       ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_2;
> +               else
> +                       ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
>         } else {
> +               ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_MAIN;
> +       }

You always overwrite ar->wmi.op_version with MAIN if it's not 10.x
which means TLV is/wiil be effectively overwritten.

Perhaps the op_version enum values should start with 1 so that 0 can
be used as "unset" and only in that case should the above fallback be
attempted.


Also, I think it might be a good idea to reset ar->wmi.op_version in
ath10k_core_fetch_firmware_api_n (and api_1 as well) so that if any
attempt fails (e.g. due to IE binary corruption) ar->wmi.op_version
isn't propagated/left unchanged to another fw API attempt.


Michał
