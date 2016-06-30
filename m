Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35394 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbcF3PH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 11:07:58 -0400
Received: by mail-wm0-f45.google.com with SMTP id v199so225432008wmv.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 08:07:57 -0700 (PDT)
MIME-Version: 1.0
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 30 Jun 2016 17:07:37 +0200
Message-ID: <CAFBinCByYy6axOZ_HerQt5GLVVcz6GU70kR2mm=AW6AnxAr1hw@mail.gmail.com> (sfid-20160630_170806_805353_36907C3D)
Subject: ath9k: EEPROM format / byte swapping
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: kvalo@qca.qualcomm.com, nbd@nbd.name, dev@kresin.me
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a question regarding the ath9k EEPROM format.
Most EEPROM versions have two magic bytes at the beginning, indicating
the endianness of the data in this EEPROM.

Let's take the AR9287 EEPROM as an example:
during ath9k initialization
ath9k/eeprom_9287.c:ath9k_hw_ar9287_check_eeprom is called, which
calls ath9k/eeprom.c:ath9k_hw_nvram_swap_data to:
a) check if a swap is required
b) perform swab16 on the EEPROM data

If a swap was required then ath9k_hw_ar9287_check_eeprom will apply
more swapping (this time selectively, based on the property it will us
swab16 or swab16).
However, it's not doing this with all data but only some!
One example (where the data is not swapped in _check_eeprom) is the
macAddr array in modal_eep_ar9287_header. It is not swapped in
ath9k_hw_ar9287_check_eeprom but read (with the values as they are) in
ath9k/eeprom_9287.c:ath9k_hw_ar9287_get_eeprom
(the same also applies for other values, such as openLoopPwrCntl, etc.)

Is there any documentation how this EEPROM data should look like,
where swapping is required, etc.?
I am trying to figure out if the current implementation of all
eeprom_ops.check_eeprom implementations is correct (or not).


Regards,
Martin
