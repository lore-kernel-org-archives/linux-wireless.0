Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:34013 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYJYK2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 06:28:22 -0400
Received: by ey-out-2122.google.com with SMTP id 6so483529eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2008 03:28:21 -0700 (PDT)
To: "Javier Cardona" <javier@cozybit.com>
Subject: Re: [RFC] mac80211 rx filter in mesh mode, rt2x00 mesh point operation
Date: Sat, 25 Oct 2008 12:28:17 +0200
Cc: "Andrey Yurovsky" <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com> <445f43ac0810231507l790332b9h2c05e95aa0212392@mail.gmail.com>
In-Reply-To: <445f43ac0810231507l790332b9h2c05e95aa0212392@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200810251228.17562.IvDoorn@gmail.com> (sfid-20081025_122847_525438_6F6D55D9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 24 October 2008, Javier Cardona wrote:
> Andrey,
>=20
> On Thu, Oct 23, 2008 at 2:49 PM, Andrey Yurovsky <andrey@cozybit.com>=
 wrote:
> > I've come across a problem with the RX filter setting while testing=
 mesh point
> > operation in the rt2x00 driver (my hardware is rt73usb).  We transm=
it and
> > receive mesh beacons but mesh peer link action frames are dropped. =
 A patch
> > for enabling mesh point mode is included here, this works except th=
at:
> >
> > The RX filter, as set by mac80211 in mesh mode is 0x02, that is FIF=
_ALLMULTI is
> > set.  This is sufficient for other drivers but not for rt2x00.  I n=
oticed that
> > running tcpdump on the MP interface sets the filter to 0x43, this a=
dds
> > FIF_OTHER_BSS and FIF_PROMISC_IN_BSS, and rt2x00 is then able to ma=
ke peer
> > links and mesh point mode works correctly.
> >
> > Actually for rt2x00, setting either FIF_OTHER_BSS or FIF_PROMISC_IN=
_BSS is the
> > key here because they are both treated as FIF_PROMISC_IN_BSS, which=
 causes the
> > driver to enable TXRX_CSR0_DROP_TO_DS.
>=20
> Mesh frames have 4 addresses and no BSSID, so BSSID filtering should
> be disabled (i.e. FIF_OTHER_BSS should be set).
> The ALL_MULTI flag is also needed for mesh mode because an
> intermediate node has to forward multicast traffic for addresses that
> it may not be listening to.
>=20
> But promiscuous mode is not necessary:  mesh points don't need to
> receive unicast frames not addressed=B9 to them.  Furthermore, enabli=
ng
> promiscuous mode normally disables acknowledgments, which are needed
> for proper mesh operation.
>=20
> So my recommendation would be to configure the RX filter in mesh mode
> to be ( FIF_ALLMULTI | FIF_OTHER_BSS )

=46or rt2x00 this would turn into:
	FIF_ALLMULTI | FIF_OTHER_BSS | FIF_PROMISC_IN_BSS

because it cannot filter on other BSS, but this conversion is within rt=
2x00
based on capabilities by the driver. So as long as mac80211 provides th=
e flags
it wants (FIF_ALLMULTI | FIF_OTHER_BSS), rt2x00 will convert it to the =
flags that
make sure those frames will at least get through (FIF_ALLMULTI | FIF_OT=
HER_BSS | FIF_PROMISC_IN_BSS),
including some additional noise from frames mac80211 didn't request spe=
cifically,
but those can be filtered out in mac80211.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
