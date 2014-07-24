Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43458 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaGXJkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 05:40:40 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so2404688wgh.6
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 02:40:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201407241136.08090.sw@simonwunderlich.de>
References: <87mwc0ro8i.fsf@kamboji.qca.qualcomm.com>
	<1406136773-19957-1-git-send-email-sw@simonwunderlich.de>
	<871ttbrtp8.fsf@kamboji.qca.qualcomm.com>
	<201407241136.08090.sw@simonwunderlich.de>
Date: Thu, 24 Jul 2014 11:40:39 +0200
Message-ID: <CA+BoTQn13tktL9eZi8UD+=WR8fS+FFHML2ab8huvb1QdS49tiQ@mail.gmail.com> (sfid-20140724_114043_998530_1D1B15F7)
Subject: Re: [PATCHv3-ath-resend 2/2] ath10k: add spectral scan feature
From: Michal Kazior <michal.kazior@tieto.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 July 2014 11:36, Simon Wunderlich <sw@simonwunderlich.de> wrote:
>> > @@ -800,8 +800,6 @@ int ath10k_core_start(struct ath10k *ar)
>> >
>> >     else
>> >
>> >             ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
>> >
>> > -   INIT_LIST_HEAD(&ar->arvifs);
>> > -
>> >
>> >     if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags)) {
>> >
>> >             ath10k_info("%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
>> >
>> >                         ar->hw_params.name,
>> >
>> > @@ -1084,6 +1082,12 @@ struct ath10k *ath10k_core_create(void *hif_priv,
>> > struct device *dev,
>> >
>> >     INIT_WORK(&ar->register_work, ath10k_core_register_work);
>> >     INIT_WORK(&ar->restart_work, ath10k_core_restart);
>> >
>> > +   INIT_LIST_HEAD(&ar->arvifs);
>>
>> I'm a bit suspicious about this, why is it needed?
>
> ath10k_spectral_init() clears the spectral_enabled bit for each vif, and
> therefore needs the list to be initialized ... it is also called on firmware
> crash by ath10k_halt, where checking the list is more useful.

You don't really need to clear arvif->spectral_enabled on crash.
arvif's are re-inserted by mac80211 via ath10k_add_interface which
uses memset() to clear everything before adding to ar->arvifs.


Michał
