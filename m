Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYJWHW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 03:22:26 -0400
Subject: Re: New iwlwifi 3945 uCode available
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@linux.intel.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224717261.10863.219.camel@rc-desk>
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1224628088.10863.100.camel@rc-desk>
	 <1224660449.28639.22.camel@johannes.berg>
	 <1224662185.9386.131.camel@californication>
	 <1224707446.10863.155.camel@rc-desk>
	 <1224716347.9386.151.camel@californication>
	 <1224717261.10863.219.camel@rc-desk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZdZeQlcLnKqCfSAqRk7c"
Date: Thu, 23 Oct 2008 09:22:17 +0200
Message-Id: <1224746537.5865.25.camel@johannes.berg> (sfid-20081023_092231_406585_1A698832)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZdZeQlcLnKqCfSAqRk7c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 16:14 -0700, reinette chatre wrote:

> In this firmware case we do not have "an id" (we have one
> file that is loaded by firmware loader so we cannot know what we get
> just by "looking at it" unless we enforce a version number in the
> filename as we currently do in our driver) and the firmware can change,
> potentially frequently, with the consequence of many "quirks" that need
> to be maintained.

But so you do know which firmware it is. Also, the driver looks into the
firmware after loading it to see which version it has, no? At least
there seemed to be a printout like that.

b43 for example has a few dynamic function pointers that are assigned
depending on the firmware. It even supports two completely different
hardware-transmit-header layouts.

> > It all depends on how much the ucode API changes and sometimes we reall=
y
> > wanna cleanup the driver and remove the old code, but in that case we
> > have to tell the users via modules_install that this kernel will break
> > or we have to keep the old driver around. Breaking it from one kernel
> > version to the next one without the user noticing only after reboot is
> > just not good enough.
>=20
> I agree with you and Johannes in this regard and look forward to the
> modules_install solution. I do hope this will be acceptable to
> everybody.

I think even in that case there should be one kernel version that warns
and accepts both, and then the next one that requires the newer version.
b43, for example, will print out a warning every time it loads old
microcode and the kernel tells you which URL to go to to download new
firmware that will no longer warn. The code has been in there for more
than a kernel version because we aren't changing that, but thanks to
this we can now rip out the old code should we implement new features
that absolutely require the new firmware. The transition should be more
gradual. Module install time in particular is quite late, at that point
I might already have installed the kernel. And if you're anything like
me, you install new kernels while sitting on a train for hours and hours
after downloading the git tree at home ;)

The patch Tomas identified doesn't look so extensive. Mind you, I don't
even see how it causes a microcode error, must be your policy of
aborting the microcode when it detects a regulatory violation?

johannes

--=-ZdZeQlcLnKqCfSAqRk7c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJACYmAAoJEKVg1VMiehFYM+oQAJZYO8/CJcq9RycwJhWsLgaS
VpqxiTOOHruiOfX5QtMc7GW43Mgza3esF34VUR3H6miyicakMhC2EiWa2YGLse71
uw+RrePu4EbKCLMcITGmgm6CnrZ34W+EVqyADVrCygZvs81L7IhmGjMb7yyWkPsG
oOvN5G6Xxq3ywZyySI8MbAdrGslrodT+jIU4Ruk9Dp7cfMoT9SU2S5I1eqcSahML
sVqZPOv1UF63j7Dpa2V04dTUQ7ELyUAXBPDbV5WsIIc+16LrFtvlZ3RWR5lSrBmQ
oPS7LIPJaxKfjQuw47P9W0J1LD7zeWmUliDmlPBer/BzjWs+3tQD55K5ctOjm78d
YZgtzsZu459D2lXUqBvmQ8++XI8axptzsH7WGQ2wiCaUwDMOjyV2qD/b5KtsAjSz
vt2EzdvKmRNbET4lHRKEb2g2maYH66Neas+q8/x4ZoQ8i/RAxeNnok0fExFpJCO1
fvl2iXVrjtCZ7E1KYVPcHQGiyAn58PGlYxhKMxXQ7B2iTKL/jzyfrRYhgOlSUHxY
BPBpSAJybVnhkVIxtrxM8Qcmqc1VRzv2Tf6zlZ+Tvceu7E1SbF6mBEQCpbrUdzkX
qSD0tblP74j8znecflmL9SOlenFUOJDQTaXOXFDJ3wdLwT9WwXYSvl3I7hwGgm+z
SZYUgpklP0eHnCjc6rrG
=o45v
-----END PGP SIGNATURE-----

--=-ZdZeQlcLnKqCfSAqRk7c--

