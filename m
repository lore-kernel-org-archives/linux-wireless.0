Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:37909 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbBAXRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 18:17:11 -0500
Received: by mail-ig0-f171.google.com with SMTP id r10so14440747igi.4
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 15:17:10 -0800 (PST)
Received: from mail-ig0-f171.google.com (mail-ig0-f171.google.com. [209.85.213.171])
        by mx.google.com with ESMTPSA id m77sm5061685iom.38.2015.02.01.15.17.10
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Feb 2015 15:17:10 -0800 (PST)
Received: by mail-ig0-f171.google.com with SMTP id r10so14440701igi.4
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 15:17:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <wrfjk3011bm0.fsf@redhat.com>
References: <1422716904-5208-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<wrfjk3011bm0.fsf@redhat.com>
Date: Mon, 2 Feb 2015 00:17:09 +0100
Message-ID: <CAKXHbyMzt7Z3SffFUGDK_z0Y83_sBGoHO1fHLgWicsL+6EXfrQ@mail.gmail.com> (sfid-20150202_001719_222646_741605BC)
Subject: Re: [PATCH] staging: rtl8723au: hal: HalDMOutSrc8723A_CE: Removed
 variables that is never used
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-02-02 0:00 GMT+01:00 Jes Sorensen <Jes.Sorensen@redhat.com>:
> Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:
>> Variable was assigned a value that was never used.
>> I have also removed all the code that thereby serves no purpose.
>>
>> This was found using a static code analysis program called cppcheck
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c |    6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c b/drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c
>> index 179a1ba..3cbbfb7 100644
>> --- a/drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c
>> +++ b/drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c
>> @@ -743,10 +743,8 @@ static void _PHY_IQCalibrate(struct rtw_adapter *pAdapter, int result[][8], u8 t
>>       /*  Note: IQ calibration must be performed after loading  */
>>       /*              PHY_REG.txt , and radio_a, radio_b.txt   */
>>
>> -     u32 bbvalue;
>> -
>>       if (t == 0) {
>> -             bbvalue = PHY_QueryBBReg(pAdapter, rFPGA0_RFMOD, bMaskDWord);
>> +             PHY_QueryBBReg(pAdapter, rFPGA0_RFMOD, bMaskDWord);
>
> In this particular case, I'd say to get rid of the call completely.
> FPGA0_RFMOD should not have magic side effects just from being read.
>
> Jes
>
>>
>>               /*  Save ADDA parameters, turn Path A ADDA on */
>>               _PHY_SaveADDARegisters(pAdapter, ADDA_REG, pdmpriv->ADDA_backup, IQK_ADDA_REG_NUM);
>> @@ -1047,7 +1045,7 @@ void rtl8723a_phy_iq_calibrate(struct rtw_adapter *pAdapter, bool bReCovery)
>>               bPathAOK = bPathBOK = true;
>>       } else {
>>               RegE94 = RegEB4 = pdmpriv->RegE94 = pdmpriv->RegEB4 = 0x100;    /* X default value */
>> -             RegE9C = RegEBC = pdmpriv->RegE9C = pdmpriv->RegEBC = 0x0;              /* Y default value */
>> +             pdmpriv->RegE9C = pdmpriv->RegEBC = 0x0;                /* Y default value */
>>       }
>>
>>       if ((RegE94 != 0)/*&&(RegEA4 != 0)*/)



Hi

I am sorry, please ignore this.
I will not send any more patches.

Kind regards
Rickard Strandqvist
