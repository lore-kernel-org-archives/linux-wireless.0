Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50004 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037AbcHJTT3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 15:19:29 -0400
Date: Wed, 10 Aug 2016 20:17:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Ming Lei <ming.lei@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Jeff Mahoney <jeffm@suse.com>, Takashi Iwai <tiwai@suse.de>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Vikram Mulukutla <markivx@codeaurora.org>,
	Stephen Boyd <stephen.boyd@linaro.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Tom Gundersen <teg@jklm.no>, Kay Sievers <kay@vrfy.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Josh Boyer <jwboyer@fedoraproject.org>,
	Michal Marek <mmarek@suse.com>,
	David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>, Abhay_Salunke@dell.com,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Jiri Slaby <jslaby@suse.com>, Gilles.Muller@lip6.fr,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Richard Purdie <rpurdie@rpsys.net>, nicolas.palix@imag.fr
Message-ID: <20160810191708.GO9347@sirena.org.uk> (sfid-20160810_211948_057157_3AE974DB)
References: <1466121559-22363-1-git-send-email-mcgrof@kernel.org>
 <1466121559-22363-9-git-send-email-mcgrof@kernel.org>
 <CA+55aFyD+Xa2auP05=pBSxQc2qcuR858syMW5fiQKowbqbkDzQ@mail.gmail.com>
 <20160617013657.GH11948@wotan.suse.de>
 <CA+55aFycG-YfukKpP3x7kbBpCzXGwg35SdTU2r4wBbxrfROLtQ@mail.gmail.com>
 <20160617183503.GV11948@wotan.suse.de>
 <20160810183211.GL3296@wotan.suse.de>
 <7451c96a-b4f5-e629-a4a7-76d6fe1772e9@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8WA4ILJSyYAmUzbY"
In-Reply-To: <7451c96a-b4f5-e629-a4a7-76d6fe1772e9@broadcom.com>
Subject: Re: [PATCH v2 8/8] p54: convert to sysdata API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--8WA4ILJSyYAmUzbY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 10, 2016 at 09:04:38PM +0200, Arend Van Spriel wrote:

> So why would drivers want the devm solution anyway. Once firmware is
> loaded in the device it can be freed or do you expect device drivers to
> keep the firmware/sysdata for suspend/resume scenario as some do because
> of firmware cache behaviour. Does the "rootfs ready" event cover
> suspend/resume?

There are classes of devices that spend a large proportion of their time
powered off and are only powered up and have firmware loaded when they
are actively in use.  DSPs used in audio systems are one example of
this, I'd not be surprised to learn that similar things are done with
video.  It's too expensive to keep the device powered up and you may be
swapping between firmwares depending on use case anyway for a lot of
these devices.

--8WA4ILJSyYAmUzbY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXq32yAAoJECTWi3JdVIfQxe0H/jHhHIuT6AdApkbOPeriwdgd
coBo8ETW3DL+vPJi661O63rZ4BIPdBTMi7foPwOziFhBpP+JjE3oHcUTsBKxLqzc
udg2WURiEa9x+MMR9gCwT7GqxVc6eetjSXRa/HXmxhvWJLaP3dwOxMxwO1nt53wa
ZBXK1EZiCxTf9H/RR6YLqw5/4dw7TsRq4xxkT6eum/vrT1uTrqZrdcaQVFmCkSsK
8xgGKdxzHCB3LLdtqktR2tBmTmf+NoghbA2jZQYGysUwvyZ2vUVnjz6OmfnM3ML8
tvCPHit68zzBKDXYcojMkt08od/WnlgiPlQI17JyhDymOCL51l6us2LGA/fkgHM=
=G55B
-----END PGP SIGNATURE-----

--8WA4ILJSyYAmUzbY--
