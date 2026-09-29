Received: from smtpcmd0756.aruba.it (smtpcmd0756.aruba.it [62.149.156.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D2F391828
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 07:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790667445; cv=none; b=eBgi+Uu46ndys5JOhUhlU8pd5lzYG+YpsVhml8gyMY/vUchGWeIhQPsHW0ffOWkEooecUQKIvyoGNKtNHhmTWUrojPxHdK4jgr8ix9dPIdtyh4n+Kf4YasNh4Q7dso0DLdTr2lsxPldzqbMRUHyfikRdLL1K5dOCGUMAGegntBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790667445; c=relaxed/simple;
	bh=6P33nx/BBlKELaBeUjaphAOWQTAL03HPttIrDDIn1hM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QuAC42me+YxFbPhR+caKjTPFpLNr0nA3to4kc2uGtvFsPtfDsKhOGlvXi3fLe1ddxWKvpdEVxI55iutA+bW23yQObEi464vW811K+2XDMCrSX8KUPtylwIeW7IGRACaucfnx6NCG1YIn3YAMf3hmA6bLFLjEw8F4wpUwtSQ8Kfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=ISh8ZJAv; arc=none smtp.client-ip=62.149.156.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="ISh8ZJAv"
Received: from DELL-MOBILE03.ad.smart.it ([77.89.54.34])
	by Aruba SMTP with ESMTPSA
	id BSLmxdjdnVQD1BSLmxiRYG; Tue, 29 Sep 2026 09:34:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1790667247; bh=6P33nx/BBlKELaBeUjaphAOWQTAL03HPttIrDDIn1hM=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=ISh8ZJAvbdoNF9tIf8Sqtq1VfV/70iI1d354Crxo9A7KwkW8tuHW7G54DnSNxGWp9
	 In/1IQM9k08clxtQuHGQvSLf9c5MhuaOEAZg/Z12UP3Cx2fJ+bhgqqSsk2rQbZjGJF
	 zTtlBCvOXfYGwgH8VOC5LDassfuL8f/qn//cfxtf41U8bwGrMhPV50EepvGkUqEjKY
	 c6uT9m300gQfSaJRkPZEIGfEWOiotbgeFr3g71uopxPqLQw4PQB7rQJCXJJ1+HMCkN
	 3S6mRp7zcwWiDI4pw90+eqFWymts+Oyt+bB4HCq7iT+tQyGLZ/p7MfHppQS8WdRzcb
	 eCl1xJG579Sag==
Date: Tue, 29 Sep 2026 09:34:05 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Cc: "andreas.wendleder" <andreas.wendleder@proton.me>,
 "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4360 AC-PHY support for b43 =?UTF-8?B?4oCU?=
 reverse-engineered, seeking guidance on a clean path upstream
Message-ID: <20260929093405.79d9f4ec@DELL-MOBILE03.ad.smart.it>
In-Reply-To: <20260929081403.6076a6da@barney>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me>
	<ih-lXs5OlHxMhydtcZFtKNhGg3cGlR137CEMZ07_zFQcfCYAImW6MRWPDjkdwy-xK9bIwpDK9ImgerqHmQMsAxX3ckEjsiN8QoCSlpvIsSM=@proton.me>
	<20260928200309.01a36f5e@barney>
	<DL5AS1oidqGRAmMHt0Jcp3X4T3ob_Fa-lfhTmMMak3ATUnfcyETDn65CQf3iLvVeg4ExYoc_0GW7QMoaB1jEW4nzKAKFDv8bD0hqBEtkUKg=@proton.me>
	<20260929081403.6076a6da@barney>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfFYZV5X3qbdGJAD45lmgddLpWq6aVhBY0e9ggjydAEi8EZrnpgqhxO3THq+nwUhDSTr5yKMJWpMq/p5z4S4QcZrgv/nfQAdl4sAHcr4HKCbqwd7CDdgD
 PGU7iIAjdq4kHGos2QGfXYEs61Y/zB3H6HhGE0ckszgDG7HMRxU6kXkpn1Jk3foVd9iSvlxjP5VzZL2PrMRTYqQ64po7Cg3otI8t9TFxmPwFYNv7hntr7eDu
 uq/mo+NlpzLiqmSPxAhxj3CeaB4dz7rpA5mqmUQKfP4X/D6MuH1wS7825FDLl37HswjB3U13ZSAiftPU8B+/Eg==

On Tue, 29 Sep 2026 08:14:03 +0200
Michael B=C3=BCsch <m@bues.ch> wrote:

> On Mon, 28 Sep 2026 21:49:23 +0000
> "andreas.wendleder" <andreas.wendleder@proton.me> wrote:
>=20
> > if someone is interested in implementing it. =20
>=20
> I think the number of people interested in working on this is probably
> approaching zero these days.
>=20
> Maybe we can find somebody doing an AI implementation from specs.
> But then, why not publish yours instead?
>=20

I'm still working on my driver for 4352/4360, so two of us actually.
