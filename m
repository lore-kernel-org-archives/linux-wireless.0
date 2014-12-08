Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:51531 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaLHGz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 01:55:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 8/8] ath10k: implement wmi-tlv backend
References: <20141203080803.31187.85059.stgit@potku.adurom.net>
	<20141203081132.31187.53311.stgit@potku.adurom.net>
	<CA+BoTQk=EHwqAT-VFeaQS5Q55HsiycwPfE9p-8dj6v8RZyNmsg@mail.gmail.com>
Date: Mon, 8 Dec 2014 08:54:56 +0200
In-Reply-To: <CA+BoTQk=EHwqAT-VFeaQS5Q55HsiycwPfE9p-8dj6v8RZyNmsg@mail.gmail.com>
	(Michal Kazior's message of "Wed, 3 Dec 2014 14:01:45 +0100")
Message-ID: <87oare4on3.fsf@kamboji.qca.qualcomm.com> (sfid-20141208_075537_184043_1757B6AD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 3 December 2014 at 09:11, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> [...]
>> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
>> index 0f4369e4f358..815d6e27aa53 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -844,6 +844,10 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
>>                 ar->max_num_stations = TARGET_10X_NUM_STATIONS;
>>                 ar->htt.max_num_pending_tx = TARGET_10X_NUM_MSDU_DESC;
>>                 break;
>> +       case ATH10K_FW_WMI_OP_VERSION_TLV:
>> +               ar->max_num_peers = TARGET_TLV_NUM_PEERS;
>> +               ar->max_num_stations = TARGET_TLV_NUM_STATIONS;
>> +               ar->htt.max_num_pending_tx = TARGET_TLV_NUM_MSDU_DESC;
>
> Missing break?

Fixed by folding this:

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 5b33f01fcee5..577a3d76df22 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -919,6 +919,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
                ar->max_num_peers = TARGET_TLV_NUM_PEERS;
                ar->max_num_stations = TARGET_TLV_NUM_STATIONS;
                ar->htt.max_num_pending_tx = TARGET_TLV_NUM_MSDU_DESC;
+               break;
        case ATH10K_FW_WMI_OP_VERSION_UNSET:
        case ATH10K_FW_WMI_OP_VERSION_MAX:
                WARN_ON(1);


-- 
Kalle Valo
