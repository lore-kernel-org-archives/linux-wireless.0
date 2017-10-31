Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:56488 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751446AbdJaPHk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 11:07:40 -0400
Subject: Re: [v3] ath10k: rebuild crypto header in rx data frames
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
References: <1509035774-26553-1-git-send-email-kvalo@qca.qualcomm.com>
 <59b2ec22dc9c4db0bd30a65dba660b1c@euamsexm01a.eu.qualcomm.com>
 <154f13b8-1e77-dbe5-4cb0-81c534dbc40b@dd-wrt.com>
 <52655c07-aba1-525e-8c81-e420eafc329f@dd-wrt.com>
 <8760av1hx8.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <5903661f-1276-5cca-7894-b489e062b78d@dd-wrt.com> (sfid-20171031_160744_613216_108577F8)
Date: Tue, 31 Oct 2017 16:07:37 +0100
MIME-Version: 1.0
In-Reply-To: <8760av1hx8.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 31.10.2017 um 16:00 schrieb Kalle Valo:
> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>
>> the following patchlines in the v3 patch look wrong
>>
>> +               /* ICV */
>> +               if (status->flag & RX_FLAG_ICV_STRIPPED &&
>> +                   enctype != HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)
>> +                       skb_trim(msdu, msdu->len -
>> +                                ath10k_htt_rx_crypto_tail_len(ar,
>> enctype));
>>
>>
>> the enctype != wpa2 isnt enough since it also belongs to ccmp-256,
>> gcmp modes etc.
> 4.14 doesn't support CCMP-256 nor GCMP modes yet. Did you check the
> separate patch for 4.15:

for me ccmp-256 and gcmp works but my current tree is based on a very 
recent mac80211 version

but did not check if this support is included in 4.14 since i'm 
developing embedded wireless firmwares on different kernel versions 
using wireless backports based on recent mac80211 /ath10k etc. versions

>
> https://patchwork.kernel.org/patch/10029097/
thanks for notifying me. havent seen it
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
