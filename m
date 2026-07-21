Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EAF43F4C3;
	Tue, 21 Jul 2026 22:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671863; cv=none; b=VrQ8Wpk3PUpMfvX49jGlf4TfHLIrWWETRab9nUezIlOloWpkCFUUDsua7KVu6M7X53NP/nPM4H1lHTI1AcMbm1Q7LZxlB1auMZhW4Cobq/EjzatlGpe9UeBEYfPNr9Vftt9JGPlJ7RSPtGRiAmKYkqo08YMhJxThvdWh1kleb5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671863; c=relaxed/simple;
	bh=cAsGxmLVMPPSP3NZW7pqNtiDAQn9dzD2pz1ohx0xfYI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oyLHl+Zv+B8IiFtM9GY+tJlzXYCph8zI4hrB1lwJv/iUsTu210Yww1wkivc7jbTms+GklZZsJgbxuL6pjh93pUiNodSd1MQpvhvFfVlt4b/simAfg4j/krHO9jrQgrF90EGbqP59WQJLDU2amjISErT6Xp1BAvPMER64KJeyhrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=FbfgOsCk; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="FbfgOsCk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=RVNpkHDGcPCUtPNEFkcBp5VsvWo+CfK3iMxAGARU11M=;
	t=1784671861; x=1785881461; b=FbfgOsCkAcNyCkEUC5gJpPq3HR4llzcmFQaIJb22mM3Hqtg
	GRwtekOUThSyqKuCw3CDxf9h5wbb3UP3GBSstPaDfFhBK0TRBMljx8mxLjrpEhY4wtzztsnqKvYId
	rQXh5vdb1LsjhHDci4arhDH1JzFlUGSJTJFQL2RXjKHDMX520cesPZ6cDsVsSU9pWHlSAASiBkTpd
	MV+wt/4J0gs3oB3bI5Hs4/Ktq4j3dHQDs+w+QgR+/vah2waUcRVHqepUhuNfCvHBQaXsOfLErHjCZ
	qlr1q64pKyh9moOjzrfLY+jdFisk8D4lNwu3ZbKWzu1j38TBX+JDey4jE4rn80Pw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmIfy-000000032aV-1PUT;
	Wed, 22 Jul 2026 00:10:58 +0200
Message-ID: <bbb15b0ae332d7344f5b69da5e993acc6813aca7.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] wifi: cfg80211: say why the auth/assoc BSS
 lookup failed
From: Johannes Berg <johannes@sipsolutions.net>
To: Louis Kotze <loukot@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 22 Jul 2026 00:10:57 +0200
In-Reply-To: <20260721181158.3004022-2-loukot@gmail.com> (sfid-20260721_201208_795052_C22F5E20)
References: 
	<2629d83dd460f3d9a60566f3fad975db13b045c3.camel@sipsolutions.net>
	 <20260721181158.3004022-1-loukot@gmail.com>
	 <20260721181158.3004022-2-loukot@gmail.com>
	 (sfid-20260721_201208_795052_C22F5E20)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-07-21 at 20:11 +0200, Louis Kotze wrote:
>=20
> -	if (!attrs[NL80211_ATTR_MAC] || !attrs[NL80211_ATTR_WIPHY_FREQ])
> +	if (!attrs[NL80211_ATTR_MAC] || !attrs[NL80211_ATTR_WIPHY_FREQ]) {
> +		NL_SET_ERR_MSG(info->extack, "BSSID or frequency missing");
>=20
>=20

could use the GENL versions and save some characters :)

>  		if (IS_ERR(links[link_id].bss)) {
>  			err =3D PTR_ERR(links[link_id].bss);
>  			links[link_id].bss =3D NULL;
> -			NL_SET_ERR_MSG_ATTR(info->extack, link,
> -					    "Error fetching BSS for link");
> +			NL_SET_BAD_ATTR(info->extack, link);

why remove the message, it's possible to have both?

> =20
> -		req.bss =3D nl80211_assoc_bss(rdev, ssid, ssid_len, info->attrs,
> -					    -1, -1);
> +		req.bss =3D nl80211_assoc_bss(rdev, info, ssid, ssid_len,
> +					    info->attrs, -1, -1);

entirely unrelated (whitespace) change?

> +++ b/net/wireless/scan.c
> @@ -1609,10 +1609,12 @@ struct cfg80211_bss *__cfg80211_get_bss(struct wi=
phy *wiphy,
>  					const u8 *ssid, size_t ssid_len,
>  					enum ieee80211_bss_type bss_type,
>  					enum ieee80211_privacy privacy,
> -					u32 use_for)
> +					u32 use_for,
> +					struct netlink_ext_ack *extack)
>  {
>  	struct cfg80211_registered_device *rdev =3D wiphy_to_rdev(wiphy);
>  	struct cfg80211_internal_bss *bss, *res =3D NULL;
> +	bool expired =3D false, unusable =3D false;
>  	unsigned long now =3D jiffies;
>  	int bss_privacy;
> =20
> @@ -1634,22 +1636,39 @@ struct cfg80211_bss *__cfg80211_get_bss(struct wi=
phy *wiphy,
>  			continue;
>  		if (!is_valid_ether_addr(bss->pub.bssid))
>  			continue;
> -		if ((bss->pub.use_for & use_for) !=3D use_for)
> +		if (!is_bss(&bss->pub, bssid, ssid, ssid_len))
>  			continue;
> +
>  		/* Don't get expired BSS structs */
>  		if (time_after(now, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE) &&
> -		    !atomic_read(&bss->hold))
> +		    !atomic_read(&bss->hold)) {
> +			expired =3D true;
> +			continue;
> +		}
> +
> +		if ((bss->pub.use_for & use_for) !=3D use_for) {
> +			unusable =3D true;
>  			continue;
> -		if (is_bss(&bss->pub, bssid, ssid, ssid_len)) {
> -			res =3D bss;
> -			bss_ref_get(rdev, res);
> -			break;
>  		}
> +
> +		res =3D bss;
> +		bss_ref_get(rdev, res);
> +		break;

That code should probably have a comment that the is_bss() must come
first...

Also however, it could result in having *both* 'unusable' and 'expired'
set, and then

> -	if (!res)
> +	if (!res) {
> +		if (unusable)
> +			NL_SET_ERR_MSG(extack,
> +				       "BSS cannot be used for the requested operation");
> +		else if (expired)
> +			NL_SET_ERR_MSG(extack,
> +				       "BSS entry is expired, scan again");
> +		else
> +			NL_SET_ERR_MSG(extack,
> +				       "BSS not found in scan results");
>  		return NULL;

you prefer the 'unusable' message... not sure that makes sense?

I also don't think the "scan again" instruction makes any sense here -
this is meant to provide an error message, not instructions how to fix
it?

johannes
