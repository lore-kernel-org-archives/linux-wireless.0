Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906A93AEF3B;
	Wed, 22 Jul 2026 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784735929; cv=none; b=nIZOaDkv3qU0bcpEjsGOaolZt0dXm7hVB2F8zmtXqJ3LHlProK8VhFylhvTfzuojVlD74sY+aJlDp1E7EnVRQcd9Ogpb/GR6ijdpyE319ZBdbkOUJlstxUqO9ZDNIDNLJ4IXQ1kI2cFUruzpZcjJut0G2DLK/qGtTcZzGpbsS9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784735929; c=relaxed/simple;
	bh=YLT2WcGkk/EaFNviYTGx2hLHfCy1ovDMsKm4Ubnx0qA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=foQlPi2SbUeXRbcp8d6PRqnLMe0iKvFuTqI+kEgU0OtNW9PtYXBz40QoelSZSW8Ar0EcZs83xWCLKO70i5vTIxBWrIBVTwtyBlVMmTS+7ZDSX2N0AUUvZSR6zLyhslXYFCGMMdY1oXMa68Y16UAYzjb+jcnae2cms/kG8T0HtPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cD7ayxnI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cD7ayxnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49671F000E9;
	Wed, 22 Jul 2026 15:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784735926;
	bh=A49t6faPnPVGva7ci9AvIsCArTmJQ6dHdmhFhgf8R+c=;
	h=Date:From:To:Cc:Subject;
	b=cD7ayxnI+4vtSj3IaoxfvsO8FWC0MUdmpBkkPg5hWF5X7rgIAhp/gYb3wyNUAvv6z
	 AYqKsVvrQ3qjRGL15CnE+VNRN3ynRXSQ8KSaT0OUzlwWebj0BBMTE4eoDqaQrkHqqU
	 aAnflBHMV03LB4O6UFo3YKTO2NZTfyeRjPwkMwkwQlaqXsTspKRJpGxuiLY5A/WGt5
	 imL5lH3XE/B6PzHNHoqLOeqHLP/jravT/uvIqrnk+jjnzXCGJ4V9pbWREcUkP9go9V
	 GsA6EZa3I/8VyxdaCHt9YgnGeynWIW/H7ROS9qaSCyFMbyPTdqEHJIN7pYjYzEWKla
	 k1DEqDdEpNO0g==
Date: Wed, 22 Jul 2026 16:58:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the wireless-next tree
Message-ID: <amDos20YUxH9DFgJ@sirena.org.uk>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6GrrsIIMdCoDmJh7"
Content-Disposition: inline


--6GrrsIIMdCoDmJh7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the wireless-next tree, today's linux-next build
(arm64_defconfig.log /tmp/next/x86_64 allmodconfig) failed like this:

/tmp/next/build/net/mac80211/mlme.c:
In function 'ieee80211_rx_mgmt_assoc_resp':
/tmp/next/build/net/mac80211/mlme.c:7279:17: error: label 'abandon_assoc'
used but not defined
 7279 |                 goto abandon_assoc;
      |                 ^~~~

Caused by a semantic conflict (probably the same two patches as the
merge I posted a minute ago).  I have applied the patch below and can
carry as needed:

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 60fc407bb1ebb..5a1c022282202 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7276,7 +7276,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee8=
0211_sub_if_data *sdata,
 	else if (!assoc_data->s1g)
 		aid =3D le16_to_cpu(mgmt->u.assoc_resp.aid);
 	else if (status_code =3D=3D WLAN_STATUS_SUCCESS)
-		goto abandon_assoc;
+		goto notify_driver;
=20
 	/*
 	 * The 5 MSB of the AID field are reserved for a non-S1G STA. For

--6GrrsIIMdCoDmJh7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpg6LIACgkQJNaLcl1U
h9A8eQf/R12a8dZitcVHo3AkzN0o9Ft/ghivtincz5TCbNfIiEcz0rdc9De3LrIf
VWhqbs9hjE/pj8dxPkyAbIDSpkEvamdm3TY85MHHDn4djtv77bbmmCiqc4utuN9i
dzP5DnudpYKMQz2ASleGXxmXl7KoYGLU3TbFZ66ehLlabcfwLAzitSn4Lx66FU7N
iea8UA7iJDUs4yzh7A6a4N6otqHac13jhQvGyg8WufgZNE64Uao9QgIRtjzb+xHH
pkhS5hPygydxlkDZBt66F/ncHJCdcMGjYPbdN4rO6imeT9+gZDr+9Vephid96j3c
HVH1mvB6HOeRvMY7qg/MmIN7zKV0ww==
=2qvh
-----END PGP SIGNATURE-----

--6GrrsIIMdCoDmJh7--
