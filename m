Received: from mail-07.mail-europe.com (mail-07.mail-europe.com [37.187.220.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D033033F8
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 23:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.187.220.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791587828; cv=none; b=SCof5Qyy0HNGgyBqzDLYMyWCBUPAA9ldirwvqZ0UpaDj4KuRfPX8Qi3kvrdJXwSFE19Uq7c2461vkaGuS4Mi5/rsbTN9WUcE+pXxCYSFqUbgQwLyNHGFCCMFMq3UKKDwaWi+Hnld0c+vrQSWaqc4jUl3lRsqiDhP8mPWMoUBanQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791587828; c=relaxed/simple;
	bh=P5oNEgM3ysRpyMqs78Z+nTrk8eBmaZqQbwtZdCbXP8g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lKPVL7tGknV89ZA3xccT26oqBOELSxSGtmQ8AWDDXfKj348gnyQWhe9wNfLi4W6tJ+Q9TwGlJhzDE/jQJwthncsaY/HZ4H8DDhm9VnwippibwOeJ/HkgYWRuzmDGjF4fQf2yNu321bWF8KoXXxFCDHoz6nb9wpmfoTaF4ZnKFsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=UM80zoiN; arc=none smtp.client-ip=37.187.220.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="UM80zoiN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=zvhz567xknc2fha7bshnox6wb4.protonmail2; t=1791587805;
	x=1791847005; bh=P5oNEgM3ysRpyMqs78Z+nTrk8eBmaZqQbwtZdCbXP8g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=UM80zoiNPeZb7Y4GljDpUpzZorkaDJ+QAvoH9cDCqGvvttkGo/qVL8p/HJ7pWu+rH
	 ffAfBdqjGcLabs6IoEIqRXcDjLEpVmSIkMKpRXh4m3KRcP0gMLHXEtMUlUMjD8j/gz
	 Md2SpgTee8sk1TP9GxPOdQLFwKJiyoiDePnTImV879Zoq0500gLqLlMdJQppqZbqAh
	 1NlT4Mg8khQvuj2zR0mXQLKUaD9K4h2ozOwyeHDcIQvNKo8N88hbQa/4eOPrLkbKEY
	 ajrL/53yKTUDaIkyYuv8zf8O0y+eO8qgXlv3zhLIrkT7jhcTmgQP6O/px83/+D5hyG
	 tl6C7lb/geobw==
Date: Fri, 09 Oct 2026 23:16:40 +0000
To: Alessio Ferri <alessio.ferri@mythread.it>
From: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: AW: b43: ac rev1 captured packets with ampdu
Message-ID: <j7yDoG5_QzsvHn2hPYg-t1IRCKILne4bSf-E0ix15-48INcyh3HHnBydtcLdyWJCXh61NfsV1HawpRIBKpsGYzVzAfMCJIo3Z4Q-c20M15E=@proton.me>
In-Reply-To: <20261009173133.0e534ec2@fedora>
References: <20261009173133.0e534ec2@fedora>
Feedback-ID: 189422222:user:proton
X-Pm-Message-ID: 6f099c9de21f2cc7c6f8af96c73679320c24fcc5
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Alessio,

Thanks for the captures. I=E2=80=99ll look at them when I get to 5 GHz, whe=
re my RX is still broken.

Your driver no longer hangs my machine. The hang was my own logging, a 30 m=
s delay on each of about 80000 table calls. Without it, your head (ce2127a)=
 runs the whole init in about 5 s. The radio doesn=E2=80=99t come up on my =
chip, though: after the first channel I get radio 2069: power-on timeout (0=
x040b=3D0x0001), so the RCAL done bit never sets.

Your blocks (mode_init, set_reg_on_reset, coeff_bank_init, init_regs) let m=
e replace my 290-write PHY replay with a 72-write init. 2.4 GHz now runs at=
 about 20 Mbit/s up and 17 down. Do you know where PHY words 0x1739, 0x016b=
, 0x0175, 0x03c4 and 0x0197/0x0198 come from? I couldn=E2=80=99t find them =
in your code.

Thanks, Andreas
