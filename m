Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49207 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbYJTRh1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 13:37:27 -0400
Subject: Re: Marvell TopDog Driver Work
From: Dan Williams <dcbw@redhat.com>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <gdidhg$hdq$3@ger.gmane.org>
References: <48A5DBAB.9080405@erley.org> <20080815195825.GD5935@tesla>
	 <1218830917.14841.20.camel@localhost.localdomain>
	 <gdidhg$hdq$3@ger.gmane.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 20 Oct 2008 13:36:08 -0400
Message-Id: <1224524168.29822.46.camel@dhcp-100-3-195.bos.redhat.com> (sfid-20081020_193731_138037_43173758)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 17:01 +0000, Daniel Gimpelevich wrote:
> On Fri, 15 Aug 2008 16:08:37 -0400, Dan Williams wrote:
>=20
> > On Fri, 2008-08-15 at 12:58 -0700, Luis R. Rodriguez wrote:
> >> On Fri, Aug 15, 2008 at 12:40:27PM -0700, Pat Erley wrote:
> >> > Has anyone stepped up to help in the port of this to mac80211?  =
I
> >> > just picked up a wrvs4400n router that uses it and have been wor=
king
> >> > on getting 2.6.XX to work with it.
> >>=20
> >> Not that I have heard of. Don't know.
> >=20
> > There's code out there for the TopDog parts (Linville's marvell.git=
 on
> > kernel.org), and I even have one or two of them lying around.  The
> > firmware interface isn't that different from the 8335 (mrv8k) and t=
hus
> > the two product lines can probably share the same driver.
> >=20
> > Lennert and Nick (from Marvell) are supposed to be working on a mac=
80211
> > driver for the 88w8687 part, which is probably just about the same
> > firmware interface as TopDog (aside from the N-specific bits, and
> > different TX & RX descriptors I'm sure).  I'd prefer to either star=
t
> > fixing up mrv8k and then merge into whatever Lennert comes up with,=
 or
> > see what they come up with and use that as a base for adding suppor=
t for
> > older TopDog and 8310/8335 hardware.
> >=20
> > mrv8k was always a bit rocky and never reliably got scan results on=
 the
> > 8335 cardbus hardware I had, even though the descriptor setup and t=
he
> > mac80211 bits looked right.  There's some pre/post scan commands th=
at we
> > need to hook into mac80211 which I posted patches for first, but
> > Johannes requested we not commit those until we really knew whether
> > pre/post scan were required.
> >=20
> > Dan
>=20
> Duh...
> http://git.kernel.org/?p=3Dlinux/kernel/git/mcgrof/mrvl_cb82.git;a=3D=
summary

Right, that's been there for a long time but it isn't up-to-date with
the latest mac80211 stuff, and I'm not sure Luis ever got it completely
ported over.  It should basically be used only for reference.

What I'd like to see is an integrated driver for both the 833x and the
836x softmac parts, since the firmware interfaces aren't actually that
much different.  We can start with one family and add support for the
other family later as long as we keep that fact in mind and code in a
manner that will easily support the other chips.

> Also, I have a router with an 8361 chip and Linux Inside=E2=84=A2 for=
 which I=20
> have made a GPL Source Request. I was told that the sources will be=20
> available two weeks from now. I don't expect the wi-fi driver to be i=
n=20
> source form in that release, but you never know in advance what they'=
ll=20
> stuff in there.

It'll still be based off net80211 unless Nick/Lennert have made any
progress.  Thus, it would still have to be ported to mac80211, and I'd
rather see a clean rewrite in the kernel coding style, which is what
mrv8k was supposed to be.

Dan


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
