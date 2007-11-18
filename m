Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:19941 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbXKRQKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2007 11:10:40 -0500
Received: by py-out-1112.google.com with SMTP id u77so5258682pyb
        for <linux-wireless@vger.kernel.org>; Sun, 18 Nov 2007 08:10:35 -0800 (PST)
Message-ID: <c68f135e0711180810v1e059528hdd82c5a1f44c2016@mail.gmail.com> (sfid-20071118_161050_114588_57B9480D)
Date: Sun, 18 Nov 2007 17:10:34 +0100
From: "Andrea Merello" <andreamrl@tiscali.it>
Reply-To: andreamrl@tiscali.it
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: [rtl8185] driver working but some probs
Cc: "Edgar Toernig" <froese@gmx.de>, linux-wireless@vger.kernel.org
In-Reply-To: <200711172257.15418.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071116232001.70a4ae77.froese@gmx.de>
	 <200711172257.15418.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > First thing I noticed: the reported "Link Signal Level"
> > from iwconfig was way off.  It showed values around
> > -170 dBm when it was sitting directly beside the AP.
> > It was easy to fix:
> >
> > -     rx_status.ssi = (flags2 >> 8) & 0x7F;
> > +     rx_status.ssi = (flags2 >> 8) & 0xFF;
> >
> > According to the 8180 datasheet, this field is 8 bit.
> >
> Ugh. The diagram (in the 8185 datasheet) shows that the rssi field is 7 bits
> long while the table after it says 8 bits, and the two figures disagree on a
> few other fields too. I'll fix that up..
>

True, the datasheet is not consistent.
However the last reference code I have from Realtek is

signal=((*(priv->rxringtail+1))& (0xff0000))>>16;
signal=(signal&0xfe)>>1;	// Modify by hikaru 6.6
<snip>				
if(!rtl8180_IsWirelessBMode(stats.rate) )
	{ // OFDM rate.
		if(signal>90)
			signal=90;
		else if(signal<25)
			signal=25;
		signal = (90-signal)*100/65;
	}else{ // CCK rate.
		if(signal>95)
			signal = 95;
		else if(signal<30)
			signal = 30;
		signal =(95-signal )*100/65;
		}
priv->wstats.qual.level = signal;

Similar to rtl8187 this look at AGC, not RSSI, field to extract signal
strength information.

Andrea
