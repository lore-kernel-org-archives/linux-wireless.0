Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0AYULq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 15:11:46 -0500
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <20100125183543.GB19528@jm.kir.nu>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1264186981.2593.10.camel@johannes.local>
	 <20100125183543.GB19528@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dhwgODusqc3xBJi8kyht"
Date: Mon, 25 Jan 2010 21:11:41 +0100
Message-ID: <1264450301.23766.65.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dhwgODusqc3xBJi8kyht
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-01-25 at 10:35 -0800, Jouni Malinen wrote:
> On Fri, Jan 22, 2010 at 08:03:01PM +0100, Johannes Berg wrote:
> > The other solution I see is that we add a new step before or after the
> > direct probe step, which would just be "wait for a beacon". This would
> > ensure we have both probe and beacon information always ready. It would
> > also ensure we have both probe and beacon info for our new userspace
> > reporting of that.
>=20
> I'm somewhat concerned about this as an unconditional change for our
> association process due to the extra latency it adds. At minimum, I
> would like to see a driver flag that can be used to indicate that such
> behavior is really required and skip the extra wait if the driver does
> not need the Beacon frame before association.
>=20
> For most cases, I would also assume it should be possible to update the
> PS settings after having received the first Beacon frame after
> association, but if that is not enough, allowing the driver to request
> mac80211 to wait with association sounds reasonable. I just don't want
> to see additional 50 msec or so (or much worse if the AP is configured
> with insanely long beacon interval) delay popping up with every
> association by default..

Yeah that's a good point, I wondered about that too. I'll look into this
in more detail and see if we can tell the driver about the DTIM period
only with CONF_PS and enable that only after a beacon.

johannes

--=-dhwgODusqc3xBJi8kyht
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIbBAABAgAGBQJLXfr5AAoJEODzc/N7+QmaQE4P933KAz2bRD4loyeUBkOazbYy
LGo8/Jc6TaP4MgVm2y9ovDjaCezLXcN03UkR4cWWGPq02unWBLekoZgpKyRpQYby
q6pEyYeUzW65XN5l9XwirkL/jHtj10JAlsxAuoNybUcpmcQUENrjTd6parg5xfvS
Eqcpj/m9rniglOO78virZ7RSjWFbknIr2FdaxlCpEBjaETOpMJc4qRMoHup07ZVV
ltOxwC4SsqMgpYs2XvKUna9XRJ3k8AuQzAm+ZHFxoOYaA6XPkR/P2dSUo4gKfsOo
Q03ceecUvQeIEIFc/0AP/8qVEDvssfQk7W9jiG7KAZdnET1dcTZ9Vj1bJW3dmFPA
X40KM29Lsf23fDKKoIW/3BJIdJS7FkjV66sY910wLydSEIs+o4Wwuc/CTPb7XC/y
fwfUUJqhMH5P/IHwmMPkPBXC0x8TNDLo8P+ciQujKmxHcF2zfxMghckzaChpoGuO
AAWS8iaET6kK7SDlwrTEiDsllxFDuFGI06v+o0nJdMwIhXom0CUjvwG1q9cxN4Lj
w9i/8d8VGWBIBAKLBx3y85gIQkGRjbewrExQCUFm/78hvRIFjfqzuWelHsscyIEl
8+e0kAk9WqiKrh5x3UUiTJ8z5w9w6eYCmc9bU3PKTcsqY1P5wUJi/vB5MdEztZq9
O7hhFJow0gWs2MGumks=
=pmAu
-----END PGP SIGNATURE-----

--=-dhwgODusqc3xBJi8kyht--

