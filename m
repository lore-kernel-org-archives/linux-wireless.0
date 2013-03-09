Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57815 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3CIGFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 01:05:49 -0500
Received: by mail-ie0-f174.google.com with SMTP id k10so2960778iea.33
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2013 22:05:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130308162126.GC1409@redhat.com>
References: <CALK7Yahs2=2UkN9uXGbuoWXhvcC1u4-R4xak5cx0ZqKm7OfK+A@mail.gmail.com>
	<20130308162126.GC1409@redhat.com>
Date: Sat, 9 Mar 2013 10:05:48 +0400
Message-ID: <CALK7YajjwBPahgT0Vzz45O8EVc6q7myo2bBgE6u8kbi5s_nN_g@mail.gmail.com> (sfid-20130309_070553_020521_91D5949C)
Subject: Re: RFC: RT3070 TX Power troubles
From: "Alex A. Mihaylov" <minimumlaw@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/8 Stanislaw Gruszka <sgruszka@redhat.com>:
>> +     /*
>> +      * FixMe: Why POWER_BOUND and FREQ_OFFSET_BOUND not init here?
>> +      */
> ???

Sorry! Patch created only for discussion. I not sure in my my
code.Final patch some later.

> Do we also need to init RF_R17 ? Does vendor driver do this ?

Yes. Function  NICInitRT3070RFRegisters in vendor rt3070.c content next code:
if (IS_RT3071(pAd))
{
    /* RF power sequence setup, load RF normal operation-mode setup */
    RT30xxLoadRFNormalModeSetup(pAd);
}
else if (IS_RT3070(pAd))
{
    /* TX_LO1_en, RF R17 register Bit 3 to 0 */
    RT30xxReadRFRegister(pAd, RF_R17, &RFValue);
    RFValue &= (~0x08);
    /* to fix rx long range issue */
    if (pAd->NicConfig2.field.ExternalLNAForG == 0)
    {
        if ((IS_RT3071(pAd) && ((pAd->MACVersion & 0xffff) >= 0x0211))
|| IS_RT3070(pAd))
        {
            RFValue |= 0x20;
        }
    }
    /* set RF_R17_bit[2:0] equal to EEPROM setting at 0x48h */
    if (pAd->TxMixerGain24G >= 1)
    {
        RFValue &= (~0x7);  /* clean bit [2:0] */
        RFValue |= pAd->TxMixerGain24G;
    }
    RT30xxWriteRFRegister(pAd, RF_R17, RFValue);

and function VOID RT30xxLoadRFNormalModeSetup in vendor rt30xx.c

/* TX_LO1_en, RF R17 register Bit 3 to 0*/
RT30xxReadRFRegister(pAd, RF_R17, &RFValue);
RFValue &= (~0x08);
/* to fix rx long range issue*/
if (((pAd->MACVersion & 0xffff) >= 0x0211) &&
(pAd->NicConfig2.field.ExternalLNAForG == 0))
{
    RFValue |= 0x20;
}
    /* set RF_R17_bit[2:0] equal to EEPROM setting at 0x48h*/
    if (pAd->TxMixerGain24G >= 2)
    {
        RFValue &= (~0x7);  /* clean bit [2:0]*/
        RFValue |= pAd->TxMixerGain24G;
    }
RT30xxWriteRFRegister(pAd, RF_R17, RFValue);

But 0x5f for RF_R17... I'm insure.

>> I also found function rt2800_config_channel_rf2xxx without
>> initialisation POWER_BOUND and FREQ_OFFSET_BOUND. May be this also
>> incorrect?
> Not sure, need to check on old vendor driver.

OK. In final patch i don't touch rt2xxx code. I don't have cards with
RT2xxx chips and can't check this in hardwae.

-- 
Alex A. Mihaylov
AKA MinimumLaw
