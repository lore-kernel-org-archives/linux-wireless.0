Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735083783BE
	for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2026 16:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771950030; cv=none; b=KZR6NAM9gDma5TP9ihnydn0wiqoQv1rON5L/lxiwYgqPVXa2sQe7E5r9YP2QRufMbbzc9qTfIpi4zlkHxxYur7mpT/Rik3wPqpmY7nOjPS4WYQ84M266rhFlny6+IPB+hfxYQZXE7NII01zXy8WOz8V1lXzdMg5aC7enzGNnljI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771950030; c=relaxed/simple;
	bh=nbPal5uq/CVwQJT4PmtYgQ5q83DqPTXy3/WjYM8pPcQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YzwDIjyJgyw/lkBs7oBI8GsYjgLtHoCPgdzbwBb+TSPy7D9neAcxkqhwwFrQTn8HlBQKBm6SMojaRgyVV+ty7pnCVwPU/NK1zVR5scVLC8jVlzfgZXLx0dUL4HKhrf8GRzPvdZ71SHjWHlGH9cAuR2KZrEjR8CEmT+X9J9gCWFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=L2krmHHo; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="L2krmHHo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=CIFQlVSlTgnXmCkaiWifcQLXjUeCGQFD8pNpt7I5+Z4=;
	t=1771950029; x=1773159629; b=L2krmHHoTFf/R18SOThcX4eDl+Tazf54gb9pv22jymDajii
	3MHM2hM+rEWt8C4Ef979azpyHmLeQuuv+/VrcjVF7yyR8PZ/yEswyifyiqTUxItGw1yD9XLwwuwHN
	32u1FCuxJaCoNtTyjCnevaptrlXy5NHdoTfHSWSoh7K+eK/Ar378kgpTGTnJFs5te4I3wWZN2QTif
	4uOq48SyIx7a1zkbgtgifvXnTgu+TqTPwkpT9grhQAYWJKRkKdpl9tG5anOFVtaYylPW2HRS+Nx/V
	vE4oNN2byqKl8263sjcnuzbfJWGVsAVHj6VOD7n7EEaVvDeV/YAeIsJ0gsdW1xZA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vuv92-00000000ZlD-1CWF;
	Tue, 24 Feb 2026 17:20:20 +0100
Message-ID: <d52fdbe5d9a483b5746b7253b512958d1460a9a1.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v4 2/2] wifi: mac80211_hwsim: Add UHR
 capabilities to the driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Karthikeyan Kathirvel <karthikeyan.kathirvel@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
Date: Tue, 24 Feb 2026 17:20:19 +0100
In-Reply-To: <20260217054731.3667600-3-karthikeyan.kathirvel@oss.qualcomm.com>
References: 
	<20260217054731.3667600-1-karthikeyan.kathirvel@oss.qualcomm.com>
	 <20260217054731.3667600-3-karthikeyan.kathirvel@oss.qualcomm.com>
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

On Tue, 2026-02-17 at 11:17 +0530, Karthikeyan Kathirvel wrote:
>=20
> +		.uhr_cap =3D {
> +			.has_uhr =3D true,
> +			.mac =3D {
> +				.mac_cap[0] =3D
> +					IEEE80211_UHR_MAC_CAP0_DPS_SUPP |
> +					IEEE80211_UHR_MAC_CAP0_DPS_ASSIST_SUPP |

I'm really not sure we should claim all of this, e.g. DPS assist, right
now.

Also, I think you really mixed this up - a regular AP shouldn't claim
DPS below (only mobile AP), but this here station should probably not
normally claim DPS assist?

Just as examples! There are other issues like this such as:

> +					IEEE80211_UHR_MAC_CAP1_AP_PUO_SUPP |

I don't think the station should claim AP PUO support.

Certainly not an exhaustive list, ELR also seems wrong, etc.

johannes
