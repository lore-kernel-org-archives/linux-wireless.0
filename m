Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56834
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbXB1Sq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 13:46:56 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/28] rt2x00: optimize mac/bssid writing
Date: Wed, 28 Feb 2007 19:46:13 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.11726.IvDoorn@gmail.com> <200702281924.59710.mb@bu3sch.de> <200702281930.12972.IvDoorn@gmail.com>
In-Reply-To: <200702281930.12972.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281946.14128.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 19:30, Ivo van Doorn wrote:
> On Wednesday 28 February 2007 19:24, Michael Buesch wrote:
> > On Wednesday 28 February 2007 19:15, Ivo van Doorn wrote:
> > > On Wednesday 28 February 2007 18:36, Michael Buesch wrote:
> > > > On Wednesday 28 February 2007 15:07, Ivo van Doorn wrote:
> > > > > Handling the mac and bssid configuration can be done much easier
> > > > > by writing the passed data directly into the register instead
> > > > > of moving it to a local variable first.
> > > > > 
> > > > > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > > > > 
> > > > > ---
> > > > > 
> > > > > diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
> > > > > index 27e151d..b6bf9f3 100644
> > > > > --- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
> > > > > +++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
> > > > > @@ -319,14 +319,11 @@ static inline void rt2400pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
> > > > >   */
> > > > >  static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
> > > > >  {
> > > > > -	u32 reg[2] = { 0, 0 };
> > > > > -
> > > > >  	/*
> > > > >  	 * The BSSID is passed to us as an array of bytes,
> > > > >  	 * that array is little endian, so no need for byte ordering.
> > > >            ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > >  	 */
> > > > > -	memcpy(&reg, bssid, ETH_ALEN);
> > > > > -	rt2x00_register_multiwrite(rt2x00dev, CSR5, &reg[0], sizeof(reg));
> > > > > +	rt2x00_register_multiwrite(rt2x00dev, CSR5, (u32*)bssid, ETH_ALEN);
> > > >                                                     ^^^^^^
> > > > 
> > > > This doesn't break on BE machines?
> > > 
> > > No, the multiwrite (just like multiread) does not perform byteordering,
> > > so the device will receive each byte in the correct order.
> > 
> > No wait. It's not about performing byteordering somewhere.
> > It's that casting a bytearray (which is little endian) into an
> > u32 array (which is CPU endian) is almost always wrong.
> > 
> > Do you writel this array in a loop inside of register_multiwrite?
> > If yes, it's broken. writel expects values in CPU endianess.
> > This array will always be little endian.
> 
> register_multiread uses memcpy_fromio(), and
> register_multiwrite uses memcpy_toio().

Ah, ok.

> So that should be safe to use right?

Yes.

> Otherwise would making register_multiwrite  accept a void* pointer be better?

Yeah it would. The argument type is wrong. If the function uses
memcpy_foo it expects an u8 array (or void array, whatever you prefer).

-- 
Greetings Michael.
