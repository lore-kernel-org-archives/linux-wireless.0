Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxout1.rambler.ru ([81.19.67.58]:2845 "EHLO mxout1.rambler.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab3DOIXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 04:23:46 -0400
From: "Alex Mihaylov" <minimumlaw@rambler.ru>
To: "Gertjan van Wingerde" <gwingerde@gmail.com>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org
Reply-To: "Alex Mihaylov" <minimumlaw@rambler.ru>
Subject: RE: Re: [PATCH v2] rt2x00: Fix transmit power troubles on some Ralink RT30xx cards
Date: Mon, 15 Apr 2013 12:18:32 +0400
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
In-Reply-To: <CAL1gcdP90HGCPxw_L6mph3D5GoJevg_oJyuBUW9Uxg6N8AfxvA@mail.gmail.com>
Message-Id: <1366013912.676272.13358.5267@saddam4.rambler.ru> (sfid-20130415_102350_662557_9BA3B0F9)
References: <CAL1gcdP90HGCPxw_L6mph3D5GoJevg_oJyuBUW9Uxg6N8AfxvA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Good day!
> > From: "Alex A. Mihaylov" <minimumlaw@rambler.ru>
> > Some cards on Ralink RT30xx chipset not have correctly TX_MIXER_GAIN
> > value in them EEPROM/EFUSE. In this case, we must use default value,
> > but always used EEPROM/EFUSE value. As result we have tranmitt power
> > range from -10dBm to +6dBm instead 0dBm to +16dBm.

> > Signed-off-by: Alex A. Mihaylov <minimumlaw@rambler.ru>
> > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
 
> Could you explain how you have come to this patch?
> Is this behavior of the Ralink provided driver that you replicated
> here, or have you come to this approach in an other way?

Yes, vendor driver have this code in chips/rt3070.c (function NICInitRT3070RFRegisters) and chips/rt30xx.c (function RT30xxLoadRFNormalModeSetup) files.
Look like this:
[skipped]
if (pAd->TxMixerGain24G >= 2)
{
      RFValue &= (~0x7);  /* clean bit [2:0]*/
      RFValue |= pAd->TxMixerGain24G;
}
RT30xxWriteRFRegister(pAd, RF_R17, RFValue);
[skipped]
and have differents only in constants (2 in rt30xx.c and one in tr3070.c). TxPower i messaurment on power detector, connected directly to module.