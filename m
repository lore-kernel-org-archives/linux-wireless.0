Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lugor.de ([212.112.242.222]:40203 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751256AbXBMKlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 05:41:36 -0500
From: "Hesse, Christian" <mail@earthworm.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Date: Tue, 13 Feb 2007 11:41:20 +0100
Cc: James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
References: <45CCE3CA.4050904@linux.intel.com> <200702111417.38336.mail@earthworm.de> <1171349229.2326.91.camel@dv>
In-Reply-To: <1171349229.2326.91.camel@dv>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1727142.jQgLTeo4NX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702131141.25883.mail@earthworm.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1727142.jQgLTeo4NX
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 13 February 2007 07:47, Pavel Roskin wrote:
> Hello!
>
> On Sun, 2007-02-11 at 14:17 +0100, Hesse, Christian wrote:
> > lsmod shows a use count of 4294967295 (2^32 - 1), no oopses or the like.
> > This is reproducable all the time.
>
> Although I cannot reproduce the problem (I'm on current wireless-dev),
> here's my interpretation.
>
> The iwlwifi driver includes both a driver and a rate control algorithm.
> It passes THIS_MODULE (i.e. a handle to itself) to the generic rate
> control code, which locks the caller i.e. iwlwifi.  Therefore, iwlwifi
> has locked itself in memory.
>
> To counteract that, the driver "puts" the module, i.e. decreases its use
> count after the rate control is registered.  Conversely, the module
> "gets" itself when the rate control is unregistered.
>
> One thing that is clearly wrong is that try_module_get() comes after
> ieee80211_rate_control_unregister(), not before.  This means that the
> use count would go negative between those calls.  If the kernel starts
> checking for this, the driver is in trouble.
>
> Further, why do we need this self-locking/unlocking trick?  The driver
> can just set priv->rate_control.module to NULL and prevent self-locking.
>
> It would only make sense to put THIS_MODULE there is the rate control
> were implemented as a separate module, which it probably a good idea in
> the long term.
>
> But a simple fix would be just to get rid of all references to
> THIS_MODULE and let the kernel do the right thing.
>
> Most likely, your kernel doesn't use the priv->rate_control.module field
> to lock the module, so it would help in your case.
>
> Please try this patch:
>
> [ patch snipped ]

This patch solves the problem. The module's use count is zero and I can unl=
oad=20
and load the module.
However I have processes in status D when restarting the device. Is it=20
possible that some functions (i.e. escape_essid()) from old and new ieee802=
11=20
stack conflict? I will recompile my kernel without the old stack and see if=
=20
anything changes.
=2D-=20
Regards,
Chris

--nextPart1727142.jQgLTeo4NX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF0ZXVlZfG2c8gdSURAl7OAKDQ62pkNZ2E/6cUuRAeLmCSHu9XIgCcDV6F
nYZh84cnMTtkWtyQEpJ3YpM=
=F0gE
-----END PGP SIGNATURE-----

--nextPart1727142.jQgLTeo4NX--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
