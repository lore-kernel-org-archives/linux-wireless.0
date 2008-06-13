Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60347 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbYFMIfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 04:35:55 -0400
Subject: Re: [PATCH 1/3] iwlwifi: adding channels to sysfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>
In-Reply-To: <1ba2fa240806130128l433c5b3fxfc7ff13c886a2fa1@mail.gmail.com> (sfid-20080613_102859_691762_2A965AC9)
References: <1213343095-8133-1-git-send-email-yi.zhu@intel.com>
	 <1213343095-8133-2-git-send-email-yi.zhu@intel.com>
	 <1213343813.3860.0.camel@johannes.berg>
	 <1ba2fa240806130128l433c5b3fxfc7ff13c886a2fa1@mail.gmail.com>
	 (sfid-20080613_102859_691762_2A965AC9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EW4Lvq65NCa3wCXYOoKK"
Date: Fri, 13 Jun 2008 10:35:13 +0200
Message-Id: <1213346113.3860.3.camel@johannes.berg> (sfid-20080613_103601_013789_814C45C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EW4Lvq65NCa3wCXYOoKK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >>  drivers/net/wireless/iwlwifi/iwl4965-base.c |   58 ++++++++++++++++++=
++++++++-
> >>  1 files changed, 56 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net=
/wireless/iwlwifi/iwl4965-base.c
> >> index 81a1c22..c179b21 100644
> >> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> >> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> >> @@ -4122,8 +4122,62 @@ static DEVICE_ATTR(power_level, S_IWUSR | S_IRU=
SR, show_power_level,
> >>  static ssize_t show_channels(struct device *d,
> >>                            struct device_attribute *attr, char *buf)
> >>  {
> >> -     /* all this shit doesn't belong into sysfs anyway */
> >> -     return 0;
> >
> > Hehe. Do you really have to? You can query this information with
> > nl80211. I don't know why you need all that sysfs stuff anyway.
>=20
> I'm not sure why Yi has cut off the log message but original was
>=20
> 'This patch returns channel list to sysfs. This is requirement
> for validation purposes'
>=20
> Our automation is build around sysfs and wext and I'm not going to
> rewrite it now.

If you managed to get along without this for so long, why is it needed
in upstream now?

Remember, sysfs is API. You don't get to change it gratuitously, so
neither should you add to it gratuitously. And we already _have_ API for
this particular thing which is not dependent on a particular
hardware/driver to boot!

johannes

--=-EW4Lvq65NCa3wCXYOoKK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUjE9AAoJEKVg1VMiehFYx54P/1FX7DenCZBcntSR3uf7da9s
d1gAxQktWtPwyIg9HuAJC4G5cT0maCQ5wLV30HcKHOBDlhcNUSQpdgSIA3QRGwVe
X+XlwCG7Yv2H2rAxXkiY5ZwfoE6f1yhrvo3dh3n5Rdo3AMvpkZb1LfBMZHIDCuva
wMyHhn0OIQ8I5Pg68RiRqmOSuXkOOvE2S4PcaI0Tt6idBsBAXU5B6Z5ib08HWLj5
aPWubvTdp4yDJSAQcIwfRqp7SS2GeCweX3HSjYuYNampgVea/WTffd3l1qTSuRp2
41lw+7eY2yrBRBJmNMCeGyKpvoj2qZ3bddlcAkF5+7Ee/Iz9DxpV9nG1JEl9GCrL
5y837WeolCO+SwtO0HmTh4AAbBN64VvNccoKi5MDzw2wMKtabY8iUa6K5C6YRssl
q9NPBbZKymmQZHsyzIKxjr4/jbCC/awsknUtqBfCubeRt8phgJ6eCLuVI1QBYMHO
N11ceQy7PZnhEfOrHMVPTx3GymGoxa0WNBoQW2lkJNVEu+oZ/vXBS9Y9j4tP8+HQ
RM6dE7xccMwq3M47G/xt32bqy7xvWCpgBTwEP7GHrCftIMA8MIcud7aa29hna2e5
SZU+2tHVEZnAN4e9gfBMxFC6k5QRnIDXCTmi5PMin3Xfps2w6fFN4HmQODgyC7uI
llYuIEn1Qfs/35WPAlC2
=DCzy
-----END PGP SIGNATURE-----

--=-EW4Lvq65NCa3wCXYOoKK--

