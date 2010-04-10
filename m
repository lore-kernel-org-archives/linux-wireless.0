Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:51005 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab0DJU6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Apr 2010 16:58:48 -0400
Received: by ewy20 with SMTP id 20so1599641ewy.1
        for <linux-wireless@vger.kernel.org>; Sat, 10 Apr 2010 13:58:47 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 5/9] rt2x00: Align rt2800 register initialization with vendor driver.
Date: Sat, 10 Apr 2010 22:58:44 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> <201004090033.29518.IvDoorn@gmail.com> <4BC0CDF8.4030609@gmail.com>
In-Reply-To: <4BC0CDF8.4030609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201004102258.45258.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > 
> >> @@ -1214,38 +1243,61 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
> >>  	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 0);
> >>  	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
> >>  
> >> +	rt2800_register_read(rt2x00dev, LED_CFG, &reg);
> >> +	rt2x00_set_field32(&reg, LED_CFG_ON_PERIOD, 70);
> >> +	rt2x00_set_field32(&reg, LED_CFG_OFF_PERIOD, 30);
> >> +	rt2x00_set_field32(&reg, LED_CFG_SLOW_BLINK_PERIOD, 3);
> >> +	rt2x00_set_field32(&reg, LED_CFG_R_LED_MODE, 3);
> >> +	rt2x00_set_field32(&reg, LED_CFG_G_LED_MODE, 3);
> >> +	rt2x00_set_field32(&reg, LED_CFG_Y_LED_MODE, 3);
> >> +	rt2x00_set_field32(&reg, LED_CFG_LED_POLAR, 1);
> >> +	rt2800_register_write(rt2x00dev, LED_CFG, reg);
> > 
> > Same here.
> 
> That's difficult. We have no other function simply manipulating the LED_CFG register.
> There is rt2800_blink_set, but that is working completely different.
> I'd prefer to leave this as is, instead of introducing another small helper.
> 
> > 
> >>  	rt2800_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
> >>  
> >> +	rt2800_register_read(rt2x00dev, TX_RTY_CFG, &reg);
> >> +	rt2x00_set_field32(&reg, TX_RTY_CFG_SHORT_RTY_LIMIT, 15);
> >> +	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_LIMIT, 31);
> >> +	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_THRE, 2000);
> >> +	rt2x00_set_field32(&reg, TX_RTY_CFG_NON_AGG_RTY_MODE, 0);
> >> +	rt2x00_set_field32(&reg, TX_RTY_CFG_AGG_RTY_MODE, 0);
> >> +	rt2x00_set_field32(&reg, TX_RTY_CFG_TX_AUTO_FB_ENABLE, 1);
> >> +	rt2800_register_write(rt2x00dev, TX_RTY_CFG, reg);
> > 
> > And here.
> 
> Same as for LED_CFG. Using rt2800_config_retry_limit would involve setting up a
> complete libconf structure. Seems like a bit of overkill for the purpose.

Ok, we could fix this later because it might not even be required to do this initialization here,
it isn't needed for the other (older) chipsets either. But until the rt2800 drivers have problems
we should stick as close as possible to the original driver. :)

> >> +	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
> >> +		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 1);
> >> +	else if (rt2x00_is_usb(rt2x00dev))
> >> +		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
> > 
> > perhaps:
> > 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, !rt2x00_is_usb(rt2x00dev));
> 
> Hmm, could be. Not too fond of that construction though. I think the somewhat more verbose
> variant I had is clearer and easier to understand what is going on.

Of, but the if-else-if can be replaced with if-else, unless you expect a 4th platform ;)

> >> @@ -1323,6 +1382,15 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
> >>  	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
> >>  
> >>  	rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
> >> +
> >> +	rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
> >> +	rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, 32);
> >> +	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, 32);
> >> +	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_XIFS_TIME, 4);
> >> +	rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, 314);
> >> +	rt2x00_set_field32(&reg, XIFS_TIME_CFG_BB_RXEND_ENABLE, 1);
> >> +	rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
> > 
> > Not really fond of the magical values written to the device, while mac80211
> > sends us the proper values later. This is probably a register initialization ordering issue?
> 
> These magical values come straight from the Ralink vendor driver. As you know that code isn't
> the best documented code we've seen, so I don't know what these magical values actually represent.
> They are just initialization values for the time until we get associated.
> 
> For code clarity in comparison to the Ralink vendor driver I prefer to leave these in.

Ok.

Ivo
