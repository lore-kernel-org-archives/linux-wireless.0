Received: from smtpdh19-2.aruba.it (smtpdh19-2.aruba.it [62.149.155.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751A13655E9
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 14:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791641076; cv=none; b=FYtSfDPnbj94SuzZlvB/clAyUuq/I9A5QAyyZX8xl9pjvht0l70vcYm8QEwTUQbK2SuH6Lhl1r6bDqXAlhrBWkcQZSwJJkACFBpWfqariCYQGGe85kBxZZJgAUiVLtaZWcdo41fyy9xmu3vif1AR6/FzqKpfin32CIwKczLCKsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791641076; c=relaxed/simple;
	bh=Wd9f9GwwmM9GIDyVHxMqhFsw5KZ2xNUAJUlfYLKuxyA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAA893/ui5Dv7XC92Yjvr0qOspLZxyfMqQjcxOTd+55f8SZq2e8ujxeGg3gk9tgKV/4IvjMrDNakVgXoOPedoV+OZjqfrXE5bE3AzrLhUSbLs0llD9cJTJ8XYIEWU5up7Ri+jYrknxmHLJagZPADhZsBIkmtjc40U2qmVFMadEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=HGsdgo/1; arc=none smtp.client-ip=62.149.155.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="HGsdgo/1"
Received: from fedora ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id FXdaxkuIQQG1DFXdaxp172; Sat, 10 Oct 2026 16:01:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791640883; bh=Wd9f9GwwmM9GIDyVHxMqhFsw5KZ2xNUAJUlfYLKuxyA=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=HGsdgo/1y4gwiMSY/bfwd3/0OeuMKOosdj7ww/zqL2SMABdZ6ucoBeOWIQm1wjLh9
	 wAVjFOqIERDSz4pqKmTCCeU8lpK6SQz/prkdIkZJ+KgHaOXx9W1zPqs11A2Wn2/KdL
	 F4P+/rmT37wyAiv6SQBr4yxW9HlY9pctSFf+f0+ZzGesTJyLZXUA6H0hAhl0L6Lu1t
	 VjuY0J5Focc9JFoI+U4Le44rpiQ1e2oL+q+5YNWzzfnrI4qJ0VQq1jfqzFWa9qCa7/
	 52BtZuLQl8sWUqlpE6GOqzmNTWeVLj1SHJF9yWwOamTfZ3oVv7cuBm/jqoEjeTw+dl
	 Drr+iS/+fjDfg==
Date: Sat, 10 Oct 2026 16:01:22 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: b43: ac rev1 captured packets with ampdu
Message-ID: <20261010160122.5e82eaec@fedora>
In-Reply-To: <j7yDoG5_QzsvHn2hPYg-t1IRCKILne4bSf-E0ix15-48INcyh3HHnBydtcLdyWJCXh61NfsV1HawpRIBKpsGYzVzAfMCJIo3Z4Q-c20M15E=@proton.me>
References: <20261009173133.0e534ec2@fedora>
	<j7yDoG5_QzsvHn2hPYg-t1IRCKILne4bSf-E0ix15-48INcyh3HHnBydtcLdyWJCXh61NfsV1HawpRIBKpsGYzVzAfMCJIo3Z4Q-c20M15E=@proton.me>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfFEX7C8JUQJC5xBP4e/JrDgVZDCNdSgqvC4vIle9CPEafPaSmqNpYrMBTc+geQMZ/Bx8S6SSfRaUuusK9tguisa1A9kIUIfb3o4G5B/Exm4+gyiX6U+5
 NxcXByg4fm3Zmm5Eg1Rb6ve8otM/fH9lgXYhFaHBZa/yHUwQeuAXYlKuKqZZ9ZT9PBWEqnOhVG52zDVt13R38yQl0yUwlwzzwvFpSrHgKvDzJQZ1xdWTlxtg
 Zg/eUiD4c2GCgD1sse+Q3nncR7YAUYOmLiDMtWGop3U=

Il giorno Fri, 09 Oct 2026 23:16:40 +0000
"andreas.wendleder" <andreas.wendleder@proton.me> ha scritto:

> Hi Alessio,
>=20
> Thanks for the captures. I=E2=80=99ll look at them when I get to 5 GHz, w=
here
> my RX is still broken.
>=20
> Your driver no longer hangs my machine. The hang was my own logging,
> a 30 ms delay on each of about 80000 table calls. Without it, your
> head (ce2127a) runs the whole init in about 5 s. The radio doesn=E2=80=99t
> come up on my chip, though: after the first channel I get radio 2069:
> power-on timeout (0x040b=3D0x0001), so the RCAL done bit never sets.
>=20

Maybe you have still too many delays around power on?

> Your blocks (mode_init, set_reg_on_reset, coeff_bank_init, init_regs)
> let me replace my 290-write PHY replay with a 72-write init. 2.4 GHz
> now runs at about 20 Mbit/s up and 17 down. Do you know where PHY
> words 0x1739, 0x016b, 0x0175, 0x03c4 and 0x0197/0x0198 come from? I
> couldn=E2=80=99t find them in your code.
>=20
> Thanks, Andreas

Do you mean that in version 6.30.x, the driver write 0x1739, 0x016b, 0x0175=
,=20
0x03c4 and 0x0197/0x0198? Maybe they are related to bluetooth? Don't
know, will investigate it.

Thank you for your reporting!
Alessio
