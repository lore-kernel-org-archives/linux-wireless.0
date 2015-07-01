Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49690 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbbGAKjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 06:39:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 5/8] ath10k: add 10.4 fw specific htt msg definitions
References: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com>
	<1434984747-24294-6-git-send-email-rmani@qti.qualcomm.com>
Date: Wed, 1 Jul 2015 13:38:58 +0300
In-Reply-To: <1434984747-24294-6-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Mon, 22 Jun 2015 20:22:24 +0530")
Message-ID: <878ub0xiv1.fsf@kamboji.qca.qualcomm.com> (sfid-20150701_123912_660935_F4F57CD0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> New htt event table is added for 10.4 firmware. Following new htt
> events are available only 10.4. adding this to generic htt event
> table,
> 	HTT_T2H_MSG_TYPE_EN_STATS,
> 	HTT_T2H_MSG_TYPE_TX_FETCH_IND,
> 	HTT_T2H_MSG_TYPE_TX_FETCH_CONF,
> 	HTT_T2H_MSG_TYPE_TX_LOW_LATENCY_IND
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

[...]

> @@ -1146,6 +1147,8 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
>  			ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_TLV;
>  			break;
>  		case ATH10K_FW_WMI_OP_VERSION_10_4:
> +			ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_10_4;
> +			break;
>  		case ATH10K_FW_WMI_OP_VERSION_UNSET:
>  		case ATH10K_FW_WMI_OP_VERSION_MAX:
>  			WARN_ON(1);

So this switch block is only to support older firmware versions which do
not have ATH10K_FW_IE_HTT_OP_VERSION yet. 10.4 firmware will always have
it set so we don't need to have any backwards compatibility code for
10.4. I changed this part with the diff below. Please review.

--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1147,8 +1147,6 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
                        ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_TLV;
                        break;
                case ATH10K_FW_WMI_OP_VERSION_10_4:
-                       ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_10_4;
-                       break;
                case ATH10K_FW_WMI_OP_VERSION_UNSET:
                case ATH10K_FW_WMI_OP_VERSION_MAX:
                        WARN_ON(1);

-- 
Kalle Valo
