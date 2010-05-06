Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35943 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0EFS5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 14:57:52 -0400
Received: by bwz19 with SMTP id 19so174707bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 11:57:51 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 3/3] rt2x00: rt2800: use correct txop value in tx descriptor
Date: Thu, 6 May 2010 20:57:38 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
References: <201005061229.58509.helmut.schaa@googlemail.com> <4BE30B3B.2000900@gmail.com>
In-Reply-To: <4BE30B3B.2000900@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005062057.38692.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 06 Mai 2010 schrieb Gertjan van Wingerde:
> On 05/06/10 12:29, Helmut Schaa wrote:

[...]

> > diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
> > index 1056c92..5483fec 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00ht.c
> > +++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
> > @@ -66,4 +66,6 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
> >  		__set_bit(ENTRY_TXD_HT_BW_40, &txdesc->flags);
> >  	if (txrate->flags & IEEE80211_TX_RC_SHORT_GI)
> >  		__set_bit(ENTRY_TXD_HT_SHORT_GI, &txdesc->flags);
> > +
> > +	txdesc->txop = TXOP_HTTXOP;
> >  }
> 
> I am not too sure about this part. If I look at the Ralink vendor driver, they are most of the time
> using IFS_BACKOFF (value 3). Why did you put this on TXOP_HTTXOP?

>From what I saw in the ralink driver IFS_BACKOFF is only used for management frames, IFS_SIFS only
for subsequent frames in a fragment burst and IFS_HTTXOPS for "normal" data frames. But that's
just the result of a _quick_ review. So I might be wrong here as well :)

To be honest I don't really know what the device does in case IFS_HTTXOPS is set but that was
the value we've passed to the driver before ;) (==IFS_BACKOFF on all other ralink chips) and it 
works quite well. I also tried IFS_BACKOFF and I wasn't able to see a difference when using
legacy (11b & 11g) rates (neither on the device itself nor with a second machine monitoring
the traffic).

But I agree that we have to dig further on when to use which value but nevertheless the patch
shouldn't cause any harm but is meant as a base for further improvements.

If you want to we can also wait with this one until we completely figured out what to do?

Helmut
