Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:37652 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbXB1SPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 13:15:46 -0500
Received: by nf-out-0910.google.com with SMTP id o25so633763nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 10:15:44 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 8/28] rt2x00: optimize mac/bssid writing
Date: Wed, 28 Feb 2007 19:15:40 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.11726.IvDoorn@gmail.com> <200702281836.07850.mb@bu3sch.de>
In-Reply-To: <200702281836.07850.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281915.40940.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 18:36, Michael Buesch wrote:
> On Wednesday 28 February 2007 15:07, Ivo van Doorn wrote:
> > Handling the mac and bssid configuration can be done much easier
> > by writing the passed data directly into the register instead
> > of moving it to a local variable first.
> > 
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > 
> > ---
> > 
> > diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
> > index 27e151d..b6bf9f3 100644
> > --- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
> > +++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
> > @@ -319,14 +319,11 @@ static inline void rt2400pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
> >   */
> >  static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
> >  {
> > -	u32 reg[2] = { 0, 0 };
> > -
> >  	/*
> >  	 * The BSSID is passed to us as an array of bytes,
> >  	 * that array is little endian, so no need for byte ordering.
>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >  	 */
> > -	memcpy(&reg, bssid, ETH_ALEN);
> > -	rt2x00_register_multiwrite(rt2x00dev, CSR5, &reg[0], sizeof(reg));
> > +	rt2x00_register_multiwrite(rt2x00dev, CSR5, (u32*)bssid, ETH_ALEN);
>                                                     ^^^^^^
> 
> This doesn't break on BE machines?

No, the multiwrite (just like multiread) does not perform byteordering,
so the device will receive each byte in the correct order.

Ivo
