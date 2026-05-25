Received: from smtpdh19-2.aruba.it (smtpdh19-2.aruba.it [62.149.155.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E381379EDA
	for <linux-wireless@vger.kernel.org>; Mon, 25 May 2026 19:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779737296; cv=none; b=kFVx2erOCdSCosL9RSMe1/cUjdO7YQAlByhelM1fcT1XE3qc4iKQs9AprjP9Crd3+d4Vnjz8CmBn70IDgIgrGYsXEppOC8jC5jwfru77R8obZ+n+zEfiIup2jav7mkLxKRDJnXB+mJ8n4yTgHYrvroC8Qhs6kHt62cg0oyYHFUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779737296; c=relaxed/simple;
	bh=ciiSIPOHoz25geGrQY/X3wqZon1rIzUIMwbhH9fHrYM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dhW5ulriEZdleHqrxJ3vLkjjjPfk6uacm41B7yXu7Vk6Htf57cas/lzeX91idzokWqN+vFjIMQowAs//eUCgyp6nzJpQiXy4wk96dOJ0fd4KTrs7s6KPoLkt4CD7YKgE6KQNzx8VM/OdMmPu/RAyy0NoBN6rKWmhkzI+LHxiV94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=SCqjHkEM; arc=none smtp.client-ip=62.149.155.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="SCqjHkEM"
Received: from fedora ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id Ray5wLMmpclBZRay5w7bYd; Mon, 25 May 2026 21:28:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1779737285; bh=ciiSIPOHoz25geGrQY/X3wqZon1rIzUIMwbhH9fHrYM=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=SCqjHkEMzaO9XKxTM56CJosM8PjVZuMpG3c9reO6kteVwobL1VwcpHWIhj4BTN1dB
	 kZZJJaMQiEiG65/mi8r40qcIMWJkZRgSxrXpCuJgZegqfjLVSoZh+kYWioOyiESY9A
	 hLijof27YRSviaJt6BujfP3NiL9M3fn6HeUFBnBwjtp4ploApxSCjgl8ktyUcfKXBF
	 eqhfSU0l2+Ie97nFOmL4X73N37uYHEiiWUUXPeLNlqBakqGf+DzgSw5sZLFGZfrUX1
	 9bU80spW5kMr6Pslio1m6mLmlB9DbAbN8n2PgaMMN/RMyG8MhEPheo830DCq9ubdPX
	 CW6yEdimK37oA==
Date: Mon, 25 May 2026 21:28:04 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] b43: complete N-PHY rev 8 + radio 2057 rev 8
 support
Message-ID: <20260525212804.7bfbc4fc@fedora>
In-Reply-To: <20260525201405.6c60420f@barney>
References: <20260524-b43_complete_n_phy_rev_8_radio_2057_rev_8_support-v1-0-cdad2c8526c6@gmail.com>
	<20260525100752.16cdb59e@barney>
	<20260525140438.265975e7@fedora>
	<20260525201405.6c60420f@barney>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfExFWzYwp0AFqgtYxb1nXLBG/12VzMdzQsyZaES3CJHL1u3kYPtZpgV4+43JqWmygQo56VcMrrBW/+mn2fX/+anfn1Sg8uYwR30YM1IgA5GWetUr0BUS
 BYRt9iyDY2fZjM+dkbdkOnwy+ph3inhv0ZjNgGA6LAsJWSwq40UHgLVJzen1X3zjFrY4Up0vqgPLi72TsxWWbDpiOv577J0wNsJ8MFAVqrEcu/eddkMoxq0A
 B6H7G91kHfxnsjpJysvXXXi8Zv/fbXgbcxmi48afQezqg5j6shxOU6nSxAfIaE2Q

Il giorno Mon, 25 May 2026 20:14:05 +0200
Michael B=C3=BCsch <m@bues.ch> ha scritto:

> On Mon, 25 May 2026 14:04:38 +0200
> Alessio Ferri <alessio.ferri@mythread.it> wrote:
>=20
> > Please clarify "full expected wireless throughput", HT is
> > not supported by b43, so it runs only with NOHT in g-like speed: =20
>=20
> > Enabling HT for N chips is out of scope, also there nothing to
> > gain and a lot to risk, so i won't do it. =20
>=20
> That's fine.
> Just wanted to know if there were known problems.
>=20

Did not see any obvious problem for now. I Will try to fix any issues if
someone find some
