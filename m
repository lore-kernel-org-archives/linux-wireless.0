Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60136 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaK0Hpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 02:45:39 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so17472670wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 23:45:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ppc9umm6.fsf@kamboji.qca.qualcomm.com>
References: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
	<87vbm2whoz.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=56six2CEQ6Rzr7yMEM7UVNQ3RX9UpdgmxMEoG0+kDAA@mail.gmail.com>
	<87ppc9umm6.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 27 Nov 2014 08:45:38 +0100
Message-ID: <CA+BoTQ=dt9fMHpCYk6ofX5W4=Ynn7C4t+vCoHHuZM1oF3Ngdtw@mail.gmail.com> (sfid-20141127_084542_742888_3E2864DA)
Subject: Re: [PATCH 1/3] ath10k: embed supported chip ids in hw_params
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 November 2014 at 08:30, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> 2. Have a dedicatd pci-specific structure:
>>
>>  struct ath10k_pci_supported_chip {
>>    u16 dev_id;
>>    u32 chip_id;
>>  };
>>
>>  struct ath10k_pci_supported_chip ath10k_pci_supported_chips[] = {
>>    { QCA988X_2_0_DEVICE_ID, QCA988X_HW_2_0_CHIP_ID_REV },
>>    // ...
>>  };
>>
>> Probably the simplest and has least impact.
>
> Another idea which is a variation of this:
>
> In ath10k_core_register() we iterate through ath10k_hw_params_list and
> make sure that the chip id is supported and if not, bail out. If the
> chip id is found from the array continue the registration process like
> in this patch. Basically this would be a whitelist check.

This won't work because chip ids can overlap between different
hardware designs and you'd get false positives.


Michał
