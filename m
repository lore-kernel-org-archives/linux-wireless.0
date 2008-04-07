Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:40971 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYDGNbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 09:31:55 -0400
Received: by nf-out-0910.google.com with SMTP id g13so595480nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2008 06:31:54 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 hardware encryption
Date: Mon, 7 Apr 2008 15:34:38 +0200
Cc: linux-wireless@vger.kernel.org
References: <200804051931.58895.IvDoorn@gmail.com> <1207573761.12481.4.camel@johannes.berg>
In-Reply-To: <1207573761.12481.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804071534.38526.IvDoorn@gmail.com> (sfid-20080407_143159_037468_8E833CF9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Now there are 2 ways rt2x00 can
> > handle this.
> > 	1) copy the frame to the DMA in 2 steps, skipping the inserted IV by mac80211
> > 	    and copy the IV into the descriptor.
> 
> How much overhead do you reckon this would be?

For rt61pci not much, it simply means 2 memcpy() calls instead of 1.
For rt73usb it is trickier since it passes the skb->data directly to the device,
which would mean a memmove() would be required for the header...

The same goes for the RX path to reinsert the IV back behind the header.

> > 	2) Add flag to mac80211 to provide the IV and EIV seperately to the driver
> > 	    so there won't be overhead by mac80211 to insert the IV after the ieee80211
> > 	    header when the driver doesn't want it to.
> 
> I'd prefer 1) over 2) just because it seems a rather special case for
> this particular hardware.

I agree, but overall I think this would mean for rt2x00 it will be easier to stop
sending the skb->data directly to the USB host and use the preallocated DMA
instead.
Especially the RX path could benefit since otherwise it will be continuously using
memmove on the header and payload to insert the IV and have the payload 4-byte aligned.

P.S. rt2500pci and rt2500usb have the same IV/EIV behavior as rt61pci and rt73usb.
The upcoming rt2800pci/rt2800usb drivers are different and generate the IV/EIV in the hardware.

Ivo
