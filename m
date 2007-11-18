Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37507 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751710AbXKRTVA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2007 14:21:00 -0500
Date: Sun, 18 Nov 2007 20:20:56 +0100
From: Edgar Toernig <froese@gmx.de>
To: andreamrl@tiscali.it
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [rtl8185] driver working but some probs
Message-Id: <20071118202056.1525a0f7.froese@gmx.de> (sfid-20071118_192111_308581_0A71D890)
In-Reply-To: <c68f135e0711180810v1e059528hdd82c5a1f44c2016@mail.gmail.com>
References: <20071116232001.70a4ae77.froese@gmx.de>
	<200711172257.15418.flamingice@sourmilk.net>
	<c68f135e0711180810v1e059528hdd82c5a1f44c2016@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrea Merello wrote:
>
> > > First thing I noticed: the reported "Link Signal Level"
> > > from iwconfig was way off.  It showed values around
> > > -170 dBm when it was sitting directly beside the AP.
> > > It was easy to fix:
> > >
> > > -     rx_status.ssi = (flags2 >> 8) & 0x7F;
> > > +     rx_status.ssi = (flags2 >> 8) & 0xFF;
> > >
> > > According to the 8180 datasheet, this field is 8 bit.
> > >
> > Ugh. The diagram (in the 8185 datasheet) shows that the rssi field is 7 bits
> > long while the table after it says 8 bits, and the two figures disagree on a
> > few other fields too. I'll fix that up..

Maybe the 8185 changed it so that the LSB of the RSSI is now
the antenna flag?  Just guessing though, I couldn't find an
8185 manual...

> True, the datasheet is not consistent.
> However the last reference code I have from Realtek is
> 
> signal=((*(priv->rxringtail+1))& (0xff0000))>>16;
>[...]
> Similar to rtl8187 this look at AGC, not RSSI, field to extract signal
> strength information.

Hmm... there's no AGC field (16:23) in the 8180 doc.
It says 16:31 reserved.

> 		signal =(95-signal )*100/65;
> 		}
> priv->wstats.qual.level = signal;

What is the range of these fields anyway?  Some seem
to be 0-255 (-256+x dBm?), some 0-65 (65 best?), some
0-100 (percent?).

Ciao, ET.
