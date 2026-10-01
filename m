Received: from smtpcmd03116.aruba.it (smtpcmd03116.aruba.it [62.149.158.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3511F3B47EB
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 17:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790874775; cv=none; b=KUrx8qbAtOqgELkIuSm4KlEKrMU1o7x80kfbB1q3EBrr4ulapEwRfJxr2L9XuHCLDqLp+IKAZ5xuDNDTRH+ZO8ek0q3uC3hT01w+cBQc3mY9Rq8EG3sIwOuy8TIhLWdqtAqi3hwbkZwXvLi3nUbxHZUGFxE0IXZ27lUlLva4Yfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790874775; c=relaxed/simple;
	bh=1EIllXH8ZPZt1z/PvduSpDeCQmmfKDl/WSQqL0I3+/0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KhM6BySlCVn9djjRAToiG0qBJk2upucE/7UiKwJE/ssrSE0IOzhztciw5SLv0N1GwHgl2iuKX8VZ3wHd5zF54Vtif8SUrpPLG5MACTstDOBpCcdBsmnuMzi57oeZPZOyLYwLRgkKwR8AB5gw5xK60+5P/F5dkx+XHE5jyezM2fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=cGBf7OFt; arc=none smtp.client-ip=62.149.158.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="cGBf7OFt"
Received: from localhost ([79.19.61.120])
	by Aruba SMTP with ESMTPSA
	id CKKixBNw3BqLeCKKixxYFv; Thu, 01 Oct 2026 19:12:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1790874757; bh=1EIllXH8ZPZt1z/PvduSpDeCQmmfKDl/WSQqL0I3+/0=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=cGBf7OFtfXQ/CZ7zPww7Op42kz9g9jmepwu2AiAzUxMn9dt2ehZU2BG3Ra2aqlLQG
	 6fnyDlZ6kiczFf5PhvGIcSmbX87kJJKY0ifBXfpmHvnOxJw60B5ouvXmyXbNXQKFly
	 cIfmkUd7gwXqNKy6XcPs8KKPnIQKa3O0Z+U/GCrpv9/L2hehvBjEQS1qJjJXqRza6a
	 o+uCuxaABKMtF9ihZ0gCR13sJygFcRydg3ICslSmSPD87q9CfozVtXD12cmIk9s0iq
	 UhF0J01B/vhrcc6pZNOqtYY/9wZEPS8jf3vhKa8UHucWMn5ILXHVC+/4fMprzyGsZa
	 nBq2xaesXWKPw==
Date: Thu, 1 Oct 2026 19:12:34 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4360 AC-PHY support for b43 =?utf-8?Q?=E2=80=94?=
 reverse-engineered, seeking guidance on a clean path upstream
Message-ID: <20261001191234.00001cf5@mythread.it>
In-Reply-To: <BGzX01_Xw0eP0rtUaqPn6IyCeg06zqkSQ8qKQoE38fN4Pzu_QmUjvB-pw5RuEdVn3hXqB3UAMap8WSTwRa8i6Zfg8XUmkhUEBavoBwppNmM=@proton.me>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me>
	<d6tVX7HBAW4Qnebx5Enj79edWG_LVmnRT0bjhcfv9bb1h0cewrTEDHK-VVoSy0NZcMzv3FB8OVEyTFNgA7rs_zaplEfiLXdwcCqhYDeonMo=@proton.me>
	<20260929105859.364ea71b@DELL-MOBILE03.ad.smart.it>
	<oYmDL00YinKfSdWHxkjmqPRGHWmeA_0SCR6tpafsgCvGyqYAEKuCt0kg7w_C47be5hm7IwFsxRnulMhvPFJEXQNDaDPgZNzMIQ0vfRKnOLw=@proton.me>
	<20260929113109.2c561844@DELL-MOBILE03.ad.smart.it>
	<OG0AU4A6pMu865qvxpXQjF7NvEP6p2bwR_IZRaLxONsn_3Gdxm00PiOOaGuWbYy-AmxhLGRyz29ZPtUKzDwsKJk_UjTLAU1bctgCzdWlNlE=@proton.me>
	<20260929221321.000023a7@mythread.it>
	<e3-qmDjhrTX2hFaCfmyNZHcixISRArPiYm-26_-33mbTBdryG2n375GF-6ewiqoXzodKocGBPYO2l3kWmr2wlJ9X8GK9-F3lUqmhnDP_TXI=@proton.me>
	<20261001080225.000011d9@mythread.it>
	<BGzX01_Xw0eP0rtUaqPn6IyCeg06zqkSQ8qKQoE38fN4Pzu_QmUjvB-pw5RuEdVn3hXqB3UAMap8WSTwRa8i6Zfg8XUmkhUEBavoBwppNmM=@proton.me>
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfCCgSFsVbt1DApD0f4FTXJ7rnuyr/1Kx6OlMGKy8MGVyd4V2XUxjIRTJnwaA7JqMgCjZNKpIEwKRRasC3TtaLSV2U7wE4twGTn+Zws3eE4qBfUWCVgBD
 RrFkNcH9RxwrKK1R0LX9FOuTwmEFb7fNQexF3pkA9i9K/OBV9xIv6OpYaHbQAKocLNpvaPgVZK6J8UU/tNMNd5Z6qKMiz1RQD4QL/0OU2HhhpU+Wx83MXT0w
 pO3XAnTpCAB5d87DyHy5i7K7eRpnK3sCU6m5CaQ0XpKfP1Tj/gamE9hGlOWE0O1K

Il giorno Thu, 01 Oct 2026 12:06:05 +0000
"andreas.wendleder" <andreas.wendleder@proton.me> ha scritto:

> Hi Alessio,
>=20
> Thanks for the 2.4 GHz trace work. Short status, then the questions.
>=20
> Status: b43 now runs as the daily connection on my MacBookAir6,1
> (BCM4360, core rev 42, radio 2069 rev 4). The 2.4 GHz station works
> with legacy rates and a TX status fix. Upload is about 18 Mbit/s and
> download about 10.
>=20
> The open problem: only about 21% of fresh inits can transmit. The
> state is fixed at init. In a bad init the PHY holds CRS|TXF and every
> TX ends in a PHY transmission error, so auth frames are never ACKed.
> A reload wrapper retries until an init connects, which takes 2-5
> tries. I've ruled out temperature, DMA, ASPM, PLL lock, clocks, TX
> core mask, TX power control, the CRS threshold and the MAC setup
> order.

Your phy initialization is still the verbatim copy taken from a run of
wl or you reconstructed the phy ops? Also, are you reading the srom
correctly as rev11? I have the bcma code to read it properly in my repo.

>=20
> I've updated the clean-room spec (=A710 covers this) and can send it if
> it's useful.
>=20
> Questions:
>=20
> Do you have a bus-level trace (wl-mmio-trap) of a 2.4 GHz cold init
> and first transmit on a BCM4360 (agcombo or TG789vac), including the
> calibration phase? I'd diff it against mine at register level. Can
> your harness score our driver's register-write sequence against your
> captures? That would show where we diverge without hardware tests.
> Does stock wl ever give you a "bad init" on any of your boards (the
> PHY cannot transmit until the next reset)? That would tell us whether
> the cause is in our init or in the chip.

Only 5ghz for the 4360 with agcombo, one of the trace is configured
with wep auth, note that the 5Ghz only 4360 is a 3x3.

>=20
> If your 2.4 GHz support lands, I'll test it on this laptop right away.

Thank you, i am trying to reconstruct the phy init for 2.4Ghz from your
trace

>=20
> Thanks,
> Andreas

