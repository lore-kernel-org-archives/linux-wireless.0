Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbZEDHTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 03:19:13 -0400
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241387163.10486.6.camel@maxim-laptop>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
	 <1241374060.13562.37.camel@johannes.local>
	 <1241387163.10486.6.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XrpabruKunnDJZ/bJuGg"
Date: Mon, 04 May 2009 09:19:05 +0200
Message-Id: <1241421545.6866.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XrpabruKunnDJZ/bJuGg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 00:46 +0300, Maxim Levitsky wrote:
> Yes, sure
> For record I use iwlwifi.git commit
> 5a94b6d38100b7056a5a347e5c51359d924d305d

Ok.

> Logs attached.
> This bug can be reliably reproduced, happens every 5~10 times when I
> turn rfkill on/off, but today again this happened after resume from
> disk.

Ah, rfkill. Hmm, unfortunately I don't have a system with rfkill. I
looked at ieee80211_scan_work but can't see how it would abort the
scan... Could you put some debugging into that function? Especially
printing out the state when it enters, whether it calls
ieee80211_scan_completed and the next_delay? Also, it would probably
help if you were to enable mac80211 debugging in iwlwifi (modprobe with
debug=3D2). And let's focus on the disable_hw_scan=3D1 case for now.

johannes

--=-XrpabruKunnDJZ/bJuGg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/pbmAAoJEKVg1VMiehFYIogQALcSSYIvBannJjtot9kA1ifs
l6SM2OYD9vYqi5G9dDVpLLVGHjw/yfT7F+g7CSOx1yVsCuNrSNnQ95pXLQ16BvDm
X5hCrO2Cjj/h59H0xrqtpx1IgKjyyYqXRFWoteEIUzgr6gxkP0NQun3kabAiY5dT
52TYLj0Ba0rWJstYPr8jxe6vrOJW0lymJ5UC3jDXA/cFdJHDjpzW7RvihCsRRogN
Hp4n3UQ2IFT9ucG7zzHMUh8CnABp5fU64yjbhSNM497FpL56x1i5BQvM2laXMnpJ
WeNi0G7NenlUmSQLc3FtYFo/WyXVAcElMedrWQAfqKdnE5jkLVD5qAqnscppQCzA
MQ6xBC3xiNSft5ohmKid90lmNy6349Iuhqvy1dWPJgDzoGhNiP5p5fCuRWb8fWJs
lGBG/Y4ZISp6G3FxADeZVIQa7NMDrIX/DcaU+x7DsEWSdYg4pKzL4mKPDn51I/rG
E/gLuwCMHmEnKKccl40cXz53NFVhswOMXLFLoOIt9qthBbjkGVl9k/t4yn1xRzNJ
HIjb3JOg0IoTJooyFlZfkzhY9vHwoWxlCovQ8qd3rxKdA1KyNAe2dCqwVUibDlkX
dzhg+RNZVGhRdhR3S42jBobJ005wIyuFgY4ck0Oe6tCyRJ54XISZTngzRVzGMohC
ofY248CKrCaJbxHjD22f
=OJA2
-----END PGP SIGNATURE-----

--=-XrpabruKunnDJZ/bJuGg--

