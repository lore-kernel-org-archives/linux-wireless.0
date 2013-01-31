Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:44909 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753617Ab3AaOdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 09:33:37 -0500
Date: Thu, 31 Jan 2013 15:32:43 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
Message-ID: <20130131142300.GA9750@open-mesh.com> (sfid-20130131_153348_599326_529427BD)
References: <20130102063255.GA27676@open-mesh.com>
 <50E400A7.5060100@lri.fr>
 <20130107114048.GH27589@ritirata.org>
 <50EACA95.8040004@lri.fr>
 <1359151524.4655.37.camel@jlt4.sipsolutions.net>
 <5103C774.4080403@lri.fr>
 <1359459469.8108.11.camel@jlt4.sipsolutions.net>
 <5107D5D5.3070601@lri.fr>
 <1359639241.8415.17.camel@jlt4.sipsolutions.net>
 <510A7D40.2030206@lri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
In-Reply-To: <510A7D40.2030206@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 06:18:40 -0800, Nicolas Cavallari wrote:
> On 31/01/2013 14:34, Johannes Berg wrote:
> > That seems reasonable. Actually there's no reason for wpa_s to "reset
> > the [...] sta_info", all it really has to do is set it to unauthorized
> > if it detects it was rebooted, and then start key negotiation again, I
> > think?
>=20
> I'm not sure why Antonio resetted the sta_info. Not resetting it when a n=
ode reboot is
> detected from userspace works for me anyway.

I did that because wpa_s was ignoring the new EAPOL message sent by the reb=
ooted
station. If I am not mistaken wpa_s would not expect a new "unencrypted" key
exchange. When I tried it wa snot working, that's why I came up with the
sta_info reset. But of course, if we could avoid the in-kernel reset, it wo=
uld
be definitely better.


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRCoCLAAoJEADl0hg6qKeO2hIP/irVbv16hcE0zo87SPlQo2TL
u7d5pGkDn7ibF/VZT/P7Rpq8Mfaw4fv+eZbT9bZ0J6he/tqEcinG3xU7P/i3qsvL
p2TheCBLiet6jBFVGNtUvyfjPNvd96MFEUlWUmxStf88M9m3CHp1Mm0cnCg0+jg0
m0m3WfU6C7cf2muFtu0M5GxrQBACuR496jS3tUzSNwubipzKjbHh0wGBPXMnmxK4
+VOILC2CBMZ4pCrGomOM9ls/rnzMAs6RahnhZOyY0U3UvmBKhefMW5Nn4Cg4EKVb
0j5fmeb6JUrbLXezKWznElK3hGwsH3s7w9XLDHNqFjhi6zzbE75PqxwiDZK2d1Ph
Jy2+hot0r7qHE2dpu8++VWQLLWKUgl0VIo9e4Hh/RnDjn4+2EW8fypamBLJcbgGj
GQbe+og+44r8DtZC+lxtOPJ36BMWLS0vxBJATWe9mz6pWHppTXHhm0JAIWdD8boU
UZv30mzrGm24VwND2IBikOfulwtAIi72YaLdaifHJfbzin/R3cfaSynLXUXeS2YO
4iDiHpgHbAQ1GMIJrRoq/1W4n2S8bTqmjWHEjO/MHJyD7LnR1gOjT5EZh/e7WIdA
iccZDJ9lwCBfwvbj5NWKOQSwXJChEIb/QHpcYV3Et2PggPSgw+2rLCFsHaaeEnGj
siBx5V7a0BmHUsEUrkrw
=Uvyf
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
