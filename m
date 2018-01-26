Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:18393 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751840AbeAZOPD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 09:15:03 -0500
Subject: Re: [PATCH 0/4] ath9k: AR9003 noise floor calibration support
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com
References: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
 <87o9ll57ps.fsf@kamboji.qca.qualcomm.com>
 <b9553f06-b190-c6ec-bb85-587984abfee0@dd-wrt.com>
 <ed47cefe-efa4-a7c9-d017-b50a99316f43@neratec.com>
 <d9e84a77-636e-cd13-7713-9119a4ac971d@dd-wrt.com>
 <b0be6634-de6a-9f24-b48b-88e67ca9eee4@neratec.com>
 <9cb8d3e6-6cd9-ddeb-5099-f9c9d544179a@dd-wrt.com>
From: Wojciech Dubowik <wojciech.dubowik@neratec.com>
Message-ID: <b6c0ec03-3a6d-fcc8-d2ec-bd17ae16a202@neratec.com> (sfid-20180126_151508_516101_6A4B2814)
Date: Fri, 26 Jan 2018 15:15:01 +0100
MIME-Version: 1.0
In-Reply-To: <9cb8d3e6-6cd9-ddeb-5099-f9c9d544179a@dd-wrt.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 26/01/18 12:35, Sebastian Gottschall wrote:
> after reverting your patches all looks normal again. noise is -95
>
> root@TRO2:/sys/kernel/debug/ieee80211/phy0/ath9k# cat dump_nfcal
> Channel Noise Floor : -95
> Chain | privNF | # Readings | NF Readings
>  0       -108    5               -108 -108 -107 -108 -108
>  1       -106    5               -106 -106 -106 -105 -106
I will send a patch which fixes it. I have been taking per chain nominal 
noise
which is not the same as per channel noise.
>
>
> root@TRO2:/sys/kernel/debug/ieee80211/phy0/ath9k# cat modal_eeprom
>    2GHz modal Header :
>  Chain0 Ant. Control :          0
>  Chain1 Ant. Control :          0
>  Chain2 Ant. Control :          0
>  Ant. Common Control :          0
>     Chain0 Ant. Gain :          0
>     Chain1 Ant. Gain :          0
>     Chain2 Ant. Gain :          0
>        Switch Settle :         45
>     Chain0 TxRxAtten :         11
>     Chain1 TxRxAtten :         11
>     Chain2 TxRxAtten :         11
>    Chain0 RxTxMargin :         11
>    Chain1 RxTxMargin :         11
>    Chain2 RxTxMargin :         11
>     ADC Desired size :        224
>     PGA Desired size :          0
>     Chain0 xlna Gain :         14
>     Chain1 xlna Gain :         14
>     Chain2 xlna Gain :         14
>        txEndToXpaOff :          0
>          txEndToRxOn :          2
>       txFrameToXpaOn :         14
>       CCA Threshold) :          0
>  Chain0 NF Threshold :        202
>  Chain1 NF Threshold :        202
>  Chain2 NF Threshold :        202
>              xpdGain :          9
>          External PD :          1
> Chain0 I Coefficient :          0
> Chain1 I Coefficient :          0
> Chain2 I Coefficient :          0
> Chain0 Q Coefficient :          0
> Chain1 Q Coefficient :          0
> Chain2 Q Coefficient :          0
>        pdGainOverlap :          6
>    Chain0 OutputBias :          2
>    Chain0 DriverBias :          2
>       xPA Bias Level :          0
>  2chain pwr decrease :          0
>  3chain pwr decrease :          0
>   txFrameToDataStart :         14
>        txFrameToPaOn :         14
>      HT40 Power Inc. :          2
>      Chain0 bswAtten :         21
>      Chain1 bswAtten :         21
>      Chain2 bswAtten :          0
>     Chain0 bswMargin :         31
>     Chain1 bswMargin :         31
>     Chain2 bswMargin :          0
>   HT40 Switch Settle :         44
>     Chain0 xatten2Db :          0
>     Chain1 xatten2Db :          0
>     Chain2 xatten2Db :          0
> Chain0 xatten2Margin :          0
> Chain1 xatten2Margin :          0
> Chain2 xatten2Margin :          0
>    Chain1 OutputBias :          2
>    Chain1 DriverBias :          2
>          LNA Control :         13
>       XPA Bias Freq0 :          0
>       XPA Bias Freq1 :          0
>       XPA Bias Freq2 :          0
>    5GHz modal Header :
>  Chain0 Ant. Control :         16
>  Chain1 Ant. Control :         16
>  Chain2 Ant. Control :          0
>  Ant. Common Control :        288
>     Chain0 Ant. Gain :          0
>     Chain1 Ant. Gain :          0
>     Chain2 Ant. Gain :          0
>        Switch Settle :         45
>     Chain0 TxRxAtten :         32
>     Chain1 TxRxAtten :         32
>     Chain2 TxRxAtten :         11
>    Chain0 RxTxMargin :          0
>    Chain1 RxTxMargin :          0
>    Chain2 RxTxMargin :         16
>     ADC Desired size :        226
>     PGA Desired size :          0
>     Chain0 xlna Gain :         13
>     Chain1 xlna Gain :         13
>     Chain2 xlna Gain :         13
>        txEndToXpaOff :          0
>          txEndToRxOn :          2
>       txFrameToXpaOn :         14
>       CCA Threshold) :         28
>  Chain0 NF Threshold :        255
>  Chain1 NF Threshold :        255
>  Chain2 NF Threshold :        255
>              xpdGain :          1
>          External PD :          1
> Chain0 I Coefficient :          0
> Chain1 I Coefficient :          0
> Chain2 I Coefficient :          0
> Chain0 Q Coefficient :          0
> Chain1 Q Coefficient :          0
> Chain2 Q Coefficient :          0
>        pdGainOverlap :          6
>    Chain0 OutputBias :          3
>    Chain0 DriverBias :          3
>       xPA Bias Level :          2
>  2chain pwr decrease :          0
>  3chain pwr decrease :          0
>   txFrameToDataStart :         14
>        txFrameToPaOn :         14
>      HT40 Power Inc. :          0
>      Chain0 bswAtten :         34
>      Chain1 bswAtten :         34
>      Chain2 bswAtten :          0
>     Chain0 bswMargin :         22
>     Chain1 bswMargin :         22
>     Chain2 bswMargin :          0
>   HT40 Switch Settle :         45
>     Chain0 xatten2Db :          0
>     Chain1 xatten2Db :          0
>     Chain2 xatten2Db :          0
> Chain0 xatten2Margin :          0
> Chain1 xatten2Margin :          0
> Chain2 xatten2Margin :          0
>    Chain1 OutputBias :          3
>    Chain1 DriverBias :          3
>          LNA Control :         13
>       XPA Bias Freq0 :          0
>       XPA Bias Freq1 :          0
>       XPA Bias Freq2 :          0
>
>
> Am 26.01.2018 um 12:07 schrieb Wojciech Dubowik:
>> Are you sure you have applied path 4 in the series. You should see 
>> calibration piers. Sth like:
>>
>> Calibration data
>> Chain 0
>> Freq     ref    volt    temp    nf_cal    nf_pow    rx_temp
>> 2412    14    0    136    0    0    0
>> 2437    13    0    136    0    0    0
>> 2472    11    0    136    0    0    0
>> Chain 1
>> Freq     ref    volt    temp    nf_cal    nf_pow    rx_temp
>> 2412    11    0    137    0    0    0
>> 2437    11    0    139    0    0    0
>> 2472    10    0    137    0    0    0
>> Chain 2
>> Freq     ref    volt    temp    nf_cal    nf_pow    rx_temp
>> 2412    13    0    138    0    0    0
>> 2437    14    0    139    0    0    0
>> 2472    14    0    139    0    0    0
>>
>> I have just done backports from ath.git and I can see these entries 
>> with my Compex card.
>>
>> Wojtek
>>
>>
>> On 26/01/18 11:36, Sebastian Gottschall wrote:
>>> Am 26.01.2018 um 11:27 schrieb Wojciech Dubowik:
>>>> I will try it with again with couple of OEM cards.
>>> this is no card. the eeprom is stored in flash memory. so the chip 
>>> is a 9280 pcie chip which is connected on board, but has no own 
>>> flash memory for calibration data. this is stored in system flash 
>>> memory
>>>>
>>>> Is nanostation calibrated for noisefloor? You can see it with 
>>>> modal_eeprom in debugfs.
>>> root@TRO2:/sys/kernel/debug/ieee80211/phy0/ath9k# cat modal_eeprom
>>>    2GHz modal Header :
>>>  Chain0 Ant. Control :          0
>>>  Chain1 Ant. Control :          0
>>>  Chain2 Ant. Control :          0
>>>  Ant. Common Control :          0
>>>     Chain0 Ant. Gain :          0
>>>     Chain1 Ant. Gain :          0
>>>     Chain2 Ant. Gain :          0
>>>        Switch Settle :         45
>>>     Chain0 TxRxAtten :         11
>>>     Chain1 TxRxAtten :         11
>>>     Chain2 TxRxAtten :         11
>>>    Chain0 RxTxMargin :         11
>>>    Chain1 RxTxMargin :         11
>>>    Chain2 RxTxMargin :         11
>>>     ADC Desired size :        224
>>>     PGA Desired size :          0
>>>     Chain0 xlna Gain :         14
>>>     Chain1 xlna Gain :         14
>>>     Chain2 xlna Gain :         14
>>>        txEndToXpaOff :          0
>>>          txEndToRxOn :          2
>>>       txFrameToXpaOn :         14
>>>       CCA Threshold) :          0
>>>  Chain0 NF Threshold :        202
>>>  Chain1 NF Threshold :        202
>>>  Chain2 NF Threshold :        202
>>>              xpdGain :          9
>>>          External PD :          1
>>> Chain0 I Coefficient :          0
>>> Chain1 I Coefficient :          0
>>> Chain2 I Coefficient :          0
>>> Chain0 Q Coefficient :          0
>>> Chain1 Q Coefficient :          0
>>> Chain2 Q Coefficient :          0
>>>        pdGainOverlap :          6
>>>    Chain0 OutputBias :          2
>>>    Chain0 DriverBias :          2
>>>       xPA Bias Level :          0
>>>  2chain pwr decrease :          0
>>>  3chain pwr decrease :          0
>>>   txFrameToDataStart :         14
>>>        txFrameToPaOn :         14
>>>      HT40 Power Inc. :          2
>>>      Chain0 bswAtten :         21
>>>      Chain1 bswAtten :         21
>>>      Chain2 bswAtten :          0
>>>     Chain0 bswMargin :         31
>>>     Chain1 bswMargin :         31
>>>     Chain2 bswMargin :          0
>>>   HT40 Switch Settle :         44
>>>     Chain0 xatten2Db :          0
>>>     Chain1 xatten2Db :          0
>>>     Chain2 xatten2Db :          0
>>> Chain0 xatten2Margin :          0
>>> Chain1 xatten2Margin :          0
>>> Chain2 xatten2Margin :          0
>>>    Chain1 OutputBias :          2
>>>    Chain1 DriverBias :          2
>>>          LNA Control :         13
>>>       XPA Bias Freq0 :          0
>>>       XPA Bias Freq1 :          0
>>>       XPA Bias Freq2 :          0
>>>    5GHz modal Header :
>>>  Chain0 Ant. Control :         16
>>>  Chain1 Ant. Control :         16
>>>  Chain2 Ant. Control :          0
>>>  Ant. Common Control :        288
>>>     Chain0 Ant. Gain :          0
>>>     Chain1 Ant. Gain :          0
>>>     Chain2 Ant. Gain :          0
>>>        Switch Settle :         45
>>>     Chain0 TxRxAtten :         32
>>>     Chain1 TxRxAtten :         32
>>>     Chain2 TxRxAtten :         11
>>>    Chain0 RxTxMargin :          0
>>>    Chain1 RxTxMargin :          0
>>>    Chain2 RxTxMargin :         16
>>>     ADC Desired size :        226
>>>     PGA Desired size :          0
>>>     Chain0 xlna Gain :         13
>>>     Chain1 xlna Gain :         13
>>>     Chain2 xlna Gain :         13
>>>        txEndToXpaOff :          0
>>>          txEndToRxOn :          2
>>>       txFrameToXpaOn :         14
>>>       CCA Threshold) :         28
>>>  Chain0 NF Threshold :        255
>>>  Chain1 NF Threshold :        255
>>>  Chain2 NF Threshold :        255
>>>              xpdGain :          1
>>>          External PD :          1
>>> Chain0 I Coefficient :          0
>>> Chain1 I Coefficient :          0
>>> Chain2 I Coefficient :          0
>>> Chain0 Q Coefficient :          0
>>> Chain1 Q Coefficient :          0
>>> Chain2 Q Coefficient :          0
>>>        pdGainOverlap :          6
>>>    Chain0 OutputBias :          3
>>>    Chain0 DriverBias :          3
>>>       xPA Bias Level :          2
>>>  2chain pwr decrease :          0
>>>  3chain pwr decrease :          0
>>>   txFrameToDataStart :         14
>>>        txFrameToPaOn :         14
>>>      HT40 Power Inc. :          0
>>>      Chain0 bswAtten :         34
>>>      Chain1 bswAtten :         34
>>>      Chain2 bswAtten :          0
>>>     Chain0 bswMargin :         22
>>>     Chain1 bswMargin :         22
>>>     Chain2 bswMargin :          0
>>>   HT40 Switch Settle :         45
>>>     Chain0 xatten2Db :          0
>>>     Chain1 xatten2Db :          0
>>>     Chain2 xatten2Db :          0
>>> Chain0 xatten2Margin :          0
>>> Chain1 xatten2Margin :          0
>>> Chain2 xatten2Margin :          0
>>>    Chain1 OutputBias :          3
>>>    Chain1 DriverBias :          3
>>>          LNA Control :         13
>>>       XPA Bias Freq0 :          0
>>>       XPA Bias Freq1 :          0
>>>       XPA Bias Freq2 :          0
>>>
>>>>
>>>> Wojtek
>>>> On 26/01/18 10:59, Sebastian Gottschall wrote:
>>>>> i dont know if this is a coincidence. but after testing your patch 
>>>>> on a standard ubiquiti nanostation m2 the noise floor looks wrong.
>>>>> it will stay on -112 which is clearly impossible in 2.4 (before it 
>>>>> was around -96)
>>>>
>>>>
>>>
>>
>>
>
