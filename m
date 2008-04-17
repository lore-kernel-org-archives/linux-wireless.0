Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:35804 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbYDQQ7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 12:59:55 -0400
Received: by nf-out-0910.google.com with SMTP id g13so96233nfb.21
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2008 09:59:53 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 hardware encryption
Date: Thu, 17 Apr 2008 19:04:25 +0200
Cc: Tomas Winkler <tomasw@gmail.com>, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
References: <200804051931.58895.IvDoorn@gmail.com> <200804151717.54920.IvDoorn@gmail.com> <1208427279.4066.14.camel@johannes.berg>
In-Reply-To: <1208427279.4066.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200804171904.26094.IvDoorn@gmail.com> (sfid-20080417_175959_774824_21AE5414)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 17 April 2008, Johannes Berg wrote:
> On Tue, 2008-04-15 at 17:17 +0200, Ivo van Doorn wrote:
>=20
> > > In any case, for the problem at hand, I wouldn't mind increasing
> > > hw_key_idx to a u16 all the way through, or pass the key_conf poi=
nter
> > > instead.
> >=20
> > I'll create a patch that changes it to the key_conf pointer then,
> > that sounds like the safest option to allow changes to key_conf lat=
er.
>=20
> That'll also solve your problem of having to know the algorithm, and =
b43
> might benefit of that too, I think it currently keeps a table for the
> algorithms.

Exactly :)
A follow up patch that I will create later will add a flag to the key_c=
onf
structure that marks the key as shared or pairwise. After that adding t=
he
final bits for HW encryption to rt61pci and rt73usb should be very easy=
=2E :)

> One thing to keep in mind that you'll want to document clearly: the
> key_conf pointer there will only be valid until ops->tx() returns, so
> you must not access it (e.g. via the tx control copy you need to make
> for tx status) outside of the tx() routine unless you want to somehow
> make sure it isn't removed while in use (which is possible [1] since
> set_key() may sleep.)
>=20
> Hence, if you defer ops->tx() to some workqueue or something, you nee=
d
> to copy out all the data you need from the key_conf beforehand.

Ok, I'll update my patch with the above warning.

> Tomas: was it you who mentioned we should remove tx_control from
> tx_status and just require copying the fields we need? If so, did you
> ever look into that?
>=20
> > Note that this change (either adding the key_conf pointer or the hw=
_key_idx to u16)
> > will cause ieee80211_tx_control to exceed the 48 bytes. So that wil=
l make it
> > harder to move it into the skb->cb array later.
>=20
> I just had a look, we could make the rate pointers index into the rat=
e
> array instead which would make them go from 24=EF=BB=BF bytes (12 on =
32-bit) to
> 3 bytes (we only need a u8 index.)
>=20
> johannes
>=20
> [1] using creative bit-locking in hw_key_idx.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
