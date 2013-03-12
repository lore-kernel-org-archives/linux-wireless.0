Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab3CLMoP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 08:44:15 -0400
Date: Tue, 12 Mar 2013 13:44:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Alex A. Mihaylov" <minimumlaw@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: RFC: RT3070 TX Power troubles
Message-ID: <20130312124441.GA2775@redhat.com> (sfid-20130312_134419_193621_6B8BB7BD)
References: <CALK7Yahs2=2UkN9uXGbuoWXhvcC1u4-R4xak5cx0ZqKm7OfK+A@mail.gmail.com>
 <20130308162126.GC1409@redhat.com>
 <CALK7YajjwBPahgT0Vzz45O8EVc6q7myo2bBgE6u8kbi5s_nN_g@mail.gmail.com>
 <20130312094218.GA1383@redhat.com>
 <CALK7YaggBFjUwv_Pm_Zs_mtt6dRCFkHkukaeZKM2Y0tBwhs_gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALK7YaggBFjUwv_Pm_Zs_mtt6dRCFkHkukaeZKM2Y0tBwhs_gA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 12, 2013 at 03:59:09PM +0400, Alex A. Mihaylov wrote:
> 2013/3/12 Stanislaw Gruszka <sgruszka@redhat.com>:
> > On Sat, Mar 09, 2013 at 10:05:48AM +0400, Alex A. Mihaylov wrote:
> >> 2013/3/8 Stanislaw Gruszka <sgruszka@redhat.com>:
> > However I just realized that we probably do not set RF_R49 on vendor
> > driver for chips other than 5392. I thought we set RF_R49 in function
> > AsicGetAutoAgcOffset() for all chipsets handled by driver, but seems
> > I missed IS_RT5392(pAd) branch.
> 
> Yes. I found code for modify RF_R49 and RF_R50 in
> AsicGetAutoArgcOffset() in vendor driver (called by AsicAdjustTxPower,
> called by MlmePeriodicExec). Name of called function
> RT30xxReadRFRegister(pAd, RF_R49, &RFValue) and
> RT30xxWriteRFRegister(pAd, RF_R49, RFValue) make me stuppid, and I
> can't see if (IS_RT5392(pAd)) above.
> 
> But RT3070 based module WN8020 start work correctly with this modification.

I think I'm fine with the changes, but maybe they should go
to rt2800_config_txpower().

However, I'm still not sure if Ralink vendor driver initialize RF_R49
register. Perhaps it achieve good power characteristic on 3070 using
other registers? 

> > Also could you please elaborate how did you measure TX power?
> 
> I use ZX47-40-S+ power detector from http://www.minicircuits.com/
> connected to WN8020 antenna output, and 1K load at output of power
> detector connected to osciloscope.
> Direct pdf datasheet link http://217.34.103.131/pdfs/ZX47-40+.pdf

WOW :-)

> Os X with Ralink driver show about 580mV on 1K load (about 15dBm)
> regardless txpower setup in Ralink wireless utility. Vanilla 3.8.2
> driver show 860mV (about 4dBm) if tx power set to 20dBm with iwconfig
> wlan0 txpower 20 and 980mV(0dBm) if tx power set to zero with iwconfig
> wlan0 txpower 0. Patched driver show about 580mV (15dBm) after setup
> 20dBm txpower with iwconfig wlan0 txpower 20, and about 980mV(0dBm) if
> tx power set to zero with iwconfig wlan0 txpower 0. I send
> screenshorts from osciloscpe directly for you some later.

I don't know how to convert mV to dBm, but I believe you :-)

> Unfortunately, no resons to init RF49 in vanilla wireless code. At
> this moment I got critical analyse for my code, and still thinking.

Not sure if I understand that ... 
 
> > BTW: please cc rt2x00 related patches/emails to users@rt2x00.serialmonkey.com
> > (I already do this for this email). List is moderated to non-subscribers,
> > so would be good if you subscribe there.
> 
> Can you send me some instructions directly? I can't find this mail list.

http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com

Thanks
Stanislaw
