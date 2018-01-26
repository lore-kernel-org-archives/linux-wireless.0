Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:33639 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752346AbeAZKgj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 05:36:39 -0500
Subject: Re: [PATCH 0/4] ath9k: AR9003 noise floor calibration support
To: Wojciech Dubowik <wojciech.dubowik@neratec.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com
References: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
 <87o9ll57ps.fsf@kamboji.qca.qualcomm.com>
 <b9553f06-b190-c6ec-bb85-587984abfee0@dd-wrt.com>
 <ed47cefe-efa4-a7c9-d017-b50a99316f43@neratec.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <d9e84a77-636e-cd13-7713-9119a4ac971d@dd-wrt.com> (sfid-20180126_113644_577982_22F182F8)
Date: Fri, 26 Jan 2018 11:36:36 +0100
MIME-Version: 1.0
In-Reply-To: <ed47cefe-efa4-a7c9-d017-b50a99316f43@neratec.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 26.01.2018 um 11:27 schrieb Wojciech Dubowik:
> I will try it with again with couple of OEM cards.
this is no card. the eeprom is stored in flash memory. so the chip is a 
9280 pcie chip which is connected on board, but has no own flash memory 
for calibration data. this is stored in system flash memory
>
> Is nanostation calibrated for noisefloor? You can see it with 
> modal_eeprom in debugfs.
root@TRO2:/sys/kernel/debug/ieee80211/phy0/ath9k# cat modal_eeprom
    2GHz modal Header :
  Chain0 Ant. Control :          0
  Chain1 Ant. Control :          0
  Chain2 Ant. Control :          0
  Ant. Common Control :          0
     Chain0 Ant. Gain :          0
     Chain1 Ant. Gain :          0
     Chain2 Ant. Gain :          0
        Switch Settle :         45
     Chain0 TxRxAtten :         11
     Chain1 TxRxAtten :         11
     Chain2 TxRxAtten :         11
    Chain0 RxTxMargin :         11
    Chain1 RxTxMargin :         11
    Chain2 RxTxMargin :         11
     ADC Desired size :        224
     PGA Desired size :          0
     Chain0 xlna Gain :         14
     Chain1 xlna Gain :         14
     Chain2 xlna Gain :         14
        txEndToXpaOff :          0
          txEndToRxOn :          2
       txFrameToXpaOn :         14
       CCA Threshold) :          0
  Chain0 NF Threshold :        202
  Chain1 NF Threshold :        202
  Chain2 NF Threshold :        202
              xpdGain :          9
          External PD :          1
Chain0 I Coefficient :          0
Chain1 I Coefficient :          0
Chain2 I Coefficient :          0
Chain0 Q Coefficient :          0
Chain1 Q Coefficient :          0
Chain2 Q Coefficient :          0
        pdGainOverlap :          6
    Chain0 OutputBias :          2
    Chain0 DriverBias :          2
       xPA Bias Level :          0
  2chain pwr decrease :          0
  3chain pwr decrease :          0
   txFrameToDataStart :         14
        txFrameToPaOn :         14
      HT40 Power Inc. :          2
      Chain0 bswAtten :         21
      Chain1 bswAtten :         21
      Chain2 bswAtten :          0
     Chain0 bswMargin :         31
     Chain1 bswMargin :         31
     Chain2 bswMargin :          0
   HT40 Switch Settle :         44
     Chain0 xatten2Db :          0
     Chain1 xatten2Db :          0
     Chain2 xatten2Db :          0
Chain0 xatten2Margin :          0
Chain1 xatten2Margin :          0
Chain2 xatten2Margin :          0
    Chain1 OutputBias :          2
    Chain1 DriverBias :          2
          LNA Control :         13
       XPA Bias Freq0 :          0
       XPA Bias Freq1 :          0
       XPA Bias Freq2 :          0
    5GHz modal Header :
  Chain0 Ant. Control :         16
  Chain1 Ant. Control :         16
  Chain2 Ant. Control :          0
  Ant. Common Control :        288
     Chain0 Ant. Gain :          0
     Chain1 Ant. Gain :          0
     Chain2 Ant. Gain :          0
        Switch Settle :         45
     Chain0 TxRxAtten :         32
     Chain1 TxRxAtten :         32
     Chain2 TxRxAtten :         11
    Chain0 RxTxMargin :          0
    Chain1 RxTxMargin :          0
    Chain2 RxTxMargin :         16
     ADC Desired size :        226
     PGA Desired size :          0
     Chain0 xlna Gain :         13
     Chain1 xlna Gain :         13
     Chain2 xlna Gain :         13
        txEndToXpaOff :          0
          txEndToRxOn :          2
       txFrameToXpaOn :         14
       CCA Threshold) :         28
  Chain0 NF Threshold :        255
  Chain1 NF Threshold :        255
  Chain2 NF Threshold :        255
              xpdGain :          1
          External PD :          1
Chain0 I Coefficient :          0
Chain1 I Coefficient :          0
Chain2 I Coefficient :          0
Chain0 Q Coefficient :          0
Chain1 Q Coefficient :          0
Chain2 Q Coefficient :          0
        pdGainOverlap :          6
    Chain0 OutputBias :          3
    Chain0 DriverBias :          3
       xPA Bias Level :          2
  2chain pwr decrease :          0
  3chain pwr decrease :          0
   txFrameToDataStart :         14
        txFrameToPaOn :         14
      HT40 Power Inc. :          0
      Chain0 bswAtten :         34
      Chain1 bswAtten :         34
      Chain2 bswAtten :          0
     Chain0 bswMargin :         22
     Chain1 bswMargin :         22
     Chain2 bswMargin :          0
   HT40 Switch Settle :         45
     Chain0 xatten2Db :          0
     Chain1 xatten2Db :          0
     Chain2 xatten2Db :          0
Chain0 xatten2Margin :          0
Chain1 xatten2Margin :          0
Chain2 xatten2Margin :          0
    Chain1 OutputBias :          3
    Chain1 DriverBias :          3
          LNA Control :         13
       XPA Bias Freq0 :          0
       XPA Bias Freq1 :          0
       XPA Bias Freq2 :          0

>
> Wojtek
> On 26/01/18 10:59, Sebastian Gottschall wrote:
>> i dont know if this is a coincidence. but after testing your patch on 
>> a standard ubiquiti nanostation m2 the noise floor looks wrong.
>> it will stay on -112 which is clearly impossible in 2.4 (before it 
>> was around -96)
>
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
