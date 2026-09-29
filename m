Received: from mail-106103.protonmail.ch (mail-106103.protonmail.ch [79.135.106.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8840A3AE1BB
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 07:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790668193; cv=none; b=Ms2TsVVyaUsrT2rbyM69E2VsWZTn/9LD3qP6CV2BDRC/rzfd34+SAGRXDx+8bMhRpvCuSd3UOnDkaL35/TcwQFkWQrHapQ15UTFoQUipDjP7eE+yTiUUCVXK39SFCTGYuiG6LIqjaxQMFn/ptfuv8GLOvoFbOAoqMJ0fneyqD4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790668193; c=relaxed/simple;
	bh=AZfWeagBsnDIRz0QaQuqHL/lraDGNfQn60MTCaukrHA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCYjQ8wUaAz1P3y0fxvQxZfHGpRY6fCy3rS2wdI2fglAsRBCEfMQlKRnd5mLR/SRjYuc7BmDTlh+a2v3HF5jcKp9iCboBICHD0ab54hgv7zSkvNFuC/vg9rPVpciFeTV9dFFuVs60jjCuHKa98xNYO4SsjGE7SuZc3H+ldy0wtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=ERcLiu4j; arc=none smtp.client-ip=79.135.106.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="ERcLiu4j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1790668179; x=1790927379;
	bh=7tgvkiW9tuK5qU8lEBwCsfj/Lj2Gg4b9QPSYAhGCqvw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ERcLiu4jOZL7Sipf0y1odLzJjLot6jx2YtWnOFEPKvbMqYIY3O9EprBaA6rGmPDq2
	 8RwqDHsZoJjXUp8O8E3VWV81sI4E3GSW/BnS0wzrkaA9IQKNAaRACaA94giuGHQDRX
	 t2cv5KRhU7v0hZDgWTWrH26co4z1u7a0mUAwgGtZPKNGANg7enikF9D8SfvWEeRYCi
	 pjP+vQHJnQxXy7A9qZ/fOU38+JYzgrLBX24+8nYV/Hsg1SuZymw3VKXZA1hCXCedWB
	 DwDY7AwYLgl2O14qOsQ27f+b1FrbuDSMf4Qt7ilMntive0Vu/zBcYTHwmysB8mCH48
	 o+DbudJ0rXGHQ==
Date: Tue, 29 Sep 2026 07:49:35 +0000
To: Alessio Ferri <alessio.ferri@mythread.it>
From: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: =?utf-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>, "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: =?utf-8?Q?AW:_Re:_BCM4360_AC-PHY_support_for_b43_=E2=80=94_reverse-engineered,_seeking_guidance_on_a_clean_path_upstream?=
Message-ID: <hCBGuqVmDlV3Y7f2t6L8DtnoyBNbC8KghHXm0fZCHLDLrtfaoYw9e0UcCCsQHHK1X4TBz0DuvSL4zmAx_dVS3q54BZ0JZXtjXXNnuSAFtyo=@proton.me>
In-Reply-To: <20260929093405.79d9f4ec@DELL-MOBILE03.ad.smart.it>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me> <ih-lXs5OlHxMhydtcZFtKNhGg3cGlR137CEMZ07_zFQcfCYAImW6MRWPDjkdwy-xK9bIwpDK9ImgerqHmQMsAxX3ckEjsiN8QoCSlpvIsSM=@proton.me> <20260928200309.01a36f5e@barney> <DL5AS1oidqGRAmMHt0Jcp3X4T3ob_Fa-lfhTmMMak3ATUnfcyETDn65CQf3iLvVeg4ExYoc_0GW7QMoaB1jEW4nzKAKFDv8bD0hqBEtkUKg=@proton.me> <20260929081403.6076a6da@barney> <20260929093405.79d9f4ec@DELL-MOBILE03.ad.smart.it>
Feedback-ID: 189422222:user:proton
X-Pm-Message-ID: f23eb0d4d67ab88b5e3816eb09d4b0a76e1a2b66
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> > Maybe we can find somebody doing an AI implementation from specs.
> > But then, why not publish yours instead?
> >
>=20
> I'm still working on my driver for 4352/4360, so two of us actually.

Cool. Does it work? What does work?

So how do we proceed from here? I'm in the dirty room. :)
 
