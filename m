Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43948 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab2ENIlP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 04:41:15 -0400
Received: by obbtb18 with SMTP id tb18so7129548obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 01:41:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn2G67v0rMtQxvqvFpVPwrU2GXR9+zYRutaT8GuRpLoiZQ@mail.gmail.com>
References: <CAOpc7mHADqRcvXgg-8JoVfsoDh0_cZnkqBFS3AadwS6x0gtg7g@mail.gmail.com>
	<CAD2nsn2G67v0rMtQxvqvFpVPwrU2GXR9+zYRutaT8GuRpLoiZQ@mail.gmail.com>
Date: Mon, 14 May 2012 10:41:14 +0200
Message-ID: <CAOpc7mEHhZuFdUzzTzXVdn3-DzWuoi-N02Ts1t2xHdNfAGFZhA@mail.gmail.com> (sfid-20120514_104119_935279_E654828B)
Subject: Re: [BUG, ath9k]: NUL bytes at end of /sys/kernel/debug/ieee80211/phy0/ath9k/modal_eeprom
From: Holger Schurig <holgerschurig@googlemail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

root@/sys/kernel/debug/ieee80211/phy0/ath9k# cat modal_eeprom
   2GHz modal Header :
 Chain0 Ant. Control :          0
 Ant. Common Control :          0
    Chain0 Ant. Gain :          0
       Switch Settle :         44
    Chain0 TxRxAtten :         32
   Chain0 RxTxMargin :          0
    ADC Desired size :        226
    PGA Desired size :          0
    Chain0 xlna Gain :         13
       txEndToXpaOff :          0
         txEndToRxOn :          2
      txFrameToXpaOn :         14
      CCA Threshold) :         28
 Chain0 NF Threshold :        186
             xpdGain :         10
         External PD :          1
Chain0 I Coefficient :          0
Chain0 Q Coefficient :          0
       pdGainOverlap :          6
    O/D Bias Version :          3
      CCK OutputBias :          6
     BPSK OutputBias :          4
     QPSK OutputBias :          4
    16QAM OutputBias :          4
    64QAM OutputBias :          4
    CCK Driver1_Bias :          4
   BPSK Driver1_Bias :          3
   QPSK Driver1_Bias :          3
  16QAM Driver1_Bias :          3
  64QAM Driver1_Bias :          3
    CCK Driver2_Bias :          4
   BPSK Driver2_Bias :          3
   QPSK Driver2_Bias :          3
  16QAM Driver2_Bias :          3
  64QAM Driver2_Bias :          3
      xPA Bias Level :          1
  txFrameToDataStart :         14
       txFrameToPaOn :         14
     HT40 Power Inc. :          0
     Chain0 bswAtten :          0
    Chain0 bswMargin :         31
  HT40 Switch Settle :         44
    Chain0 xatten2Db :          0
Chain0 xatten2Margin :          0
 Ant. Diversity ctl1 :         11
 Ant. Diversity ctl2 :          6
        TX Diversity :          0

root@/sys/kernel/debug/ieee80211/phy0/ath9k# xxd <modal_eeprom | tail -4
0000630: 2036 0a20 2020 2020 2020 2054 5820 4469   6.        TX Di
0000640: 7665 7273 6974 7920 3a20 2020 2020 2020  versity :
0000650: 2020 2030 0a00 0000 0000 0000 0000 0000     0............
0000660: 0000 0000 0000 0000 0000 0000            ............

-- 
http://www.holgerschurig.de
