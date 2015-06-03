Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33285 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbbFCRkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 13:40:51 -0400
Received: by igbpi8 with SMTP id pi8so117333703igb.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2015 10:40:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQk+SGtFHwTMJ6c-Qzu-5NFaLTeX5Bsa_38mHiqLrxWOPw@mail.gmail.com>
References: <1433187843-20698-1-git-send-email-cfliu.tw@gmail.com>
 <CA+BoTQmhEUegGBLHv6-CZHAhAQdJUUVSRXs6S5kTW82fLFA5hQ@mail.gmail.com>
 <CAG5N3qHRtYMkKj=HcuF_Jg0-f8MxqVnEVm55jMNt=1xC_PhLUw@mail.gmail.com> <CA+BoTQk+SGtFHwTMJ6c-Qzu-5NFaLTeX5Bsa_38mHiqLrxWOPw@mail.gmail.com>
From: "Liu CF/TW" <cfliu.tw@gmail.com>
Date: Wed, 3 Jun 2015 10:40:11 -0700
Message-ID: <CAG5N3qGejd0z9TMHvtwBDuE7q+Ry4+_ACo6rDLwPnt8ffWc84w@mail.gmail.com> (sfid-20150603_194056_552242_37DD2643)
Subject: Re: [PATCH 1/2] ath10k: add cryptmode param to support sw crypto and
 raw tx injection.
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
>>>> index 85cca29..37fd2f83 100644
>>>> --- a/drivers/net/wireless/ath/ath10k/hw.h
>>>> +++ b/drivers/net/wireless/ath/ath10k/hw.h
>>>> @@ -296,7 +296,7 @@ enum ath10k_hw_rate_cck {
>>>>  #define TARGET_10X_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK 1
>>>>  #define TARGET_10X_VOW_CONFIG                  0
>>>>  #define TARGET_10X_NUM_MSDU_DESC               (1024 + 400)
>>>> -#define TARGET_10X_MAX_FRAG_ENTRIES            0
>>>> +#define TARGET_10X_MAX_FRAG_ENTRIES            10
>>>
>>> This is probably enough at "2" (ath10k doesn't send more than 2 tx
>>> fragments now). I assume fw crashes with raw tx if this isn't fixed,
>>> correct?
>>>
>>> Sidenote: I guess TARGET_MAX_FRAG_ENTRIES could be fixed as well. It
>>> might make sense for QCA61X4 hw2.1 which still uses the old Rx
>>> indication event and might be able to do raw txrx + swcrypto. But I'm
>>> a bit reluctant to change this without any testing.
>>>
>>
>> Sure. I change it to 10 because the document I got from QCA says so.
>> Since this is a global setting, I will remove this and keep it =0 for
>> now so it doesn't affect existing HW based datapath.
>
> Sure. I recall 10.x on QCA988X isn't really picky on this value.
> QCA61X4 with wmi-tlv on the other hand needs an adequate value for
> this configuration parameter or it'll crash horribly.
>
>
>> Per QCA, the main issue not changing this would be SW crypto then
>> won't be able to handle large Rx AMSDU.
>> When HW is not doing Rx decryption, the whole AMSDU needs to be DMA to
>> host for SW based decryption & AMSDU subframe deaggregation.
>
> Hmm.. From what I know this setting refers to the max number of Tx
> fragments that can be submitted via HTT TX_FRM command eventually to
> HW MAC, not Rx fragments.
>

Yeah you are right. I checked the QCA's PDF again and indeed it's for
Tx not for Rx.

David
>
> Michał
