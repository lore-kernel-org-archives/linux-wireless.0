Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50681 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751215AbXKRTBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2007 14:01:05 -0500
Date: Sun, 18 Nov 2007 20:00:58 +0100
From: Edgar Toernig <froese@gmx.de>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Subject: Re: [rtl8185] driver working but some probs
Message-Id: <20071118200058.61e698cb.froese@gmx.de> (sfid-20071118_190113_565024_1B790F14)
In-Reply-To: <200711172257.15418.flamingice@sourmilk.net>
References: <20071116232001.70a4ae77.froese@gmx.de>
	<200711172257.15418.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
>
> > and the symbols from rtl8180_rtl8225.c clash 
> > with those from rtl8187_rtl8225.c.  One has to choose
> > either the rtl8187 driver or the rtl8180 driver.
> >
> Are you compiling as modules or into the kernel? I have no
> problems building both as modules.

Directly into the kernel.  I.e.: rtl8225_rf_set_channel
is defined in both files and produce link errors.

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

I only have the 8180 datasheet and there's no antenna flag.
At the moment the driver takes the MSB of the RSSI as the
antenna flag.  It seems, something has changed from 8180
to 8185.

> > First, bit rate almost immediately drops to 1 Mb/s
> > even if the card sits right beside the AP.  Only
> > if I force both, card and AP, to a fixed bitrate do
> > I get reasonable performance (up to about 22 Mb/s,
> > giving ~1MByte/s payload rate - it seems the laptop
> > isn't faster; even on wired 100Mb/s ethernet I get
> > max 2 MByte/s throughput.).
> >
> The rate control algorithm starts at 1 mbit and goes up with successful TXes. 
> Try ping flooding (-f) your AP or doing a large file transfer and see if that 
> gives the rate control enough information to push the speed up. It generally 
> makes things settle around 18/24 mbit. (yes, mac80211 rate control needs to 
> be improved)

Does not work.  Once it's at 1 Mbps it won't go up again
(without force *g*).

> > Then, suspend doesn't work.  The driver seems to
> > work but it won't see its AP any more.  It *can*
> > see other APs, but not the one he is associated
> > with.  rmmod/insmod is necessary.
> >
> Reassociation won't work?

Exactly.  Nothing except rmmod/insmod works.  Neither
ifdown/ifup nor manual reassoc via wpa_cli is enough.
As I said, after suspend an "iwlist scan" won't see
the AP any more and wpa_cli neither.

> > [AP with hidden SSID doesn't work]
> >
> This problem is related to mac80211 and wpa_supplicant. There have been some 
> patches posted to address these.. I think wireless-2.6 has them. Try 
> wireless-2.6 out.

I'll give it a try.

Thanks, ET.
