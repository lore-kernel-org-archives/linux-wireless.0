Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:20296 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab0D1P5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 11:57:00 -0400
Received: by fg-out-1718.google.com with SMTP id d23so3847966fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Apr 2010 08:56:59 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Subject: Re: [RFT] ar9170: implement get_survey
Date: Wed, 28 Apr 2010 17:56:48 +0200
Cc: linux-wireless@vger.kernel.org
References: <201004272323.22107.chunkeey@googlemail.com> <4BD76360.2070005@free.fr>
In-Reply-To: <4BD76360.2070005@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004281756.50806.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 April 2010 00:21:20 Benoit PAPILLAULT wrote:
> Christian Lamparter a écrit :
> > This patch adds a basic get_survey for ar9170.
> >
> > Survey data from wlan1
> > 	frequency:	2412 MHz
> > 	noise:		-85 dBm
> >
> > TODO:
> >   Currently, the noise level is updated only by a channel change.
> >   Now, we could simply add another ar9170_set_channel to always get
> >   a fresh result, but then we risk a RF lockup.
> >   
> It seems to be a good start. The code is very similar to what is used in 
> ath9k. Just few questions below.
Naaa, If it was, It would have started with [PATCH] :-D
As you pointed out at the end, there is still some important 
work left on the TODO.

> > ---
> > diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
> > index 45a415e..31ff163 100644
> > --- a/drivers/net/wireless/ath/ar9170/phy.c
> > +++ b/drivers/net/wireless/ath/ar9170/phy.c
> > @@ -1584,6 +1584,31 @@ static int ar9170_calc_noise_dbm(u32 raw_noise)
> >  		return (raw_noise & 0xff) >> 1;
> >  }
> >  
> > +int ar9170_get_noisefloor(struct ar9170 *ar)
> > +{
> > +	static const u32 phy_regs[] = {
> > +		0x1c5864, 0x1c6864, 0x1c7864,
> > +		0x1c59bc, 0x1c69bc, 0x1c79bc };
> >   
> Maybe #define would be more appropriate. Moreover, it's clear in my 
> notes that some ar9170 registers are just ath9k registers + 0x1bc000.
I several files full of #defines for the RF,BB and MAC (and USB) in carl9170.
But I don't want to do mix those, because not all registers in those 
files have been verified & tested yet. 
So I copied the magics values from the original firmware...

> > +	u32 phy_res[ARRAY_SIZE(phy_regs)];
> > +	int err, i;
> > +
> > +	BUILD_BUG_ON(ARRAY_SIZE(phy_regs) != ARRAY_SIZE(ar->noise));
> > +
> > +	err = ar9170_read_mreg(ar, ARRAY_SIZE(phy_regs), phy_regs, phy_res);
> > +	if (err)
> > +		return err;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(phy_regs); i++) {
> > +		ar->noise[i] = ar9170_calc_noise_dbm(
> > +			(phy_res[i] >> 19) & 0x1ff);
> > +
> > +		ar->noise[i + 3] = ar9170_calc_noise_dbm(
> > +			(phy_res[i + 3] >> 23) & 0x1ff);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
> >  		       enum ar9170_rf_init_mode rfi, enum ar9170_bw bw)
> >  {
> > @@ -1708,12 +1733,12 @@ int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
> >  		}
> >  	}
> >  
> > -	for (i = 0; i < 2; i++) {
> > +	for (i = 0; i < 3; i++) {
> >   
> Why using 3 RX channels ? ar9170 is always 2x2, isn't it ? And why read 
> 3 values since only one will be used in ar9170_op_get_survey?
ah, I think that's because the first CCA & EXT_CCA values are the
combinded result of both chains (might have something to do with
Smart Antenna and Maximal Ratio Combining techniques, whoever
I can't give you any reference for that, simply because most
of the papers I have are from Atheros' marketing department ;-) )

Also, this is not a hot path. We can easily save all calibration
results and make them accessible through the debug interface together
with other phy/rf related variables (e.g.: mib counters and ani registers)

> Maybe we should combine the 3 values before reporting a single value ?
> >  		ar->noise[i] = ar9170_calc_noise_dbm(
> > -				(le32_to_cpu(vals[2 + i]) >> 19) & 0x1ff);
> > +				(le32_to_cpu(vals[i + 1]) >> 19) & 0x1ff);
> >  
> > -		ar->noise[i + 2] = ar9170_calc_noise_dbm(
> > -				    (le32_to_cpu(vals[5 + i]) >> 23) & 0x1ff);
> > +		ar->noise[i + 3] = ar9170_calc_noise_dbm(
> > +				    (le32_to_cpu(vals[i + 4]) >> 23) & 0x1ff);
> >  	}
> >  
> >  	ar->channel = channel;
> >   
> Moreover (but my patch for ath9k has the very same error), I think we 
> are reported the noise floor calibration result which is not the noise 
> at all... that might be another story anyway.
True, but hey we've reported these noise figures for a very long time now
and no one complained, so the delta can't be that important in RL :-D.
Of course we could also initiate another NF calibration right here,
but due to the number of people reporting PHY problems with ar9170,
I'm somewhat nervous about that.

Regards,
	Chr
