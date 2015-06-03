Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36212 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbFCFEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 01:04:24 -0400
Received: by wibdq8 with SMTP id dq8so77943955wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 22:04:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG5N3qHRtYMkKj=HcuF_Jg0-f8MxqVnEVm55jMNt=1xC_PhLUw@mail.gmail.com>
References: <1433187843-20698-1-git-send-email-cfliu.tw@gmail.com>
	<CA+BoTQmhEUegGBLHv6-CZHAhAQdJUUVSRXs6S5kTW82fLFA5hQ@mail.gmail.com>
	<CAG5N3qHRtYMkKj=HcuF_Jg0-f8MxqVnEVm55jMNt=1xC_PhLUw@mail.gmail.com>
Date: Wed, 3 Jun 2015 07:04:23 +0200
Message-ID: <CA+BoTQk+SGtFHwTMJ6c-Qzu-5NFaLTeX5Bsa_38mHiqLrxWOPw@mail.gmail.com> (sfid-20150603_070431_171433_4D929953)
Subject: Re: [PATCH 1/2] ath10k: add cryptmode param to support sw crypto and
 raw tx injection.
From: Michal Kazior <michal.kazior@tieto.com>
To: "Liu CF/TW" <cfliu.tw@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 June 2015 at 20:21, Liu CF/TW <cfliu.tw@gmail.com> wrote:
> On Tue, Jun 2, 2015 at 12:17 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> On 1 June 2015 at 21:44, David Liu <cfliu.tw@gmail.com> wrote:
>> [...]
>>> --- a/drivers/net/wireless/ath/ath10k/core.h
>>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>>> @@ -91,6 +91,7 @@ struct ath10k_skb_cb {
>>>                 u8 tid;
>>>                 u16 freq;
>>>                 bool is_offchan;
>>> +               bool nohwcrypt;
>>>                 struct ath10k_htt_txbuf *txbuf;
>>>                 u32 txbuf_paddr;
>>>         } __packed htt;
>>> @@ -349,6 +350,7 @@ struct ath10k_vif {
>>>         } u;
>>>
>>>         bool use_cts_prot;
>>> +       bool nohwcrypt;
>>
>> So this is a bit confusing. This is used only for tx policy only,
>> right? It should be named accordingly then. The other nohwcrypt in
>> skb_cb pretty much implies Tx already.
>>
>
> No, it's also for Rx.
> In this patch, in mac.c, if arvif->nohwcrypt is set, ath10k_send_key()
> won't install the actual key to hardware, but a clear key is
> installed. This makes all matching STA's encrypted frame passthrough
> HW and mac80211 can take care of decryption later in host.
> (in patch V2 I will take care of the IEEE80211_HW_SW_CRYPTO_CONTROL setting)

Ah, you're right. I've missed that somehow.


>> [...]
>>> @@ -484,6 +491,12 @@ enum ath10k_dev_flags {
>>>          * waiters should immediately cancel instead of waiting for a time out.
>>>          */
>>>         ATH10K_FLAG_CRASH_FLUSH,
>>> +
>>> +       /* Use Raw mode for Tx and Rx */
>>> +       ATH10K_RAW_MODE,
>>> +
>>> +       /* Disable HW crypto engine */
>>> +       ATH10K_HW_CRYPTO_DISABLED,
>>
>> You're missing the _FLAG prefix. Also this isn't documented well
>> enough. RAW_MODE implies sw crypto rx, no? Perhaps a more fine grained
>> approach would be better:
>
> Thanks. Will fix.
>
> Raw mode doesn't imply SW crypto only.
> Indeed Raw mode is the only way to get sw crypto support, but it also
> supports HW crypto.
> I just tested both HW/SW crypto cases working fine in raw mode.
>
> So my plan for the new cryptmode parameter has 3 values:
>
>        0    Use HW crypto engine only. This uses native WiFi mode Tx/Rx encap
>
>        1    Use SW crypto engine only. This uses raw mode Tx/Rx encap
>
>        2    Supports both SW & HW crypto engine. This uses raw mode Tx/Rx encap.
>
> Once this patch is in, I guess people would only use cryptmode=0 or 1.
> For cryptmode=2, I have subsequent changes to allow per BSS based
> control of HW/SW crypto selection.
> Plan is to make make arvif->nohwcrypt configurable via debugfs or
> nl80211 (subject to review feedback)
>
>>
>>  ATH10K_FLAG_RAW_TX,
>>  ATH10K_FLAG_RAW_RX,
>>  ATH10K_FLAG_SW_TX_CRYPTO,
>>  ATH10K_FLAG_SW_RX_CRYPTO,
>>
>> Obviously not all combinations are valid/doable but I think this will
>> make the code look more obvious.
>>
>
> That would be too many flags and too complex.
> I'd suggest keep the proposed ATH10K_RAW_MODE and ATH10K_HW_CRYPTO_DISABLED.
> Let's make Tx/Rx HW crypto always both enabled or both disabled AFA
> driver is concerned.

Okay. This suggestion was based on my incorrect interpretation of your
patch wrt arvif->nohwcrypt.


>>> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
>>> index 85cca29..37fd2f83 100644
>>> --- a/drivers/net/wireless/ath/ath10k/hw.h
>>> +++ b/drivers/net/wireless/ath/ath10k/hw.h
>>> @@ -296,7 +296,7 @@ enum ath10k_hw_rate_cck {
>>>  #define TARGET_10X_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK 1
>>>  #define TARGET_10X_VOW_CONFIG                  0
>>>  #define TARGET_10X_NUM_MSDU_DESC               (1024 + 400)
>>> -#define TARGET_10X_MAX_FRAG_ENTRIES            0
>>> +#define TARGET_10X_MAX_FRAG_ENTRIES            10
>>
>> This is probably enough at "2" (ath10k doesn't send more than 2 tx
>> fragments now). I assume fw crashes with raw tx if this isn't fixed,
>> correct?
>>
>> Sidenote: I guess TARGET_MAX_FRAG_ENTRIES could be fixed as well. It
>> might make sense for QCA61X4 hw2.1 which still uses the old Rx
>> indication event and might be able to do raw txrx + swcrypto. But I'm
>> a bit reluctant to change this without any testing.
>>
>
> Sure. I change it to 10 because the document I got from QCA says so.
> Since this is a global setting, I will remove this and keep it =0 for
> now so it doesn't affect existing HW based datapath.

Sure. I recall 10.x on QCA988X isn't really picky on this value.
QCA61X4 with wmi-tlv on the other hand needs an adequate value for
this configuration parameter or it'll crash horribly.


> Per QCA, the main issue not changing this would be SW crypto then
> won't be able to handle large Rx AMSDU.
> When HW is not doing Rx decryption, the whole AMSDU needs to be DMA to
> host for SW based decryption & AMSDU subframe deaggregation.

Hmm.. From what I know this setting refers to the max number of Tx
fragments that can be submitted via HTT TX_FRM command eventually to
HW MAC, not Rx fragments.


Michał
