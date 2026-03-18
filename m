Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81143793AB
	for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2026 08:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773821208; cv=none; b=BO+iI6mTh0cy+O8THTEk53rYsVM1vRuQMZUVjgrWKWf21IgNEjJv8aiD99TcZ9Jquksn3BKMtBtQORLsSrjzeVxKHf3ZEOPmumRVCOkatIpWxQn1A5kZA+a6gRgKEkkwvzMcjpqs2qfeq7zSlr6eVg9gzGB1LSo8JmdaZF2VgdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773821208; c=relaxed/simple;
	bh=3Fx2MFYtAKKYaEjqRkpX9Dwdey2SykduQCLxSknc4i4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jy2ZC6RmmZcAgRaFQRzuWjK78FoSnEEkRJISTEii/zwuyWdigx7BwTnZuKj67VZ81GXi83XL7oDPJewLSiUfeNeyBtANa697xZTlelL7+M/yiNeaNeF0dbPas6Zykh4t632Pl7rDxerSTFSI/P/98kSxVFJpK7HLl7nSUjXUiJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=tzVNYvZA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="tzVNYvZA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ta2B9q8yw6pL3cmujyBipYMrD/wfjgppM/vx1m7SOR0=;
	t=1773821207; x=1775030807; b=tzVNYvZAPKJ1lIHsJY9BHtsiw9ODD81Vq9X89i3EUtJFlxk
	Ik5NB/yYgQa0muBaQG+n10XLo0GL7C6ky87KmQvrCrAFOc58UtU9ViyQJBeSGXHZ97ZdNVRhkafsu
	MFuKEZk5jfzbSp0qXi5L5duSNRf6KChLmTD2G8ttNQckO63gbPlafp+AHx8M1w0r0/Vc2uQQ03q5T
	ec4Lfxxap/401tJQP19PWSy4GqzlRBK83lkktN9mB+KISmlnS60XXdV9sO6V45BXWRNSlnBesCCju
	EEcuJHOAh0QdlqzjYPYqAzkNMnitoL8OB3MJCNY+eLdE33vG00dswSnoOk3cUp0Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w2lvQ-00000004GS9-3yj1;
	Wed, 18 Mar 2026 09:06:45 +0100
Message-ID: <a0a4e472747775c21b69db1e7b772f262efd9f67.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: rsi_91x_usb: do not pause rfkill polling when
 stopping mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Ville Nummela <ville@nummela.org>, linux-wireless@vger.kernel.org
Date: Wed, 18 Mar 2026 09:06:44 +0100
In-Reply-To: <20260318061018.Horde.a06VxaHRNwVUkzqm2u-EwFA@www.nummela.org>
References: <20260318061018.Horde.a06VxaHRNwVUkzqm2u-EwFA@www.nummela.org>
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

On Wed, 2026-03-18 at 06:10 +0000, Ville Nummela wrote:
>=20
> @@ -422,7 +438,6 @@ static void rsi_mac80211_stop(struct ieee80211_hw =
=20
> *hw, bool suspend)
>          rsi_dbg(ERR_ZONE, "=3D=3D=3D> Interface DOWN <=3D=3D=3D\n");
>          mutex_lock(&common->mutex);
>          common->iface_down =3D true;
> -       wiphy_rfkill_stop_polling(hw->wiphy);

This patch is severely whitespace damaged and cannot be applied.

johannes
