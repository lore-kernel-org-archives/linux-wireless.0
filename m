Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aktaia.intevation.org ([212.95.126.10]:48446 "EHLO
	kolab.intevation.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753739AbYFSIXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 04:23:33 -0400
From: Bernhard Reiter <bernhard@intevation.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
Date: Thu, 19 Jun 2008 10:23:38 +0200
Cc: Greg KH <greg@kroah.com>
References: <200806181715.20516.bernhard@intevation.de> <4859866A.1090300@gmail.com> <1213833799.5258.13.camel@dv>
In-Reply-To: <1213833799.5258.13.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200806191023.39851.bernhard@intevation.de> (sfid-20080619_102338_364989_49D05962)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 19. Juni 2008 02:03:19 schrieb Pavel Roskin:
> On Wed, 2008-06-18 at 23:04 +0100, Dave wrote:
> > Stefanik G=E1bor wrote:
> > > On Wed, Jun 18, 2008 at 5:15 PM, Bernhard Reiter=20
<bernhard@intevation.de> wrote:
> > >> Sitting here a  pc card wireless land adapter.
> > >> id 0x0156, 0x0003, which probably makes it an Agere card.
> > >> cardctl info says:
> > >> "Wireless PC Card Model 0110"
> > >
> > > This appears to be a Wavelan 2 / Orinoco card. Maybe try adding y=
our
> > > device IDs to the Orinoco driver.
> >
> > According to
> > <http://dotpups.de/dotpups/Wifi/drivers-for-Puppy-1/lucent-agere_RE=
ADME>,
> > this is a Hermes II based card, which is not supported by the orino=
co
> > driver.

So far I had gathered already from the pages linked in my last post.
Nevertheless I gave it a shot on a 2.6.17 I had easily available and en=
ded up=20
with a message saying that the firmware is incompatible.

> > There is a more recent version of the Agere driver available, which=
 has
> > been patched for 2.6 kernels. See
> > <http://ubuntuforums.org/showthread.php?t=3D304217>
>
> It's really a low hanging fruit.  The big thing that was missing was
> firmware download for Agere, but Dave implemented that.  The remainin=
g
> work is mostly integration of the pieces together, adding the ID,
> allowing initialization without firmware loaded, loading the right
> firmware for the card.

Ah, I never found that one. Also because the match that this indeed
is a HermesII card could never be made for sure by myself
and because that page is only about Hermes I.

> I feel bad that I'm too busy with other things to pay enough attentio=
n
> to older drivers, but we have linux-wireless list now, so I don't nee=
d
> to be a bottleneck.  Volunteers are welcome.

Am Donnerstag, 19. Juni 2008 08:55:30 Holger Schurig wrote:
> You mean I can convert the sta_h2.h file from the above link to
> some binary file and let orinoco+Dave's patches load that
> firmware to the card?
>
> I'm asking this because I also have a bunch of Hermes I and
> Hermes II cards, which don't work with the Orinoco driver, but
> with the "brought somewhat up to kernel 2.6" wlags_h2_718.tgz
> driver from the above link. That driver works, but hurts the
> eyes, and now has some problems with 2.6.25, e.g. at unloading
> time.

So this is the first indication that the wlags_h2_718 might work
for the Hermes II card. Where can I download it without registration?
Why wasn't the 7.22 version used as base for the patch?

Best,
Bernhard
[cc my on relevent replies]
--=20
Managing Director - Owner: www.intevation.net       (Free Software Comp=
any)
Germany Coordinator: fsfeurope.org. Coordinator: www.Kolab-Konsortium.c=
om.
Intevation GmbH, Osnabr=FCck, DE; Amtsgericht Osnabr=FCck, HRB 18998
Gesch=E4ftsf=FChrer Frank Koormann, Bernhard Reiter, Dr. Jan-Oliver Wag=
ner
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
