Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3644E8DE4
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 14:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792419375; cv=none; b=IHB6Zroynl/C5gIF2TgZ7nsSngXJjH4EviWNq0+G7bYkijTwJcdDVy9BQzbGy6lxKDJIkRJL1RRvT4D2yGEe1R5kjvsWpTtGq0sb3z4oEo9KLF80N+ppiJhi7xCTTn9GRL88Xf8mEi4ztTPR8KxH2dCuYy4/7C7YxwqZxKhw0ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792419375; c=relaxed/simple;
	bh=WGlnRj2MnU5DBvtgyOnsaJ5zHLiyeMaJaz+Es56M7dw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gQmbbqJjy6CZg/aRPM4b+w4DUYttpVLH5zR7MQRrIJ+/QzyPieEzRaoQXGLkUmxxZnYNUR2RgYm3Ltc4qgiJcgDHrW+mf8m1dw2wL6Iruq9xaHJXtLLoEyT9ywACpNGbNXptUjSFrzKHZUbJpoSzVhz6klllBjPAPXtTLvCkitA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=HKh9vxDL; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="HKh9vxDL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=f5NGi4Enf5H18b6S0qvbnZTkO8F7vqxC6Ib7EMnudV4=;
	t=1792419371; x=1793628971; b=HKh9vxDLnKt/KMWaqKhOCFRl+uFezWfbjWFD/1XGEjMORW6
	RUj+662PCWGZTFvVoPawgoYJ/+J/kj85AzX7aPZvoWl36kHDyob9+bdjgbUQp/7YZ17+lyOxpGIXP
	qvql6X2LhrsuXahQibukbyszTv8qPxpxAJ3gg8IPWbkzf16woE31JfsTEpi4PNpaG3XDwwMjL+xB8
	Z4IcVDJEhgZfS6AYmfErygOny2QQgqPY7hsorHse6qpEhQdU+axhOGppHrpRehdlITOUpX+RCWnf3
	jTJ+i00m1T3nOfGxRZR43hHmL0Zl7qDNUwj80fIsy8DZj8HUnDIisIcombtqUPKA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xIo9i-0000000DMXy-1dm0;
	Mon, 19 Oct 2026 16:16:02 +0200
Message-ID: <6b94b803c6424227f6ebc044e0ff2e6b90c180c9.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 1/2] wifi: mwifiex: append hotfix
 number to firmware version string
From: Johannes Berg <johannes@sipsolutions.net>
To: Francesco Dolcini <francesco@dolcini.it>, jeff.chen_1@oss.nxp.com
Cc: linux-wireless@vger.kernel.org, briannorris@chromium.org, Jeff Chen
	 <jeff.chen_1@nxp.com>
Date: Mon, 19 Oct 2026 16:16:01 +0200
In-Reply-To: <20261019141347.GA118352@francesco-nb>
References: <20261012123624.3147417-1-jeff.chen_1@oss.nxp.com>
	 <20261012123624.3147417-2-jeff.chen_1@oss.nxp.com>
	 <20261019141347.GA118352@francesco-nb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-10-19 at 16:13 +0200, Francesco Dolcini wrote:
>=20
> > +				case FW_HOTFIX_VER_ID: {
> > +					struct hw_spec_fw_hotfix_ver *hf;

> > +
> > +					hf =3D (void *)tlv;
>=20
> I would not abuse the void*, you know the type you want

FWIW, I tend to disagree, spelling out the type again for no real reason
is just noise. As far as I'm concerned you can do whatever you like in
the driver though :)

johannes
