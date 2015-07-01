Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12356 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbbGALqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 07:46:49 -0400
Message-ID: <5593D314.1080600@qti.qualcomm.com> (sfid-20150701_134652_824403_C78F132B)
Date: Wed, 1 Jul 2015 17:16:28 +0530
From: rmani <rmani@qti.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 5/8] ath10k: add 10.4 fw specific htt msg definitions
References: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com> <1434984747-24294-6-git-send-email-rmani@qti.qualcomm.com> <878ub0xiv1.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <878ub0xiv1.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/01/2015 04:08 PM, Kalle Valo wrote:
> Raja Mani <rmani@qti.qualcomm.com> writes:
>
>> New htt event table is added for 10.4 firmware. Following new htt
>> events are available only 10.4. adding this to generic htt event
>> table,
>> 	HTT_T2H_MSG_TYPE_EN_STATS,
>> 	HTT_T2H_MSG_TYPE_TX_FETCH_IND,
>> 	HTT_T2H_MSG_TYPE_TX_FETCH_CONF,
>> 	HTT_T2H_MSG_TYPE_TX_LOW_LATENCY_IND
>>
>> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
>
> [...]
>
>> @@ -1146,6 +1147,8 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
>>   			ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_TLV;
>>   			break;
>>   		case ATH10K_FW_WMI_OP_VERSION_10_4:
>> +			ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_10_4;
>> +			break;
>>   		case ATH10K_FW_WMI_OP_VERSION_UNSET:
>>   		case ATH10K_FW_WMI_OP_VERSION_MAX:
>>   			WARN_ON(1);
>
> So this switch block is only to support older firmware versions which do
> not have ATH10K_FW_IE_HTT_OP_VERSION yet. 10.4 firmware will always have
> it set so we don't need to have any backwards compatibility code for
> 10.4. I changed this part with the diff below. Please review.
>
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1147,8 +1147,6 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
>                          ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_TLV;
>                          break;
>                  case ATH10K_FW_WMI_OP_VERSION_10_4:
> -                       ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_10_4;
> -                       break;
>                  case ATH10K_FW_WMI_OP_VERSION_UNSET:
>                  case ATH10K_FW_WMI_OP_VERSION_MAX:
>                          WARN_ON(1);
>

As you suggested, we can ignore htt op version assignment here and use
what comes in firmware IE. I am fine with this change.

--
Raja
