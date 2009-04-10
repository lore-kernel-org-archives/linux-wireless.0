Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938740AbZDJH3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 03:29:24 -0400
Subject: Re: [PATCH] mac80211: re-upload keys only after telling driver
 about association
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <bcopeland@gmail.com>
In-Reply-To: <1239294389.4684.15.camel@rc-desk>
References: <1239152134.8456.41.camel@johannes.local>
	 <1239294389.4684.15.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DN87DD90y2pqDogq+hR4"
Date: Fri, 10 Apr 2009 09:29:16 +0200
Message-Id: <1239348556.17031.14.camel@johannes.local> (sfid-20090410_092934_987510_8C9AFBA0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DN87DD90y2pqDogq+hR4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> On Tue, 2009-04-07 at 17:55 -0700, Johannes Berg wrote:
> > In the normal WPA or RSN case keys are only configured after
> > associating, so we should do that in that order when resuming
> > as well. It shouldn't really matter since we do not send any
> > data at either point, but iwlwifi prefers it this way and it
> > does seem more natural.
>=20
> Could you please share the symptom of the problem with iwlwifi without
> this patch?

[this is just a snippet from my other mail -- for the wider audience]


When you have a microcode error, we pretty much take the driver
completely down, and the firmware is of course completely
re-initialised. Now, when mac80211 goes to reconfigure the hardware, it
would, before this patch, do this [simplified, but you can look at the
code]:
 1) ->start()
 2) ->add_interface()
 3) ->sta_notify()    [which iwlwifi doesn't use]
 4) ->set_key()
 5) ->bss_info_changed()

and some more. Now, because iwlwifi ignores step 3, in step 4 it will
complain "station not found" when mac80211 wants to add the pairwise key
for the AP. Reordering 4 and 5 fixes that because iwlwifi adds the
station in bss_info_changed and then the key upload can be successful.

johannes

--=-DN87DD90y2pqDogq+hR4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ3vVJAAoJEKVg1VMiehFYv8YQALdvwbVS4nCanNTRRkkELMuT
BE/dbZ7CacmDGU3aFlQcWB01kOGUSEZjAjSgnFDPE3Tkj5EN2zYZpRP8QcAzEV6r
u2obmH7nWC8MtdiBpiirjXyXBrzO9Es6gEXdEO/cqvcnjAkwCBf0z+10+W/JVuzF
mVR+7rxbcYAONlbKdg1ZNFJi7PGfYe/bZrhlo3UIrbo5iRZ1dSoEf3R3UGYq61+6
LANR3wipQ5/jTkv3bfVwEmb6EgXDtUcnmSfLh9xGL9hbwEmRMbeeFwFgKzUN179/
O09bKrvyk47ZHnANm9EH6wIz6At//VNzkSXQRPHW5To5GiFKt8stKMlsXhdXY9jZ
mdjSrkm4MZCd+eTuHpBQChWI/JqAvwF4YLC99AJI7Fb/yaHqraIj1ozbnczmQYRX
S5tdrwMFjnIrjtnW0n0mtNAiVDvJSC5Cd4Nbxhon2KIGtmWlzBqhIc9U9vGX9B6J
pGN8w/pxsjinmOGRYTb408FSYM7ewsB2ZAje4YjmPCFwUvoluMcEkf/L8yBcMhzr
5ai0rLPWZaKgWEqW35McfAsfMFzki41+zbjOumb/eaEyH73JOd4/XYUWZSvC1y4K
XRozVrZPuX9mbL8j5E44BTjC+aKK6jnN/LTlGZS9EOarIsdJenvlhYY+Rt115Pvs
8zL8aJD3jdnYRpdE2vNi
=IxXL
-----END PGP SIGNATURE-----

--=-DN87DD90y2pqDogq+hR4--

