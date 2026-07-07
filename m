Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94E32EDD7D;
	Tue,  7 Jul 2026 08:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783412349; cv=none; b=qrcE5MnJj856NBB2v0PCRNWgCn+H5XQ/hJ4utoanEFS7QtbXvMr1wooT67iuBEHXns/NzbPJNBw7r86gtdbYJ72iYRKIdEB7LPuCeFaNwfi8kC1GNx1Z6NaENHvT7R19Oe/Id6v8sMumqM6xY1Qqc+wxiblRu+IsNw/s7w9g1F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783412349; c=relaxed/simple;
	bh=5QLkLIV6dWz+yM8AXGu8lDkyyoQEzGcB9XsMrlJbli4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ArGHk9YyEaDqMtCHuk0aTbLIQOhU8IlA3241XHp38hcBER2IouNjv219o6bXRBgiGBqV5QVWOQbiqGBQRfz4vPQnB0E8y/NshtnJD6fol9MrzF7CU6xwhDN13OeeLryhk2fsgBTOeI+Trbon23mp03h6QDk5OqwNRkbI4TPdrlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vwx7+Pw7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vwx7+Pw7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=j9g61QJ16IaAdUYswmT5n+XykLyw2Vj431tO+JQ6hDY=;
	t=1783412347; x=1784621947; b=vwx7+Pw7842ZAm0GYZOHB0iGTxDD974PSM3jIz4CNVa1QlY
	0pUtm7sa0hhsX4mHIhL4KY3vblQUwvkAxW7WBXiDwqJEl2dZO2q/alASrDM7ltalILWou8eWwOfn6
	DJ4ZEfN1MIr+cIkYVA4rJYwAdagb1FcgIfsMBQUq3snKhZ33fY1g3JcVIWdGTcv5ikXSsFcpUhCFY
	dFo6pH1FFBvOjORd5VyGjSdayAp0U3uESj/H+PS3M590OJr5n9bKoR+5jHCdDXjVsqRs9OJu+/pTP
	b7Cw4LkdCeUe9BnV8lbUZEx4S4eSSrNWZnCod+6Ods4TZf7zzxR3Y1zBMrg0mEUQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wh11D-0000000HRe4-0mFW;
	Tue, 07 Jul 2026 10:19:03 +0200
Message-ID: <2d0a7285a8e90ee2de658b564b739ed735fb3fd1.camel@sipsolutions.net>
Subject: Re: [PATCH 0/3] MIPS: BCM47XX: convert buttons to software nodes
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
 =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=	 <zajec5@gmail.com>, Michael Buesch
 <m@bues.ch>, Hauke Mehrtens <hauke@hauke-m.de>,  Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>
Cc: Bartosz Golaszewski <brgl@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mips@vger.kernel.org
Date: Tue, 07 Jul 2026 10:19:02 +0200
In-Reply-To: <20260704-b4-bcm47xx-swnode-v1-0-730d59340237@gmail.com>
References: <20260704-b4-bcm47xx-swnode-v1-0-730d59340237@gmail.com>
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

On Sat, 2026-07-04 at 22:25 -0700, Dmitry Torokhov wrote:
> This series converts the legacy gpio-keys platform device on BCM47XX
> boards to use software nodes and static properties.
>=20
> To do this properly without relying on legacy name-based matching
> (which is being removed from gpiolib), we introduce and register
> software nodes for the underlying GPIO controllers (BCMA and SSB)
> and reference them in the button properties.
>=20
> The first two patches add the software nodes to bcma-gpio and
> ssb-gpio respectively. The third patch performs the conversion
> for the BCM47XX buttons.
>=20
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> Dmitry Torokhov (3):
>       bcma: gpio: Add and register software node for GPIO controller
>       ssb: gpio: Add and register software node for GPIO controller
>       MIPS: BCM47XX: Convert buttons to software nodes

Seems like most of the change in in MIPS and it should all go through
that tree. For the record, that's OK with wireless regarding bcma/ssb.

johannes
