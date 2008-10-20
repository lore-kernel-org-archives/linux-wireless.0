Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.dslextreme.com ([66.51.199.81]:48965 "HELO
	mail5.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752287AbYJTSKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 14:10:13 -0400
Subject: Re: Marvell TopDog Driver Work
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1224524168.29822.46.camel@dhcp-100-3-195.bos.redhat.com>
References: <48A5DBAB.9080405@erley.org> <20080815195825.GD5935@tesla>
	 <1218830917.14841.20.camel@localhost.localdomain>
	 <gdidhg$hdq$3@ger.gmane.org>
	 <1224524168.29822.46.camel@dhcp-100-3-195.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Oct 2008 11:03:30 -0700
Message-Id: <1224525810.6873.8.camel@the-omnibook> (sfid-20081020_201018_043742_F1D9FEC8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 13:36 -0400, Dan Williams wrote:
> On Mon, 2008-10-20 at 17:01 +0000, Daniel Gimpelevich wrote:
> > On Fri, 15 Aug 2008 16:08:37 -0400, Dan Williams wrote:
> >=20
> > > On Fri, 2008-08-15 at 12:58 -0700, Luis R. Rodriguez wrote:
> > >> On Fri, Aug 15, 2008 at 12:40:27PM -0700, Pat Erley wrote:
> > >> > Has anyone stepped up to help in the port of this to mac80211?=
  I
> > >> > just picked up a wrvs4400n router that uses it and have been w=
orking
> > >> > on getting 2.6.XX to work with it.
> > >>=20
> > >> Not that I have heard of. Don't know.
> > >=20
> > > There's code out there for the TopDog parts (Linville's marvell.g=
it on
> > > kernel.org), and I even have one or two of them lying around.  Th=
e
> > > firmware interface isn't that different from the 8335 (mrv8k) and=
 thus
> > > the two product lines can probably share the same driver.
> > >=20
> > > Lennert and Nick (from Marvell) are supposed to be working on a m=
ac80211
> > > driver for the 88w8687 part, which is probably just about the sam=
e
> > > firmware interface as TopDog (aside from the N-specific bits, and
> > > different TX & RX descriptors I'm sure).  I'd prefer to either st=
art
> > > fixing up mrv8k and then merge into whatever Lennert comes up wit=
h, or
> > > see what they come up with and use that as a base for adding supp=
ort for
> > > older TopDog and 8310/8335 hardware.
> > >=20
> > > mrv8k was always a bit rocky and never reliably got scan results =
on the
> > > 8335 cardbus hardware I had, even though the descriptor setup and=
 the
> > > mac80211 bits looked right.  There's some pre/post scan commands =
that we
> > > need to hook into mac80211 which I posted patches for first, but
> > > Johannes requested we not commit those until we really knew wheth=
er
> > > pre/post scan were required.
> > >=20
> > > Dan
> >=20
> > Duh...
> > http://git.kernel.org/?p=3Dlinux/kernel/git/mcgrof/mrvl_cb82.git;a=3D=
summary
>=20
> Right, that's been there for a long time but it isn't up-to-date with
> the latest mac80211 stuff, and I'm not sure Luis ever got it complete=
ly
> ported over.  It should basically be used only for reference.
>=20
> What I'd like to see is an integrated driver for both the 833x and th=
e
> 836x softmac parts, since the firmware interfaces aren't actually tha=
t
> much different.  We can start with one family and add support for the
> other family later as long as we keep that fact in mind and code in a
> manner that will easily support the other chips.
>=20
> > Also, I have a router with an 8361 chip and Linux Inside=E2=84=A2 f=
or which I=20
> > have made a GPL Source Request. I was told that the sources will be=
=20
> > available two weeks from now. I don't expect the wi-fi driver to be=
 in=20
> > source form in that release, but you never know in advance what the=
y'll=20
> > stuff in there.
>=20
> It'll still be based off net80211 unless Nick/Lennert have made any
> progress.  Thus, it would still have to be ported to mac80211, and I'=
d
> rather see a clean rewrite in the kernel coding style, which is what
> mrv8k was supposed to be.
>=20
> Dan

The "Duh..." was a response to the "Not that I have heard of. Don't
know." statement, which was pretty ironic. The rest was intended to be
context. Any net80211-based code for TopDog would still be a useful
reference for the 11n-specific bits that would need to be added to mrv8=
k
after it works correctly with CardBus 11g cards. What is the canonical
URL for the experimental source repository for those, BTW?

More thanks go out to Lennert for his work on the Marvell CPU cores,
too.

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
