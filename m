Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:56000 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbYJMX13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 19:27:29 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
Date: Tue, 14 Oct 2008 01:31:38 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <48EE20FB.4060700@lwfinger.net> <1223938526.27118.6.camel@dv> <1223939151.27769.3.camel@dv>
In-Reply-To: <1223939151.27769.3.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810140131.38439.chunkeey@web.de> (sfid-20081014_012753_079827_90B0C9F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 October 2008 01:05:51 Pavel Roskin wrote:
> On Mon, 2008-10-13 at 18:55 -0400, Pavel Roskin wrote:
> > On Tue, 2008-10-14 at 00:55 +0200, Christian Lamparter wrote:
> > > > I don't get that on i386.  But the values don't seem to be corrupted
> > > by
> > > > byte-swapping.
> > > >
> > > Hmm, this should be impossible since:
> > > "p54: report appropriate rate and band values for 802.11a"
> > > 5f840304b5f7dff0028407fa9b284aecb85a94aa
> > 
> > I see.  It's recent code, so maybe it wasn't broken yet when I was
> > testing it on i386.
> > 
> > This code in drivers/net/wireless/p54/p54common.c sets rate_idx:
> > 
> >   rx_status.rate_idx = (dev->conf.channel->band == IEEE80211_BAND_2GHZ ?
> >   hdr->rate : (hdr->rate - 4)) & 0xf;
> > 
> > printk() shows:
> > 
> > dev->conf.channel->band = 1, hdr->rate = 0, rx_status.rate_idx = 12
> 
> And if I set rx_status.rate_idx to 0, I still get that badness for the
> same reason (status->rate_idx = 12, sband->n_bitrates = 8).  Also, there
> is another badness reported sometimes:
> 
hmm, strange...
so dev->conf.channel->band = 1 (=> IEEE80211_BAND_2GHZ)
Ok, but why are there only 8 rates? It should be twelve for 2.4GHz Band!
(What Card/MAC & RF-Chip have you got? Indigo/Duette/Firsbee or XBow?)

Regards,
	Chr
