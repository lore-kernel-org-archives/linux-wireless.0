Received: from smtpcmd03116.aruba.it (smtpcmd03116.aruba.it [62.149.158.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF6C2DF6E6
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 17:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790876242; cv=none; b=Gv8Rg3OWDIkYV4nTyMLvz1aeNqUl1WYYKWmkDmU944l1kUPQii4Y6XIBK/EDskn+PkMUWdwWBmVJkHL6xu83L9ceFYO+cbUY1TcPvTln+YfY8cIlE08WJoNNSWLoJg+POGaPPm5WTy55sKIBkkGPcqM2F1sRARljg7v9vDS2q80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790876242; c=relaxed/simple;
	bh=nmGEjF4CTzLIqCj/vWD0XKLrcbQNRy56Bd3AV576V7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GZKpSwXWeXWsTaQhNPaPah+I+RSNjbgxjG6n54mvQZ9xLwhCVRXvxX8Gta4NZkfBJsy7wT9me8+sjDsjKNcp0khNBdt5HlptKYnHhHYUHSrofSfl6hWkiqQdXlvXxHAQrhq3+YiAAnvpQsKkjeUCIWLgrAHtkEwsk7YYaqDNgQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=GyB6T08r; arc=none smtp.client-ip=62.149.158.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="GyB6T08r"
Received: from localhost ([79.19.61.120])
	by Aruba SMTP with ESMTPSA
	id CKiZxBr4VBqLeCKiaxxdEf; Thu, 01 Oct 2026 19:37:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1790876236; bh=nmGEjF4CTzLIqCj/vWD0XKLrcbQNRy56Bd3AV576V7Q=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=GyB6T08rG2om8OlcBFsIoIU7sr8UTX9GL5cc+rQPqp6XfZ3JB8ZJSl1yoskqKuh2j
	 auOgxJ9TGfXT0rQLOqDUJ5ddzRtue2FmgKXzSc0I51GQDgELFfMHTX+t7r8x/FVR6f
	 U47vA9gJjkikI6y6cQIAIGki9HGzHe0ukM0Q7xQogz5FsnLeeJnBO0/pZRpApBUb6O
	 L8WLNoJ0D5Byula68GTRshi1dF+GA8BlfbEYbJkAprRJ8XnO/jpmtuFrXuGzF68vBi
	 CNOLaEtzbDXHT41gs3OTm0fakLs4doLvMf3SON25VVzlaMDB8Muayt/wcp7fYK3LHp
	 OxlvASPF0ts0w==
Date: Thu, 1 Oct 2026 19:37:14 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4360 AC-PHY support for b43 =?utf-8?Q?=E2=80=94?=
 reverse-engineered, seeking guidance on a clean path upstream
Message-ID: <20261001193714.00005f36@mythread.it>
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
X-CMAE-Envelope: MS4xfKCXubytY/PO1dEMnnFYik3teCHW/iOAs6CvHs/14EHAeAyruyNNx795i6sRvSX8cchUyk36FsTy6akcU0/rI0D/lZLkI+UAn31n2Zmja5tw67vvMGsn
 7JIj6pe/9GPLec48mZfOp+uE6sWzmXCOiJyyxkEFs0iZBcYxxoyS4W8xmWQQj0VexA0tWSRNlVYlANbphjYSlxJ6Mrqgu3tK+aeZDrFfHEsYKRfGI8vW+xrn
 gfQtoMt5Et6hMCSARKN9FHkBDeEHGDzqaqEiqjJVtV9WiGFj7Z08CAtHDcXFpBVJ

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
>=20
> If your 2.4 GHz support lands, I'll test it on this laptop right away.
>=20

Oh, i forgot, you have femctrl =3D 2, all of my boards have femctrl =3D 6,
so probably the calibration is wrong for your card, but now i try to
fix it. Thank again!

> Thanks,
> Andreas

