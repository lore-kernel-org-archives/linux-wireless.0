Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14344 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaGXJp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 05:45:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Simon Wunderlich <sw@simonwunderlich.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	Sven Eckelmann <sven@narfation.org>
Subject: Re: [PATCHv3-ath-resend 2/2] ath10k: add spectral scan feature
References: <87mwc0ro8i.fsf@kamboji.qca.qualcomm.com>
	<1406136773-19957-1-git-send-email-sw@simonwunderlich.de>
	<871ttbrtp8.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkmEoJ4TTDvBE9cagUGRFPKWVBFjGcyXfMsHHD9-bdDJA@mail.gmail.com>
Date: Thu, 24 Jul 2014 12:45:21 +0300
In-Reply-To: <CA+BoTQkmEoJ4TTDvBE9cagUGRFPKWVBFjGcyXfMsHHD9-bdDJA@mail.gmail.com>
	(Michal Kazior's message of "Thu, 24 Jul 2014 11:34:12 +0200")
Message-ID: <87wqb3qedq.fsf@kamboji.qca.qualcomm.com> (sfid-20140724_114532_362729_1ABF92EF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 24 July 2014 11:29, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Simon Wunderlich <sw@simonwunderlich.de> writes:
>>
>>> Adds the spectral scan feature for ath10k. The spectral scan is triggered by
>>> configuring a mode through a debugfs control file. Samples can be gathered via
>>> another relay debugfs file.
>>>
> [...]
>>> @@ -800,8 +800,6 @@ int ath10k_core_start(struct ath10k *ar)
>>>       else
>>>               ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
>>>
>>> -     INIT_LIST_HEAD(&ar->arvifs);
>>> -
>>>       if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags)) {
>>>               ath10k_info("%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
>>>                           ar->hw_params.name,
>>> @@ -1084,6 +1082,12 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
>>>       INIT_WORK(&ar->register_work, ath10k_core_register_work);
>>>       INIT_WORK(&ar->restart_work, ath10k_core_restart);
>>>
>>> +     INIT_LIST_HEAD(&ar->arvifs);
>>
>> I'm a bit suspicious about this, why is it needed?
>
> Good hunch. ar->arvifs must be re-initialized in core_start for
> recovery to work correctly.

Thanks for the confirmation. I think I found a way to rework the
spectral initialisation which also fixes this issue, I'll send a new
version later today. Need to run some tests first.

-- 
Kalle Valo
