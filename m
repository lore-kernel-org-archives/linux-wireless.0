Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:17619 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbYGDMrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 08:47:07 -0400
Received: by nf-out-0910.google.com with SMTP id d3so364885nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 05:47:06 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/4] rt2x00: Report RX end time for rt2400pci
Date: Fri, 4 Jul 2008 14:53:10 +0200
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807041340.28103.IvDoorn@gmail.com> <200807041425.00591.IvDoorn@gmail.com> <1215174233.19862.8.camel@johannes.berg>
In-Reply-To: <1215174233.19862.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200807041453.10949.IvDoorn@gmail.com> (sfid-20080704_144711_436981_E3B5EBD3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 04 July 2008, Johannes Berg wrote:
> On Fri, 2008-07-04 at 14:25 +0200, Ivo van Doorn wrote:
> > On Friday 04 July 2008, Johannes Berg wrote:
> > >=20
> > > >  	rt2x00_desc_read(entry_priv->desc, 0, &word0);
> > > >  	rt2x00_desc_read(entry_priv->desc, 2, &word2);
> > > >  	rt2x00_desc_read(entry_priv->desc, 3, &word3);
> > > > +	rt2x00_desc_read(entry_priv->desc, 4, &word4);
> > > > =20
> > > >  	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
> > > >  		rxdesc->flags |=3D RX_FLAG_FAILED_FCS_CRC;
> > > > @@ -1106,6 +1108,7 @@ static void rt2400pci_fill_rxdone(struct =
queue_entry *entry,
> > > >  	 * The signal is the PLCP value, and needs to be stripped
> > > >  	 * of the preamble bit (0x08).
> > > >  	 */
> > > > +	rxdesc->timestamp =3D rt2x00_get_field32(word4, RXD_W4_RX_END=
_TIME);
> > >=20
> > > You really should extend that, like this it's going to cause trou=
ble as
> > > soon as it has overflowed 32 bits once.
> >=20
> > Ok, but if I do the get_tsf() callback, to grab the upper 32 bytes =
of the timestamp,
> > you will get the same problems during wraparounds, because the uppe=
r 32 bytes
> > can be from _after_ the wrapround while the lower 32 bytes from the=
 descriptor
> > are still from _before_ the wraparound.
>=20
> You mean bits.

Ehm yes, having a 64byte timestamp would be a bit overkill. ;)

> But no, it's not a problem, you can safely assume that=20
> you call get_tsf() within 2^32 usecs of getting the frame (that's qui=
te
> a long time after all).
>=20
> Then do something like this:
>=20
> ts =3D word4
> high32 | =EF=BB=BFlow32 =3D get_tsf()
>=20
> if (ts >=3D low32)
>   // wrapped around while we were not looking
>   high32 -=3D 1
>=20
> tsf =3D high32 | ts

Thanks, I'll update the patch.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
