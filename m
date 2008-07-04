Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:13916 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYGDMS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 08:18:59 -0400
Received: by nf-out-0910.google.com with SMTP id d3so362686nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 05:18:58 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/4] rt2x00: Report RX end time for rt2400pci
Date: Fri, 4 Jul 2008 14:25:00 +0200
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807041340.28103.IvDoorn@gmail.com> <200807041341.57998.IvDoorn@gmail.com> <1215171723.19862.4.camel@johannes.berg>
In-Reply-To: <1215171723.19862.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807041425.00591.IvDoorn@gmail.com> (sfid-20080704_141902_092454_66046E8B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 04 July 2008, Johannes Berg wrote:
> 
> >  	rt2x00_desc_read(entry_priv->desc, 0, &word0);
> >  	rt2x00_desc_read(entry_priv->desc, 2, &word2);
> >  	rt2x00_desc_read(entry_priv->desc, 3, &word3);
> > +	rt2x00_desc_read(entry_priv->desc, 4, &word4);
> >  
> >  	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
> >  		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
> > @@ -1106,6 +1108,7 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
> >  	 * The signal is the PLCP value, and needs to be stripped
> >  	 * of the preamble bit (0x08).
> >  	 */
> > +	rxdesc->timestamp = rt2x00_get_field32(word4, RXD_W4_RX_END_TIME);
> 
> You really should extend that, like this it's going to cause trouble as
> soon as it has overflowed 32 bits once.

Ok, but if I do the get_tsf() callback, to grab the upper 32 bytes of the timestamp,
you will get the same problems during wraparounds, because the upper 32 bytes
can be from _after_ the wrapround while the lower 32 bytes from the descriptor
are still from _before_ the wraparound.

Ivo
