Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab3CLJlx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 05:41:53 -0400
Date: Tue, 12 Mar 2013 10:42:19 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Alex A. Mihaylov" <minimumlaw@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: RFC: RT3070 TX Power troubles
Message-ID: <20130312094218.GA1383@redhat.com> (sfid-20130312_104157_168170_A831A35D)
References: <CALK7Yahs2=2UkN9uXGbuoWXhvcC1u4-R4xak5cx0ZqKm7OfK+A@mail.gmail.com>
 <20130308162126.GC1409@redhat.com>
 <CALK7YajjwBPahgT0Vzz45O8EVc6q7myo2bBgE6u8kbi5s_nN_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALK7YajjwBPahgT0Vzz45O8EVc6q7myo2bBgE6u8kbi5s_nN_g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 09, 2013 at 10:05:48AM +0400, Alex A. Mihaylov wrote:
> 2013/3/8 Stanislaw Gruszka <sgruszka@redhat.com>:
> >> +     /*
> >> +      * FixMe: Why POWER_BOUND and FREQ_OFFSET_BOUND not init here?
> >> +      */
> > ???
> 
> Sorry! Patch created only for discussion. I not sure in my my
> code.Final patch some later.

No worries.

However I just realized that we probably do not set RF_R49 on vendor
driver for chips other than 5392. I thought we set RF_R49 in function
AsicGetAutoAgcOffset() for all chipsets handled by driver, but seems
I missed IS_RT5392(pAd) branch.

I'm using 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
as source, are you using some other vendor driver sources ?

Also could you please elaborate how did you measure TX power?

> and function VOID RT30xxLoadRFNormalModeSetup in vendor rt30xx.c
> 
> /* TX_LO1_en, RF R17 register Bit 3 to 0*/
> RT30xxReadRFRegister(pAd, RF_R17, &RFValue);
> RFValue &= (~0x08);
> /* to fix rx long range issue*/
> if (((pAd->MACVersion & 0xffff) >= 0x0211) &&
> (pAd->NicConfig2.field.ExternalLNAForG == 0))
> {
>     RFValue |= 0x20;
> }
>     /* set RF_R17_bit[2:0] equal to EEPROM setting at 0x48h*/
>     if (pAd->TxMixerGain24G >= 2)
>     {
>         RFValue &= (~0x7);  /* clean bit [2:0]*/
>         RFValue |= pAd->TxMixerGain24G;
>     }
> RT30xxWriteRFRegister(pAd, RF_R17, RFValue);
> 
> But 0x5f for RF_R17... I'm insure.

I think we already do this in rt2800_init_rfcsr():

        if (!rt2x00_rt(rt2x00dev, RT5390) &&
            !rt2x00_rt(rt2x00dev, RT5392)) {
                rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
                rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
                if (rt2x00_rt(rt2x00dev, RT3070) ||
                    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
                    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
                    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
                        if (!test_bit(CAPABILITY_EXTERNAL_LNA_BG,
                                      &rt2x00dev->cap_flags))
                                rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
                }
                rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
                                  drv_data->txmixer_gain_24g);
                rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);


BTW: please cc rt2x00 related patches/emails to users@rt2x00.serialmonkey.com
(I already do this for this email). List is moderated to non-subscribers,
so would be good if you subscribe there.

Stanislaw
