Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA28E3AEF3B;
	Wed, 22 Jul 2026 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784735891; cv=none; b=GQBVDnseJZsZ2lIFeMlIGpl8AGR1S3ub++Kq76NDOIixwp07vBScjaCiBFlb9MO8+HehT6JQwxlvN3vYW9hryMgVFRTn24GWtZa4SUKDWiK4lYoDeN9SWo86mnj+DOImsPRwtUT4sOeAe5BS6B5g1v/Ye9qcnXA6zWjB1K0vrQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784735891; c=relaxed/simple;
	bh=XtqOb18ujcQhs5WCGIvIEcZmPrwDkMeVG/Q8w7wc7zQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qVqv3bx8mKFZdWBQHzjYo8EQqcmp5RFkqwnZeW4JKyuwt30SBKFKiYSNGYWsZ3JBh+8xXHcrm77ey/MJloq2BLsrC9XyHUp2DywvQH0/NlGE5gDTpuq0VjRXr3hw0DW+gYuuPCavxVAY8HtqdBPhdRPGMYvsfTtNPg5F7AlpND0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghMn7zoO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghMn7zoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F21D1F000E9;
	Wed, 22 Jul 2026 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784735884;
	bh=SoqYc3ae4Ska67lz+wQjVLjyPWDV5tL/2vyVAiuSM+0=;
	h=Date:From:To:Cc:Subject;
	b=ghMn7zoOJGnRIbgZeuaEEimjJxQaETATQXTNC9Pwecy7/XSf0B7R8ypcwTy8FXoqQ
	 h/F1Pd3RBXxd61AHlAGa99RMsUaBK6wv4RZM5KQxjXgyXRNpnCV1iIdLekPoXbEJFw
	 FFHOLojPcvzrzihLhekEwr2Xo4/msVdVTQnn3Mh+V36mFccy7ssCwuGDqSHscoe8I6
	 aCKpO6RgGVO0la3Ld4SJdaNsNcg2+k3zvK1/bLuPG727lGXYW9bzR7UrXLUJ+O11e4
	 ZdXy8BdgkUTk9bGUigztwCkKfSq5Z/n+m23dVOkAx7XqGgS7DdgKl1bw01Rp7Nrm2t
	 IMPh3VKYmpZRg==
Date: Wed, 22 Jul 2026 16:57:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Zhao Li <enderaoelyther@gmail.com>
Subject: linux-next: manual merge of the wireless-next tree with the origin
 tree
Message-ID: <amDoh8ypkkAY-vvc@sirena.org.uk>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Zhao Li <enderaoelyther@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3gq1KFqTCxYraVbh"
Content-Disposition: inline


--3gq1KFqTCxYraVbh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-next tree got a conflict in:

  net/mac80211/mlme.c

between commit:

  035ed430ce6a2 ("wifi: mac80211: avoid non-S1G AID fallback for S1G assoc")

=66rom the origin tree and commit:

  f13e573ab3f12 ("wifi: mac80211: notify driver before destroying assoc lin=
k")

=66rom the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc net/mac80211/mlme.c
index fa773f3b0541a,d577252dbb9f1..0000000000000
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@@ -7140,7 -7191,8 +7193,8 @@@ static void ieee80211_rx_mgmt_assoc_res
  {
  	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
  	struct ieee80211_mgd_assoc_data *assoc_data =3D ifmgd->assoc_data;
+ 	enum assoc_status assoc_status =3D ASSOC_ABANDON;
 -	u16 capab_info, status_code, aid;
 +	u16 capab_info, status_code, aid =3D 0;
  	struct ieee80211_elems_parse_params parse_params =3D {
  		.bss =3D NULL,
  		.link_id =3D -1,

--3gq1KFqTCxYraVbh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpg6IcACgkQJNaLcl1U
h9BmFQf+Kx7jn0D2C1F2qq9ktv2J685UdVaprs5jvgM4nHjXrAi2ZqMT4Jz5EhtB
d6Bm9xUAAGE2prMA/5PHz8b/MH5f4e5wP+yeUEm7TlLBcVNWOkNPjnHIXjUwUKp8
zj0f3FASYTBmRmDHSGpvGArk8uDf3Jb8BYvJJNfGfd4wEVnxo4+2UUv42FLr4kHE
WpwCrJtef/S/9sGqnqitE8NdwaW9Xbb3HkScI71Dmk3Y8NoZuIWQmoDX5UZ1XeWM
c6e5/3lEXtv5gSKj6aXxIhvuM9g58Bdp2i9657W2IzVjL3iDaSdWgkSpr5Kc8xwo
CG2AVySRsEZyKLG6DF/yg1cWw0NSzA==
=PIOS
-----END PGP SIGNATURE-----

--3gq1KFqTCxYraVbh--
