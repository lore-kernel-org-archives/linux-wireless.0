Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810724BD108
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791471600; cv=none; b=Gho3WHfQBxQunsYzan2W7b5EC57CPzlZSkX+rM2QK6QVlL2gOaMnpBxtcQWnODslaznvTEgzcju4ENW7bo7faHk+/77O724aN0yyUXXJlae7Sa2m87FWg2hUGqaDE/XWZ2hgnZo4oxXmJh/RUI0drJ0TSaaiGPMoQCleBaZ256A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791471600; c=relaxed/simple;
	bh=Lqt1pDvkIpe5TDx0yC42gwves4z3bBzMdvbJB/ji8VU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Tp7oZLHXMoO3WiJV52ENlo/ScKwtOcpuoCYtfTRTwjKo6rzH2dM0drPat3Y41rQ1n83u7ipavZXJ3W9EoaA4VX7KqUqoodQ/FizawjLeVSn3JAChMYMfl3QUPk3eM5Se+tajFJN4j0hzeKm6oz+mUFYUL8djQfHb5R6nux+wMdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=JDGBfdLU; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="JDGBfdLU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=o+4/e1MQx4Vd2R885J3Ih+4FI/g9KIa46xSHJM+xOEk=;
	t=1791471592; x=1792681192; b=JDGBfdLUp0xjYZHDoQ+T7fuPzRpIAiqvZjDPT5n1w37Q4R6
	GNAIl0TjRwo5aGsag2TSed5p9jW4NhvzWz2JvadP/0KHujcZWAyxPtq+pTcPs9cQ1+G91GS18PCLw
	y4Esfxv5OCYEprMNljl90ygPzkivBTY+tM9SD+/uRDvVGwoHkQZ6i5IpNbaoLEMRMG0InxaYWLlNt
	D2HU+9+PwSgiEfvZHUclDA6hwHmYjr0HjKgYrX+PaD6BeEFjy9kEzQN7FKDs2qcZQNyB/QCv/8qPO
	R2Cp91GYo+nixYhThy/nQCce3pU+uRsjQATrLzqnXKMhBo6+l/xWxfH/0C7skc2A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xEpb3-00000009RJZ-0lFk
	for linux-wireless@vger.kernel.org;
	Thu, 08 Oct 2026 16:59:49 +0200
Message-ID: <4effc41643dded30890daad71347d843df3d27d6.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 3/4] wifi: mac80211: implement unlocked STA
 statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 08 Oct 2026 16:59:48 +0200
In-Reply-To: <20261007181056.bbea8c0be375.Ieb92e4c6599a198a116fa6a4f7944219c6d32932@changeid>
References: <20261007161056.340373-6-johannes@sipsolutions.net>
	 <20261007181056.bbea8c0be375.Ieb92e4c6599a198a116fa6a4f7944219c6d32932@changeid>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-10-07 at 18:09 +0200, Johannes Berg wrote:
>=20
> +int drv_sta_statistics(struct ieee80211_local *local,
> +		       struct ieee80211_sub_if_data *sdata,
> +		       struct ieee80211_sta *sta,
> +		       struct station_info *sinfo,
> +		       bool locked)
> +{
> +	int ret;
> +
> +	sdata =3D get_bss_sdata(sdata);
> +	if (!check_sdata_in_driver(sdata))
> +		return 0;
> +
> +	trace_drv_sta_statistics(local, sdata, sta);
> +
> +	if (!locked) {
> +		might_sleep();
> +		lockdep_assert_wiphy(local->hw.wiphy);

This obviously came out the wrong way around - it should of course be
"if (locked)" since only then can we sleep here and hold the mutex.


> +int drv_link_sta_statistics(struct ieee80211_local *local,
> +			    struct ieee80211_sub_if_data *sdata,
> +			    struct ieee80211_link_sta *link_sta,
> +			    struct link_station_info *link_sinfo,
> +			    bool locked)
> +{
> +	int ret;
> +
> +	sdata =3D get_bss_sdata(sdata);
> +	if (!check_sdata_in_driver(sdata))
> +		return 0;
> +
> +	if (locked) {
> +		might_sleep();
> +		lockdep_assert_wiphy(local->hw.wiphy);
>=20

This one I got right ... :)

johannes
