Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:37299 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbZCYSmk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 14:42:40 -0400
From: Kel Modderman <kel@otaku42.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [renamed] Debian crda?
Date: Thu, 26 Mar 2009 04:42:36 +1000
Cc: debian-devel@lists.debian.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tim Gardner <tim.gardner@canonical.com>
References: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com> <200903260337.37783.kel@otaku42.de> <43e72e890903251041r657a5217q9af7b5eb34f2f824@mail.gmail.com>
In-Reply-To: <43e72e890903251041r657a5217q9af7b5eb34f2f824@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903260442.36251.kel@otaku42.de> (sfid-20090325_194244_087786_4646B2D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 March 2009 03:41:30 Luis R. Rodriguez wrote:
> On Wed, Mar 25, 2009 at 10:37 AM, Kel Modderman <kel@otaku42.de> wrote:
> > On Wednesday 25 March 2009 17:51:41 Luis R. Rodriguez wrote:
> >> On Wed, Mar 25, 2009 at 12:47 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> >> > On Wed, Mar 25, 2009 at 12:39 AM, Paul Wise <pabs@debian.org> wrote:
> >> >> On Wed, Mar 25, 2009 at 4:09 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> >> >>
> >> >>> Last time I poked them it seemed it was not easy to figure out how to
> >> >>> deal with, if at all, the optional but recommended RSA signature stuff
> >> >>> [1] with the DFSG.
> >> >>>
> >> >>> [1] http://wireless.kernel.org/en/developers/Regulatory#RSADigitalSignature
> >> >>
> >> >> What is the percieved DFSG/RSA conflict? I can't detect any based on
> >> >> that section of the page.
> >> >
> >> > Thanks Paul, then its just a matter of packaging. There is an
> >> > debian-example/ directory with a cdbs example of how to package for
> >> > wireless-regdb and crda if anyone is up for it.
> >
> > The example packaging needs some love, I think. I don't see it as a great
> > reference to the eventual packaging material that would enter Debian.
> >
> >>
> >> And as its probably best to coordinate with Ubuntu, they have a
> >> wireless-crda package which combines both into one package. Its
> >> shipping for Jaunty.
> >
> > And that's the only way to sanely package it (by combining the two pieces
> > upstream splits) as show by Fedora also choosing that route.
> 
> Well I actually disagree.

The DFSG seems to suggest that the source code to the regulatory database
should be modifiable and the derived work distributed under the same license.

For our possible, and resonsible, modifications to take effect we need to
build the regulatory database from source, not install the prebuilt/presigned
one. The building of Debian packages is mostly done in anonymous build chroot's
without access to personal cryptography information.

How can the CRDA and wireless-regdb binaries both be built from source
separately and share the same cryptographic information with these
restrictions? (only then would debian-volatile be an option for regdb afaiu)

Maybe the debian-kernel team should be contacted more directly, as it is
ultimately them who need to make a decision about
CONFIG_WIRELESS_OLD_REGULATORY ?

Thanks, Kel.
