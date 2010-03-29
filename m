Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:35704 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab0C2VAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 17:00:16 -0400
Received: by ewy20 with SMTP id 20so908431ewy.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 14:00:14 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2500usb: fix powersaving random failures
Date: Mon, 29 Mar 2010 23:00:11 +0200
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <201003290956.54234.linux@rainbow-software.org> <4BB103B9.8040100@gmail.com>
In-Reply-To: <4BB103B9.8040100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003292300.12013.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 March 2010, Gertjan van Wingerde wrote:
> On 03/29/10 09:56, Ondrej Zary wrote:
> > This patch seems to fix random powersaving failure where the device state is
> > stuck at 1 (STATE_SLEEP) and does not change to 3 (STATE_AWAKE), resulting in
> > to associate and these error messages:
> > phy0 -> rt2500usb_set_device_state: Error - Device failed to enter state 3 (-16).
> > No probe response from AP xx:xx:xx:xx:xx:xx after 500ms, disconnecting.
> > 
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> Thanks. This looks good, but I'll rehash it against the latest state of affairs of rt2x00,
> so that the disabling of powersaving is undone at the same time.
> 
> John, I'll send you the rehashed patch tomorrow.

Is this change interesting for the other drivers as well?
Anyway, this one gets my Ack:

Acked-By: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> Gertjan.
> 
> > 
> > --- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-20 02:17:57.000000000 +0100
> > +++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-29 09:38:02.000000000 +0200
> > @@ -648,6 +648,10 @@
> >  
> >  		rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 1);
> >  		rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
> > +	} else {
> > +		rt2500usb_register_read(rt2x00dev, MAC_CSR18, &reg);
> > +		rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 0);
> > +		rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
> >  	}
> >  
> >  	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
> > 
> 
> 
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
> 


