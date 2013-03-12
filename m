Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43634 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3CLL7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 07:59:10 -0400
Received: by mail-ie0-f175.google.com with SMTP id c12so6248269ieb.34
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 04:59:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130312094218.GA1383@redhat.com>
References: <CALK7Yahs2=2UkN9uXGbuoWXhvcC1u4-R4xak5cx0ZqKm7OfK+A@mail.gmail.com>
	<20130308162126.GC1409@redhat.com>
	<CALK7YajjwBPahgT0Vzz45O8EVc6q7myo2bBgE6u8kbi5s_nN_g@mail.gmail.com>
	<20130312094218.GA1383@redhat.com>
Date: Tue, 12 Mar 2013 15:59:09 +0400
Message-ID: <CALK7YaggBFjUwv_Pm_Zs_mtt6dRCFkHkukaeZKM2Y0tBwhs_gA@mail.gmail.com> (sfid-20130312_125914_657695_4FBD9633)
Subject: Re: RFC: RT3070 TX Power troubles
From: "Alex A. Mihaylov" <minimumlaw@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/12 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Sat, Mar 09, 2013 at 10:05:48AM +0400, Alex A. Mihaylov wrote:
>> 2013/3/8 Stanislaw Gruszka <sgruszka@redhat.com>:
> However I just realized that we probably do not set RF_R49 on vendor
> driver for chips other than 5392. I thought we set RF_R49 in function
> AsicGetAutoAgcOffset() for all chipsets handled by driver, but seems
> I missed IS_RT5392(pAd) branch.

Yes. I found code for modify RF_R49 and RF_R50 in
AsicGetAutoArgcOffset() in vendor driver (called by AsicAdjustTxPower,
called by MlmePeriodicExec). Name of called function
RT30xxReadRFRegister(pAd, RF_R49, &RFValue) and
RT30xxWriteRFRegister(pAd, RF_R49, RFValue) make me stuppid, and I
can't see if (IS_RT5392(pAd)) above.

But RT3070 based module WN8020 start work correctly with this modification.

> I'm using 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
> as source, are you using some other vendor driver sources ?

Yes. I use this vendor source.

> Also could you please elaborate how did you measure TX power?

I use ZX47-40-S+ power detector from http://www.minicircuits.com/
connected to WN8020 antenna output, and 1K load at output of power
detector connected to osciloscope.
Direct pdf datasheet link http://217.34.103.131/pdfs/ZX47-40+.pdf

Os X with Ralink driver show about 580mV on 1K load (about 15dBm)
regardless txpower setup in Ralink wireless utility. Vanilla 3.8.2
driver show 860mV (about 4dBm) if tx power set to 20dBm with iwconfig
wlan0 txpower 20 and 980mV(0dBm) if tx power set to zero with iwconfig
wlan0 txpower 0. Patched driver show about 580mV (15dBm) after setup
20dBm txpower with iwconfig wlan0 txpower 20, and about 980mV(0dBm) if
tx power set to zero with iwconfig wlan0 txpower 0. I send
screenshorts from osciloscpe directly for you some later.

Vendor driver show 580mV (15dBm) if write TxPower=99 into
RT2800STA.dat config file, and 980mV(0dBm) if TxPower set to 100 or 0
in RT2800STA.dat. All other value TxPower placed in this gate.

Unfortunately, no resons to init RF49 in vanilla wireless code. At
this moment I got critical analyse for my code, and still thinking.

>> RT30xxWriteRFRegister(pAd, RF_R17, RFValue);
>> But 0x5f for RF_R17... I'm insure.
> I think we already do this in rt2800_init_rfcsr():

Nice.

> BTW: please cc rt2x00 related patches/emails to users@rt2x00.serialmonkey.com
> (I already do this for this email). List is moderated to non-subscribers,
> so would be good if you subscribe there.

Can you send me some instructions directly? I can't find this mail list.

-- 
Alex A. Mihaylov
AKA MinimumLaw
