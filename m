Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:57043
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932642Ab3ICL66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 07:58:58 -0400
Received: from stuffed.shaftnet.org (localhost [127.0.0.1])
	by stuffed.shaftnet.org (8.14.7/8.14.7) with ESMTP id r83Bwvem017385
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 3 Sep 2013 07:58:57 -0400
Received: (from pizza@localhost)
	by stuffed.shaftnet.org (8.14.7/8.14.7/Submit) id r83BwvUb017384
	for linux-wireless@vger.kernel.org; Tue, 3 Sep 2013 07:58:57 -0400
Date: Tue, 3 Sep 2013 07:58:57 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cw1200:  Don't perform SPI transfers in interrupt
 context
Message-ID: <20130903115856.GA16844@shaftnet.org> (sfid-20130903_135901_171474_F323721E)
References: <1377649787-2817-1-git-send-email-pizza@shaftnet.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
In-Reply-To: <1377649787-2817-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2013 at 08:29:46PM -0400, Solomon Peachy wrote:
> When we get an interrupt from the hardware, the first thing the driver do=
es
> is tell the device to mask off the interrupt line.  Unfortunately this
> involves a SPI transaction in interrupt context.  Some (most?) SPI
> controllers perform the transfer asynchronously and try to sleep.
> This is bad, and triggers a BUG().

Did this patch series get dropped?  I saw that the followup series=20
of minor cleanups were merged into wireless-next, but not these.

Since they didn't make it into 3.11, I intend to submit them to -stable,=20
but I need to make sure they at least make it into -next.

Thanks,

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD8DBQFSJc8APuLgii2759ARAlxXAKDb1MfFWoiCxAy225UQsIAc7lYfpwCcDu8z
V/FeFjEj2sFoivZ6TQp3Ov4=
=rgyR
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
