Received: from smtpcmd13146.aruba.it (smtpcmd13146.aruba.it [62.149.156.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C9C49C4CC
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 12:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896384; cv=none; b=TlCpeBasi7BKGIqgZVvIRIN69+5TZC8/iQw43o0DtesKYz/KxVEsZoJNOD6m/wWBkyDjPfKV3fOhqikf/A838uIinYT4baq1MDomlRnHUwXCiqEsoydSMLB6WdjTLwCZfYNsfhjuHDGX+nJiM4DGuaMz3t9W0W6Nda9WOj/ZwyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896384; c=relaxed/simple;
	bh=lao++6FUBSdNz0qmGrx++rG0qJozCpdchDulcqo3Cvw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SxC94zif//hoguz6MV1Biz9cGnDkvOzwIhL7moVFKvY4CcxgAHZ+Pzw5H7nziWja8SGmDgQk1ecO7IijZLfRYK5K1vRqgg3PZB+LsbX/sDrxrXq9s8DxEvqxgjS4D20X2opqWF59QUP2N5K7tr78eCzZHVBgB5iEawdS96sZbNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=PQ74q1vZ; arc=none smtp.client-ip=62.149.156.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="PQ74q1vZ"
Received: from DELL-MOBILE03.ad.smart.it ([77.89.54.34])
	by Aruba SMTP with ESMTPSA
	id Gc3TxgHCBRG6yGc3UxtzkM; Tue, 13 Oct 2026 14:56:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791896192; bh=lao++6FUBSdNz0qmGrx++rG0qJozCpdchDulcqo3Cvw=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=PQ74q1vZk81eRCqZ51tcWUzV65ppk+NC/tsaKDy7cRlSs/JIeg982gSkgtxCTfOh9
	 sHYD0aHytzigEeUAU01X6mDLjiB5+FXliXTXXghZJTUI40OUCvjus2iWtYqUplse72
	 jkRX/2aRNjCqddAvAX9CBZ7PtNptUfJvyrFD/ZHWpbHDM5f20HXCga6cc9hkLUcFFn
	 aNS2ZtccdE8V8vtChgtTmNyxSjJLh0Ic4O5XMcOdbrLv24SVuGipfL/wwtmbCnzXQh
	 4zBgNy0sG1zdRhf87kDrNkT6rMNxQdp5qqryRkkMlE1SqDfrmiBCo7Uo68F6Ijg2T2
	 fQ5qrilri341Q==
Date: Tue, 13 Oct 2026 14:56:30 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski	
 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, =?UTF-8?B?UmFm?=
 =?UTF-8?B?YcWCIE1pxYJlY2tp?=	 <zajec5@gmail.com>, Philipp Zabel
 <p.zabel@pengutronix.de>, Florian Fainelli	
 <florian.fainelli@broadcom.com>, Broadcom internal kernel review list	
 <bcm-kernel-feedback-list@broadcom.com>, Thomas Bogendoerfer	
 <tsbogend@alpha.franken.de>, linux-wireless@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org
Subject: Re: [PATCH v2 0/5] bcma: support the BCM6362 integrated WLAN
 backplane
Message-ID: <20261013145630.52fdec0d@DELL-MOBILE03.ad.smart.it>
In-Reply-To: <b7e21fad06d27f88b3c18060b4f4a69149de52eb.camel@sipsolutions.net>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
	<b7e21fad06d27f88b3c18060b4f4a69149de52eb.camel@sipsolutions.net>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfLZTM4O64TSnUm6xSTXt8fapdBPWCDbajS4F5t3HcQHNEndtRj/QdATyW/Op1Mlm8fnBDE1bWur3agmwYQW1k8pSarHSSaaFQbcFbD+Of24NfYL2Ry+P
 WqVXqgeqEAD4eF8zg8KhFxv8OIfV9ydBiWPrLDUnDtP+Ag9H8rl3QUYNZHqZ7LXmB18wAE3MBg5YHc6aG8ZpLiW2IIbyuK7A8211jHjX8l8WtHii3njlppk0
 gJzfgVcRLY2CRK5xN3uk9SrRf7Q5UslTxMMa+XgEhRbySNpHg9Nm7sc32e94q+wVpHthM2O065YDm0j+S4TpGwhvSB5BnP6i7H6hI2wfANEWvbQ3RPQVc9Pq
 USEFMLTM+gc+w2M0KQZEhhIR+MPXAB4Gz+rZw9vFT79SPT9AXDk1uQHLWWxCHimExaGb6uyFZuw0Shxu2XL6SKPetuVDpW9jLGJfmyX0fFpGQQN8b0oKpJNp
 FxGgODUDg6lg3uJnNiDA9CZMa8bs/Q10HOzuAYGyiVfJX5+ibHsaPIhZ7h16Vs+zqcRckshvrM+mNFZKLcR/BqcwZ45WYyviMkfuNpQ4r6D03HUWgkakmOKu
 hTNNyI2x3K8c4uVvecJ+npqVYLqHyNTzTIEu4wfAOUG3YuSAHzTQG/TFzNVZows0hLOqabtGBUPzFR1BIbT05Wy5

On Tue, 13 Oct 2026 14:29:37 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Mon, 2026-10-12 at 00:45 +0200, Alessio Ferri wrote:
> >=20
> > My router is running daily with it, using openwrt kernel 6.12. =20
>=20
> [...]
>=20
> > This was drafted with the help of an LLM and cross built with gcc=20
> > mips cross compiler and checked with the dev version of sparse.
> > This time i also ran dt-check-style and it didn't flag anything. =20
>=20
> So ... are you running it or not? I'm confused.
>=20

I don't see your source of confusion: i am running it with kernel 6.12
and it works, but last i checked the current kernel is not version
6.12... so i had to rebuild it for the current kernel and i did it
with help from an LLM. And also i ran the checks for the dt part,
OpenWRT build system couldn't care less that i didn't even register the
bindings, but i know bindings maintainer care about it.

> Either way, I have no idea what to do with it - I guess Rafa=C5=82 if you
> want this picked up then let folks know? But the last patch should
> probably go through some MIPS trees anyway, so the others might as
> well go there too, I don't care (and don't really _want_ to be
> responsible for this obscure corner just because some wifi drivers
> use it).
>=20
> johannes

The original code is Broadcom's. You can also ask Broadcom directly if
this is correct/sane for them.

Alessio
