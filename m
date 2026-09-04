Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E774F3CCFAF;
	Fri,  4 Sep 2026 08:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788509080; cv=none; b=WJ+wsIgNMF5yJvt2idbfCQr8j6t0y18UzllvvJADRRzAH5jQHYdrwsxG45aEvDIXhlGMAZqDomrj6Sl/3rDhsMzNfspFZfzVURjmGHswOzKhTMHXzqtWDPOPLIgQdqs3G8Trm8y7zy8XhL8+jexglRYqh6/SIN488opE7pvq31k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788509080; c=relaxed/simple;
	bh=EGqU074clsa42NvtQ8vN8iav3JNKkaPzfkGp5oZggro=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KlMHdrZ5tCcACIcTaxWwuw7CQRVGJ2uM+e6fCBUdYg9f3I0z0176Zr0kh2O5rJmxiCcaCRpRghooK1TrS9wI29tGjhTk/hf5cGCS5juxRDU6gUb2IWdQ277D3fo5/ucxY1+kTaDxQTX6sZ0rhnIM9T7NAizair+SIukX6+akw5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=MTzy1OU1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="MTzy1OU1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=EGqU074clsa42NvtQ8vN8iav3JNKkaPzfkGp5oZggro=;
	t=1788509079; x=1789718679; b=MTzy1OU1oT4+hn/WDZYNS8+z+paJAqLay0EJzx9M4K9HX0D
	nLU2+2oPezld+VfJVHC4wR4a1Nmhx39njWnEHzuVgvAapVAm1KlJn+dIbb8kU0FpARhJXfP3G534c
	cRhFpE1fh+8fYxHKI4jqiG5XjJo6Gm/zypQd1aClK6MxmP/iMUPo61W6OfGlIFIO5YERvsXviinbB
	gBiMbYTaFwJKdCHv/8aI+RKJknULXIWLthDvzsfmNPzuIqHDhpD40MlG7A63aaoM4RBVAnNAMCyYR
	8bmmxu0vOhASpda6OhzdSUZrCjnkUxM2+QCLTd4kVJro/1zDPs+g3b8OQRlscBKA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2OuZ-00000001Fnk-2D2Z;
	Fri, 04 Sep 2026 10:04:35 +0200
Message-ID: <a5f74bb1113b5841a4a5359ba615cc114f41a1cd.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: cfg80211: allow zero HE OBSS PD offsets
From: Johannes Berg <johannes@sipsolutions.net>
To: github@singe.za.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 04 Sep 2026 10:04:33 +0200
In-Reply-To: <20260903081804.96532-1-github@singe.za.net>
References: <20260903081804.96532-1-github@singe.za.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-09-03 at 10:18 +0200, github@singe.za.net wrote:
> From: Dominic White <github@singe.za.net>
>=20
> IEEE Std 802.11 permits the OBSS PD offset fields in the Spatial Reuse
> Parameter Set element to have a value of zero. (IEEE Std 802.11-2024,
> 26.10.2.4)
>=20
> The standard specifies the offsets as unsigned values added to -82 dBm,
> with field presence signalled independently. The valid offset range is
> therefore 0..20.

However, leaving the attribute unset automatically results in zero, so
functionally it's not really needed.

johannes
