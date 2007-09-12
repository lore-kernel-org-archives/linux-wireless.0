Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:59735 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765753AbXILRDZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 13:03:25 -0400
Date: Wed, 12 Sep 2007 10:01:53 -0700
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlist and network-manager bug report
Message-ID: <20070912170153.GA25785@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1189526874.6161.30.camel@johannes.berg> <1189610572.5644.28.camel@xo-3E-67-34.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1189610572.5644.28.camel@xo-3E-67-34.localdomain>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 12, 2007 at 11:22:52AM -0400, Dan Williams wrote:
> On Tue, 2007-09-11 at 18:07 +0200, Johannes Berg wrote:
> > Hi Jean,
> >=20
> > I have no idea where to send bug reports for iwlist so I'm mailing =
you
> > directly with CC to wireless-dev so others are aware.
> >=20
> > Dan, for NM I suppose the right bug tracker would be redhats? I'm
> > offline as I'm writing this so I can't check.
>=20
> NM 0.6.x and earlier (quite wrongly) treat the SSID as a string.  Tha=
t
> has been fixed in 0.7 trunk, though we do need to make sure that NM
> 0.6.x and earlier don't puke with it.
>=20
> SSID conversion is really, really tricky, and NM tries a few things t=
o
> coerce the SSID to UTF-8, including trying your LANG encoding if it
> exists.  None of these methods work reliably though.

	I personally can't see how we could figure out the encoding,
because we are talking of other's people network. It would have been
nice for IEEE 802.11 to specify something, but it's now probably too
late, as each vendor did his own stuff.
	Where it's get even weirder is that special characters don't
seem to be forbidden either, such as NUL, and all the control
character. There is no way we are going to print them properly.

> Any suggestions?

	Print them in hex ? URL encoding ?

> Obviously NM needs to be fixed.
>=20
> > Anyhow, the problem is that my landlord has an AP that broadcasts a=
n
> > SSID with a 0xFC byte in it (supposedly an "=FC" in windows). iwlis=
t,
> > however, just prints
> >=20
> > 		ESSID:"B
>=20
> iwlist just stuffs the SSID into a null-terminated buffer and prints =
it,
> it doesn't try to do any cleanup of the SSID at all.

	Up to now, it never had been an issue. I made sure it would be
possible to implement a more clever ESSID display routine, but never
did it. It's not terribly complex to implement, but we need to decide
how we do it.
	Note that ideally, we should also do the same with regards to
setting an ESSID. And all the /proc files of the various drivers may
want to be sanitized (yuck).

> Dan
>=20
> > and nothing more (the SSID is B\xFC...). wpa_supplicant converts it=
 to
> > an underscore in its output (B_...),

	That would not be my prefered solution.

> > and network-manager also seems to
> > not like it, though it doesn't display any networks right now. Migh=
t or
> > might not be related.
> >=20
> > I think it shouldn't be displayed truncated, although it is probabl=
y not
> > possible to display it in a fashion that all shells will properly p=
arse
> > and convert to the right binary before invoking iwconfig or such.

	One way would be to check if the ESSID is Ascii, and if it's
not, display it entirely in hex with a leading 0x. Then, iwconfig
would recognise the leading 0x and do the right stuff.
	The problem with escaping is that you always have to escape
the escape sequence, otherwise you get ambiguity.

	Jean
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
