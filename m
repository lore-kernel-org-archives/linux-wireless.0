Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36990 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbcBWMwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 07:52:44 -0500
Received: by mail-wm0-f53.google.com with SMTP id g62so208590936wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 04:52:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87fv0uq6p7.fsf@kamboji.qca.qualcomm.com>
References: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
	<87fv0uq6p7.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 23 Feb 2016 13:52:42 +0100
Message-ID: <CALhHN=orRg2mkjcJ1TGssjEocNrRWEhhDV=SKGYANQ-c+YEyzA@mail.gmail.com> (sfid-20160223_135247_906079_10B9A09A)
Subject: Re: [PATCH 1/4] ath10k: remove supported chain mask
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 October 2015 at 12:01, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
>
>> Removing supported chainmask fields as it can be always derived
>> from num_rf_chains.
>>
>> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>
Hello,

This one break monitor mode for qca988x and 10.x firmware:
After Revert "ath10k: remove supported chain mask" - works correctly.

[  997.415152] ath10k_pci 0000:03:00.0: mac create vdev 0 map ffff
[  997.415154] ath10k_pci 0000:03:00.0: mac vdev create 0 (add
interface) type 4 subtype 0 bcnmode per-skb
[  997.415156] ath10k_pci 0000:03:00.0: WMI vdev create: id 0 type 4
subtype 0 macaddr 00:00:00:00:00:00
[  997.415157] ath10k_pci 0000:03:00.0: vdev param 0 not supported by firmware
[  997.415161] ath10k_pci 0000:03:00.0: wmi vdev id 0x0 set param 32 value 2
[  997.415163] ath10k_pci 0000:03:00.0: wmi vdev id 0x0 set param 1 value -1
[  997.415254] ath10k_pci 0000:03:00.0: mac txpower 0
[  997.415269] ath10k_pci 0000:03:00.0: wmi pdev set param 3 value 0
[  997.415423] ath10k_pci 0000:03:00.0: firmware crashed! (uuid
d11e90aa-0f2a-433a-bcb4-eac63c6b7fdc)
[  997.424369] ath10k_pci 0000:03:00.0: qca988x hw2.0 target
0x4100016c chip_id 0x043022ff sub 168c:3342
[  997.424371] ath10k_pci 0000:03:00.0: kconfig debug 1 debugfs 1
tracing 1 dfs 1 testmode 0
[  997.424498] ath10k_pci 0000:03:00.0: firmware ver 10.1.467 api 2
features wmi-10.x,has-wmi-mgmt-tx crc32 ba069298
[  997.424501] ath10k_pci 0000:03:00.0: board_file api 1 bmi_id N/A
crc32 bebc7c08
[  997.424503] ath10k_pci 0000:03:00.0: htt-ver 2.1 wmi-op 2 htt-op 2
cal otp max-sta 128 raw 0 hwcrypto 1
[  997.426528] ath10k_pci 0000:03:00.0: firmware register dump:
[  997.432176] ath10k_pci 0000:03:00.0: [00]: 0x4100016C 0x00000000
0x0097F8D2 0x00000000
[  997.440076] ath10k_pci 0000:03:00.0: [04]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.447975] ath10k_pci 0000:03:00.0: [08]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.455875] ath10k_pci 0000:03:00.0: [12]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.463774] ath10k_pci 0000:03:00.0: [16]: 0x00000000 0x00000000
0x00000000 0x0097F8D2
[  997.471675] ath10k_pci 0000:03:00.0: [20]: 0x00000000 0x00401930
0x00000000 0x00000000
[  997.479574] ath10k_pci 0000:03:00.0: [24]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.487473] ath10k_pci 0000:03:00.0: [28]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.495374] ath10k_pci 0000:03:00.0: [32]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.503273] ath10k_pci 0000:03:00.0: [36]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.511172] ath10k_pci 0000:03:00.0: [40]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.519072] ath10k_pci 0000:03:00.0: [44]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.526971] ath10k_pci 0000:03:00.0: [48]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.534871] ath10k_pci 0000:03:00.0: [52]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.542772] ath10k_pci 0000:03:00.0: [56]: 0x00000000 0x00000000
0x00000000 0x00000000
[  997.550714] ath10k_pci 0000:03:00.0: failed to set 2g txpower 0: -108
[  997.550715] ath10k_pci 0000:03:00.0: failed to setup tx power 0: -108
[  997.550717] ath10k_pci 0000:03:00.0: failed to recalc tx power: -108
[  997.550718] ath10k_pci 0000:03:00.0: WMI vdev delete id 0

BR
Janusz
