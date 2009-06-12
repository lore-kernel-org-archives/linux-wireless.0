Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbZFLUqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:46:38 -0400
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <83a869cd0906121341k3b58b80fvefdb74c2fca9449d@mail.gmail.com>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906071449u4ae8832bu168322ae4a7cd2a3@mail.gmail.com>
	 <1244442549.11006.2.camel@johannes.local>
	 <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
	 <1244556179.4672.11.camel@johannes.local>
	 <83a869cd0906091048k68616c11k16fa98403aa770b@mail.gmail.com>
	 <1244569926.18481.27.camel@johannes.local>
	 <83a869cd0906101242w2ae8480cle69abd19a9d87112@mail.gmail.com>
	 <1244750836.29447.5.camel@johannes.local>
	 <83a869cd0906121341k3b58b80fvefdb74c2fca9449d@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-18WdrP/I+1PC31uhfMlN"
Date: Fri, 12 Jun 2009 22:47:25 +0200
Message-Id: <1244839645.11782.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-18WdrP/I+1PC31uhfMlN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-12 at 22:41 +0200, gregor kowski wrote:


Please try using a proper email client that can inline patches, as
outlined in
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dblob=
;f=3DDocumentation/email-clients.txt;hb=3DHEAD

Due to you not doing that, I now have to copy/paste from your attachment
rather than being able to simply reply.

> Here is a patch that should fix all issue :

Remove that sentence?

> The mac80211 tkip code won't call update_tkip_key, if some rx packets
> get received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
> first packet because the hardware key stuff is called asynchronously with
> todo workqueue.

That seems fine.

> This patch workaround that by always calling once update_tkip_key if
> the packet wasn't decrypted by the hardware.

But I don't think this is actually true?

> +enum {
> +       INITIALIZED_NONE,
> +       INITIALIZED_PHASE1,
> +       INITIALIZED_UPDATE_KEY,
> +};

Please declare this in a header file and use the proper enum type for
the variable as well so the compiler knows what you're doing. You should
also prefix it then.

johannes

--=-18WdrP/I+1PC31uhfMlN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMr7aAAoJEODzc/N7+QmaiWcQAMQjFNFuczJFWJaYqGIxwg6Q
PmxT9AXtCu+0+jOqsObLPzLbhHFxvPkqpjFQUhmdAZLEj2hDNQ5UjUIM2fuCmkqm
WPuNXZml9U+SNMBYjrkpLvdderRMrPf5/B14MZZASiEJAOk6sYcPOcnMpQQCLTmy
QWupWM+ryHBVje6+O3scDngKl90GTtb62IJHcV7vcLo4krIf0pkNifSvzUTfq4JN
awrFeVTNEGoelWNWuKXfX9e2CtJRcx6wGeGcrc+0RbX8WAKqRZUgbhcnVMu4SRHs
CzzJ1F0ehx/SMqnhHorSmrWWExLOdD34cGgxG3ku0aNCIPqcx9wgz810zBfI5gVr
57RAdpJP+Bqmsk+X9pSwSGbu/OmWh+RJA8+oPFCohFD+Da3lrXnjlLpWcYG8hCBF
kymhsC3kkWO9ERcjZrKbRM7anq7uUaY8YaKCU66/2k9A4FRdBu2Nbj/PXF59V8b5
QJ0khiFUq4Qt/Yv/YNyqsVr0pO8xDCickmRQY5uJ0tvVc6lG4wblM/cXYIdB4n4l
k1mICm4oONXM0iYEf1+oHC9tdu+w7hfqYJtM2oeO7/aE+fanRIMwciEqKPF3kITG
yz2n/Yv7l6qEDZf559J784JBy05CdiKke5eq3oKD+4eJCwcVlPfyhocr9Ub06d1z
oytTtYf4sO2/NuD89UOP
=mO2k
-----END PGP SIGNATURE-----

--=-18WdrP/I+1PC31uhfMlN--

