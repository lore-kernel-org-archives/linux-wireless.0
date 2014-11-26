Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47049 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaKZHyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 02:54:32 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so2938722wgg.33
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 23:54:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87vbm2whoz.fsf@kamboji.qca.qualcomm.com>
References: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
	<87vbm2whoz.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 26 Nov 2014 08:54:30 +0100
Message-ID: <CA+BoTQ=56six2CEQ6Rzr7yMEM7UVNQ3RX9UpdgmxMEoG0+kDAA@mail.gmail.com> (sfid-20141126_085435_422276_12856AB4)
Subject: Re: [PATCH 1/3] ath10k: embed supported chip ids in hw_params
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 November 2014 at 08:21, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This will make it easier to extend and maintain
>> list of supported hardware.
>>
>> As a requirement this moves chip_id checking a
>> little later because target_version isn't known
>> until BMI can be queried.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> The reason why I originally added the chip_id check was that QCA988X hw
> 1.0 failed badly (ath10k might have even crashed, don't remember
> anymore) and I added this chip_id as an ugly workaround to detect hw1.0
> early. Most likely with this patch the problem comes back again.

Hmm.. good point. I think it mostly failed during firmware transfer to
target but since BMI also needs CE then it might as well fail mid-way.


> I don't know what's a good solution, need to think more. Any ideas?

Hmm.. I have a couple of ideas:

1. Don't use BMI to read target_version. Instead use a register
(assuming there is one). This implies each transport (we have pci only
now) would need to be able to read it somehow unless we support a
fallback to BMI if it wasn't prepped by the transport.

2. Have a dedicatd pci-specific structure:

 struct ath10k_pci_supported_chip {
   u16 dev_id;
   u32 chip_id;
 };

 struct ath10k_pci_supported_chip ath10k_pci_supported_chips[] = {
   { QCA988X_2_0_DEVICE_ID, QCA988X_HW_2_0_CHIP_ID_REV },
   // ...
 };

Probably the simplest and has least impact.

3. Don't use target_version to decide hw_params. Use pci device id
instead. This is a bit of a problem because ath10k_hw_params_list is
in core and is supposed to be transport-agnostic (but should it really
be? I can imagine theoretical usb transport could have devices
reporting identical target_version as a pci one but would need
different firmware files to be used). This probably needs more
thinking through.


Michał
