Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37888 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaGXJeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 05:34:15 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so3590715wiw.12
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 02:34:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871ttbrtp8.fsf@kamboji.qca.qualcomm.com>
References: <87mwc0ro8i.fsf@kamboji.qca.qualcomm.com>
	<1406136773-19957-1-git-send-email-sw@simonwunderlich.de>
	<871ttbrtp8.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 24 Jul 2014 11:34:12 +0200
Message-ID: <CA+BoTQkmEoJ4TTDvBE9cagUGRFPKWVBFjGcyXfMsHHD9-bdDJA@mail.gmail.com> (sfid-20140724_113419_278635_0BDC0352)
Subject: Re: [PATCHv3-ath-resend 2/2] ath10k: add spectral scan feature
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 July 2014 11:29, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Simon Wunderlich <sw@simonwunderlich.de> writes:
>
>> Adds the spectral scan feature for ath10k. The spectral scan is triggered by
>> configuring a mode through a debugfs control file. Samples can be gathered via
>> another relay debugfs file.
>>
[...]
>> @@ -800,8 +800,6 @@ int ath10k_core_start(struct ath10k *ar)
>>       else
>>               ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
>>
>> -     INIT_LIST_HEAD(&ar->arvifs);
>> -
>>       if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags)) {
>>               ath10k_info("%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
>>                           ar->hw_params.name,
>> @@ -1084,6 +1082,12 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
>>       INIT_WORK(&ar->register_work, ath10k_core_register_work);
>>       INIT_WORK(&ar->restart_work, ath10k_core_restart);
>>
>> +     INIT_LIST_HEAD(&ar->arvifs);
>
> I'm a bit suspicious about this, why is it needed?

Good hunch. ar->arvifs must be re-initialized in core_start for
recovery to work correctly.


Michał
