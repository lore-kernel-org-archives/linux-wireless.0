Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64268 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab2ENMCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 08:02:44 -0400
Received: by vbbff1 with SMTP id ff1so4743783vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 05:02:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOpc7mEHhZuFdUzzTzXVdn3-DzWuoi-N02Ts1t2xHdNfAGFZhA@mail.gmail.com>
References: <CAOpc7mHADqRcvXgg-8JoVfsoDh0_cZnkqBFS3AadwS6x0gtg7g@mail.gmail.com>
	<CAD2nsn2G67v0rMtQxvqvFpVPwrU2GXR9+zYRutaT8GuRpLoiZQ@mail.gmail.com>
	<CAOpc7mEHhZuFdUzzTzXVdn3-DzWuoi-N02Ts1t2xHdNfAGFZhA@mail.gmail.com>
Date: Mon, 14 May 2012 17:32:43 +0530
Message-ID: <CAD2nsn1uHJkZCsKPpO=KN0VnJX8kt4iNyYuTg2WOwNoXPYwVfA@mail.gmail.com> (sfid-20120514_140247_815981_07B56541)
Subject: Re: [BUG, ath9k]: NUL bytes at end of /sys/kernel/debug/ieee80211/phy0/ath9k/modal_eeprom
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 14, 2012 at 2:11 PM, Holger Schurig
<holgerschurig@googlemail.com> wrote:
> root@/sys/kernel/debug/ieee80211/phy0/ath9k# cat modal_eeprom
>   2GHz modal Header :
>  Chain0 Ant. Control :          0
>  Ant. Common Control :          0
>    Chain0 Ant. Gain :          0
>       Switch Settle :         44
>    Chain0 TxRxAtten :         32
>   Chain0 RxTxMargin :          0
>    ADC Desired size :        226
>    PGA Desired size :          0
>    Chain0 xlna Gain :         13
>       txEndToXpaOff :          0
>         txEndToRxOn :          2
>      txFrameToXpaOn :         14
>      CCA Threshold) :         28
>  Chain0 NF Threshold :        186
>             xpdGain :         10
>         External PD :          1
> Chain0 I Coefficient :          0
> Chain0 Q Coefficient :          0
>       pdGainOverlap :          6
>    O/D Bias Version :          3
>      CCK OutputBias :          6
>     BPSK OutputBias :          4
>     QPSK OutputBias :          4
>    16QAM OutputBias :          4
>    64QAM OutputBias :          4
>    CCK Driver1_Bias :          4
>   BPSK Driver1_Bias :          3
>   QPSK Driver1_Bias :          3
>  16QAM Driver1_Bias :          3
>  64QAM Driver1_Bias :          3
>    CCK Driver2_Bias :          4
>   BPSK Driver2_Bias :          3
>   QPSK Driver2_Bias :          3
>  16QAM Driver2_Bias :          3
>  64QAM Driver2_Bias :          3
>      xPA Bias Level :          1
>  txFrameToDataStart :         14
>       txFrameToPaOn :         14
>     HT40 Power Inc. :          0
>     Chain0 bswAtten :          0
>    Chain0 bswMargin :         31
>  HT40 Switch Settle :         44
>    Chain0 xatten2Db :          0
> Chain0 xatten2Margin :          0
>  Ant. Diversity ctl1 :         11
>  Ant. Diversity ctl2 :          6
>        TX Diversity :          0
>
> root@/sys/kernel/debug/ieee80211/phy0/ath9k# xxd <modal_eeprom | tail -4
> 0000630: 2036 0a20 2020 2020 2020 2054 5820 4469   6.        TX Di
> 0000640: 7665 7273 6974 7920 3a20 2020 2020 2020  versity :
> 0000650: 2020 2030 0a00 0000 0000 0000 0000 0000     0............
> 0000660: 0000 0000 0000 0000 0000 0000            ............
>
> --
> http://www.holgerschurig.de

oh yes, thanks we will look into it.


-- 
thanks,
shafi
