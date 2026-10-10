Received: from mail-106102.protonmail.ch (mail-106102.protonmail.ch [79.135.106.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD1A2D47E9
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791641771; cv=none; b=Qw2RZBKTTY68IJPnpx5iYcmWyEgVm0TCIsbG+DpBogihTxZ1BFuCzhmsc+2WVXG0IBF/PspvV6OgAJwfMmDh87Oxlpb+C6usHAGJRbBw1IjLUmXbVK1NZ4TjL7xRlv7pIrQmru2Ox4ozT7nLZ27wrbEtRLD4yzlIvFhS+y602yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791641771; c=relaxed/simple;
	bh=ZN6ZAvVnCZBWJdRiKMkePdSCu27j/ybBEUzdioDgWZM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I5FbKlFMXyEU6HTh87IJFhkrtHVVbT3Aqqx0ml1UmN9EDkfsj00q+ZlGNcDnTIeFFbXabZ1v9p5jQBbR0I/bFqSke05WZ//PBrBb75T1mw8KpJyvaydfjURPl6sFVfDLdDi7+JxR72vfQEdggpFAD8bAIda5nbommBDdG/tgaZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=qLfdtowe; arc=none smtp.client-ip=79.135.106.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="qLfdtowe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1791641757; x=1791900957;
	bh=ZN6ZAvVnCZBWJdRiKMkePdSCu27j/ybBEUzdioDgWZM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=qLfdtowehTTJl56MPahXBXTwNFkK82AB78bcEjmJ5HFobvroZcmcsZSsrgiU8B+ly
	 aHpss4YwJK2rI1EVMCwg1AATJDVwcsIsMtZ3756tn+IPIM9ptWJaZS7qcRn+eFBYuH
	 ktHOJxvbDn1xNI/CSEji4MZ6QXUF6qVVeQFxr3kWFeDgfyqbViSvDoQGx+IhZTWwdD
	 qo7hsnHABeJWDUKo25S6FxCmGZECjkY8SIoYCfdhk4DUIGq5X81cZ+1kSD8BhNwIML
	 rjWKN/yrzHXbcsztoq5xkiHzYraxX1jGMSBmteJgnUEpn5ddUox5uMDymc9T6iAAXR
	 uqQaJa900PUMg==
Date: Sat, 10 Oct 2026 14:15:51 +0000
To: Alessio Ferri <alessio.ferri@mythread.it>
From: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: AW: Re: b43: ac rev1 captured packets with ampdu
Message-ID: <waSj3jvDuNtKDHP_lrLDt-1KAgv7xgyvTwKtdnXv18FPaVH12yRZk0f-bVfrApfaHnsALsEpipfhkgv0UvRQdMPiyj_tmKRVMwg1G5jDZmg=@proton.me>
In-Reply-To: <20261010161043.5dd21203@fedora>
References: <20261009173133.0e534ec2@fedora> <j7yDoG5_QzsvHn2hPYg-t1IRCKILne4bSf-E0ix15-48INcyh3HHnBydtcLdyWJCXh61NfsV1HawpRIBKpsGYzVzAfMCJIo3Z4Q-c20M15E=@proton.me> <1NF3n26c1UQ1YcYwXT-JD8OKl7dIr_22x7bgdLLwLHkWHnKlZAtcYw7504hufNHGIBEo3qr8atDAoKtK6qxtLUfVWhVSazjaIH5QPYGAgs0=@proton.me> <20261010161043.5dd21203@fedora>
Feedback-ID: 189422222:user:proton
X-Pm-Message-ID: b2e3469ff78230b1de8b286a99a0f4d844869278
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Alessio,

On the TX gain: that fits. In the basement (-70 dBm) index 64 carries no HT=
 frame at all, index 20 works, index 0 is worse again. The reset value was =
just far too quiet. I now use index 20, inside the range the stock power lo=
op ran at here (0x14=E2=80=930x26), until I have power control.

RX aggregation works too. It only needed accepting the session in ampdu_act=
ion; the microcode deaggregates and sends the block acks. Both directions a=
ggregated: about 30 Mbit/s up and 20 down at -70 dBm, against 13 and 10 at =
legacy rates.

On the RCAL timeout: that run was your unmodified head without my logging, =
so no added delays. I can rerun it and send the full dmesg.

On the PHY words: yes, these are writes of the hybrid 6.30.223 wl on the Ma=
cBookAir6,1, from my MMIO trace at 2.4 GHz: 0x1739 =3D 0, 0x016b =3D 0, 0x0=
175 =3D 0, 0x03c4 =3D 0x0668, and in channel setup 0x0197 =3D 0x0014, 0x019=
8 =3D 0x0010. Bluetooth is plausible, the board has BTCOEXIST set.

Thanks, Andreas
