Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A48032A3E5
	for <linux-wireless@vger.kernel.org>; Fri, 24 Apr 2026 08:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020076; cv=none; b=mObIX5bNs2MzYWmc44rw8cuadRrl1RkuAGIjrrxCDKt4vrl214qpxNngXfuwmlg2wTHMNGvEtDoIXG6Sghwuk8o9P9ASPwhZ3oRsSbm4lHPbWxA2ung+VFijQ6qTyDZCY44oWfYa0IN7PXD9z6NuKiQuxzgQ6ueUXBZW12KGFZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020076; c=relaxed/simple;
	bh=DKksjASOOqAqQTcMbQSn8hwSxzfGGydWIiG+EBSTjrA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BBPHgXXI/I/EcVOuzzbZgWI65df8wXAoybeVMRbG8wqRRPacowPKeZjAH+3Y2BBJy62ijT27yxCd/QuVmcx5WaEwQTIg8dJqA807g7ASgfEY0VgosbFTwtLnR9r41U1qAZxsKXl6rYCJsAQGs9kgvmoi5f6ajUZ1/Vc7ZoumgHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=lmrY4JHU; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="lmrY4JHU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=DKksjASOOqAqQTcMbQSn8hwSxzfGGydWIiG+EBSTjrA=;
	t=1777020073; x=1778229673; b=lmrY4JHUD3+PTWzM2rJbwbdLxe9T1rQI7xc7OsOwTINbB+f
	WVNvahXzd5+PlNF6kR/s24x1nEIPrfZBAFD6qI9a1m9H1+LP3oCZU21uV19icZqF8tc5gKCml2n/+
	N34YL7BqVFpNJ+/bDB6EdaqB8vyGyyP08oTbT8Il4chKwceTMILJ9H1Pc68qK7Os6ihbNaMKFHFxS
	tBycUcKTtaat1DX7YRQTPmPS36oS0xZsBg7rNpiNaP1CGYNXDb7jBPpPd1DeNGVridMmHAJA1Roqv
	hwuHRJIgzNR9J9rFaT9iDhG0MwTk1QJbU7Qp6TmmugAKpep2/b15b42YleSZQXLA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wGC5w-000000096PK-2pvg;
	Fri, 24 Apr 2026 10:41:04 +0200
Message-ID: <2572d9663012ac4481d6c32aa9a4f252162c9bce.camel@sipsolutions.net>
Subject: Re: mac80211 HT/VHT MCS check change causing Wi-Fi speed drop (~20
 Mbps cap) on iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Jayden Fowler <jaydenfowler831@gmail.com>, linux-wireless@vger.kernel.org
Date: Fri, 24 Apr 2026 10:41:03 +0200
In-Reply-To: <db830769-2681-48ea-a8aa-f4cf8f3dfa4d@gmail.com>
References: <db830769-2681-48ea-a8aa-f4cf8f3dfa4d@gmail.com>
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

On Fri, 2026-04-24 at 04:28 -0400, Jayden Fowler wrote:
> Hello,
>=20
> I think I=E2=80=99ve run into a regression in mac80211 that affects Wi-Fi=
 speeds=20
> on Intel iwlwifi (and possibly some Realtek cards too).
>=20
> After testing a bunch of kernels, I noticed something pretty consistent:
>=20
> Kernels with this commit Wi-Fi gets stuck around ~20 Mbps max
> Kernels without it (or after removing a small part of it) speeds go back=
=20
> to normal (hundreds of Mbps as expected)
>=20
> The commit I bisected it to is:
>=20
> 574faa0e936d12718e2cadad11ce1e184d9e5a32
> "wifi: mac80211: add HT and VHT basic set verification"
>=20
> The issue seems to come from the new HT/VHT MCS verification logic. When=
=20
> it runs, it sometimes decides the AP=E2=80=99s advertised rates are=20
> =E2=80=9Cunsupported=E2=80=9D and then forces a downgrade in connection m=
ode/bandwidth.
>=20
> That downgrade looks like it=E2=80=99s what causes the big speed drop.

Yeah, there are too many AP bugs ...

https://patchwork.kernel.org/project/linux-wireless/patch/99Mv9QEceyPrQhSP5=
2MtAVmz0_kWJmzqotJjD9YW6LGLqk-AZloAueUyHCURilFkuqOh6Ecv8i2KKdSE1ujP3AnbU5QE=
ouVisT1w_V3xdfc=3D@r26.me/

johannes
