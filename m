Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:34547 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755242AbXD0A2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 20:28:06 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Date: Thu, 26 Apr 2007 20:23:47 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <200704251634.16604.flamingice@sourmilk.net> <46312067.9090005@linux.intel.com>
In-Reply-To: <46312067.9090005@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1464584.Zuq9zYqD5u";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704262023.52833.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1464584.Zuq9zYqD5u
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 26 April 2007 17:57, James Ketrenos wrote:
> With a penalty to battery life and an increase in the amount of time a sc=
an
> takes.  There are improvements that can be made to make the software
> scanning faster, but at a penalty of added complexity on both the driver
> and the stack side -- for no *real* gain for users that have cards that c=
an
> offload the scan.
>
Sure there is. Smaller firmware means firmware that's less likely to=20
malfunction, which seems to be an issue. I don't see what you're saying abo=
ut=20
added complexity on the driver side. Eliminating the hw_scan callback reduc=
es=20
driver complexity. The increase in complexity on the stack side is offset b=
y=20
the fact that no driver/firmware/hardware needs to implement their own clev=
er=20
scanning algorithm.

> > the use of the hw_scan callback breaks the AP autoconfiguration code
> > in ieee80211_sta.c due to its inadequate design.
>
> Is it breaking it just due to the auto-configuration code not knowing when
> to configure things?
>
Yes, because ..

> > Calling hw_scan starts a
> > hardware scan, but there is no way to know when the scan is completed.
>
> That needs to be improved.
>
This is exactly the issue.

> > Even if that problem were addressed, I still wouldn't like it as the
> > design of the hw_scan callback is deficient in a number of other ways a=
nd
> > is completely inapplicable to all other hardware/firmware softmac desig=
ns
> > that I know.
>
> Given that there are things we can do as a result of the hw_scan that we
> can't do on the host without imposing greater system load and slower scan
> results, I really don't want to lose the ability to support hardware
> offloading of scanning.
>
How fast is hardware scanning? What part of software scanning is slowing=20
things down? What's the big bottleneck that justifies moving this to=20
hardware? Are you sure it cannot be eliminated? Why haven't any other vendo=
rs=20
chosen to offload scanning like this?

> Could you voice some of the "other ways" the current hw_scan callback is
> deficient?
>
Sure. In addition to not being able to find out when the scan is completed..

=2D There is no way to specify what channels to scan.
=2D There is no way to specify a passive scan.
=2D The probe frame that is used is fixed with the exception of the SSID.
=2D There is no corresponding interface for the userspace MLME.

This isn't very important, however. I am more interested in what problems i=
n=20
software scanning need to be solved by moving to hardware scanning.

> I'm fine with us overhauling how hw_scan works and integrates with the
> stack, but an all out ban on hardware scan offload just doesn't make sens=
e.
>  The host can do all RC4 and AES encrypt/decrypt too but certainly we wou=
ld
> prefer the hardware to do that for us, right?
>
The host can do TCP/IP too but certainly we would prefer the hardware to do=
=20
that for us, right?

Well, referring to TOE is unfair, but it makes the point that only some thi=
ngs=20
make sense in hardware. Softmac is the result of removing the things that=20
don't.

> In the short term, I would rather we leave hw_scan in the code and have t=
he
> users that currently rely on hw_scan just have to manually configure the =
AP
> selection until such time as the in-kernel-AP-selection-policy code works
> with hw offloaded scan.
>
What incentive does that give to fix the code? Leaving broken things in for=
=20
the sake of out-of-tree drivers does not appeal to me.

=2DMichael Wu

--nextPart1464584.Zuq9zYqD5u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMUKYT3Oqt9AH4aERArVbAJ4sfzrfPHp1JLOgKZAbJh+BeeMA9gCgpAiH
AJpFPWWXHjeubWwNoNKcaCQ=
=uCNa
-----END PGP SIGNATURE-----

--nextPart1464584.Zuq9zYqD5u--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
