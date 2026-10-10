Received: from mail-07.mail-europe.com (mail-07.mail-europe.com [37.187.220.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4E745DF47
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 12:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.187.220.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791637169; cv=none; b=C8aTdC35XguaQLPFXy5tlYG+84QqxB0ZmY3wM5qW950myMXTszsPGmlBb1ieyGIp+M+HgSqP2W5NwSs5dSGFhHC5BwAC3BPoV6xkad1zre4RM14SMkTDSjqAjQCK73SVpo/iZJ8c8tH5IaJwmX6zF9D/Gu279DK9EwqFiQJbNTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791637169; c=relaxed/simple;
	bh=MI+8PN2/zIOWn2mTez33GFToppwo0vdsMpNsvGptsys=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u8QqfkGooXiqXR1vBTMw4M+D4lDOTFvgOlWGzl4+7BJ0j/L90ODBm4/Raxmicos5h5GhZuYSXTPBZvO1w2hlkWYPG4gkx7DW7rBywW5blBcuFYfZdzfMfP3KmKrKf2h/lacXPH/soeXvcAYdk6NKJLyMslpBtqDghwiZ0Uixano=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=GLVDOCoM; arc=none smtp.client-ip=37.187.220.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="GLVDOCoM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1791637154; x=1791896354;
	bh=y2ZOtATjEA4SLTsh8hkSk1w2NEcMCjXPPs+g9p1ucio=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=GLVDOCoMT3RNAz9sATx4xed3R0akaV+Xdf8T4O3uf7ORAnKncpmgpX2QQMlmu8WOp
	 mUB+lqxPKIhYgPoQrGLxBCME+/BI2sHAjPRjc3a8EHRHi8OFoqCk9s3H/wIFSyZNxL
	 DcsTBMmjIoEeXCVeLHIu5mR+w6g6p6KL5Q0rRb1IMXXpMYzeQvIw6jb5RjCaLBrAte
	 kb8InggmoQz3uX0ZpcNHs9Pfw9NsnHnwCuQPITtem8XjVYaNSSHrRIKkZTb2gQoTN8
	 uQOl/o11Vsxm3E653dVSEwpBiQSnrc+ADYDozFp8BHUy3xH+TiNZ+QrptX/xWcvoYi
	 mDXEW5dr0h7CA==
Date: Sat, 10 Oct 2026 12:59:10 +0000
To: Alessio Ferri <alessio.ferri@mythread.it>
From: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: AW: b43: ac rev1 captured packets with ampdu
Message-ID: <1NF3n26c1UQ1YcYwXT-JD8OKl7dIr_22x7bgdLLwLHkWHnKlZAtcYw7504hufNHGIBEo3qr8atDAoKtK6qxtLUfVWhVSazjaIH5QPYGAgs0=@proton.me>
In-Reply-To: <j7yDoG5_QzsvHn2hPYg-t1IRCKILne4bSf-E0ix15-48INcyh3HHnBydtcLdyWJCXh61NfsV1HawpRIBKpsGYzVzAfMCJIo3Z4Q-c20M15E=@proton.me>
References: <20261009173133.0e534ec2@fedora> <j7yDoG5_QzsvHn2hPYg-t1IRCKILne4bSf-E0ix15-48INcyh3HHnBydtcLdyWJCXh61NfsV1HawpRIBKpsGYzVzAfMCJIo3Z4Q-c20M15E=@proton.me>
Feedback-ID: 189422222:user:proton
X-Pm-Message-ID: 302d02b3899688e5c14eaf1f9d895c696695837a
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Alessio,

Three findings on the MacBookAir6,1 (2.4 GHz, ucode 832.127), all thanks to=
 your code and captures:

1. RX level. Your rxgainctrl write 0x1726 =3D 0x000c is worth 26 dB here. W=
ith it my remaining PHY table replay is gone.
2. Second TX chain. The chipcontrol |=3D 0x8 at the end of your fem2_sub1_s=
etup is what turns on TX on core=C2=A01. I had ported the two PHY writes bu=
t not that one: core 1 did not radiate and MCS 8=E2=80=9315 failed complete=
ly. The bit survives a module reload, so it only shows after a cold boot.
3. A-MPDU TX works, with the microcode building the aggregates as in your n=
otes. What it needed beyond 0x45c0 and the cache info:
   - the frame's seq_ctrl in the header's sequence field;
   - cache info bytes 0=E2=80=931 zero when encrypting in software. The sto=
ck 50 04 makes the microcode encrypt again: the AP acks the frame and drops=
 it;
   - session frames reported to mac80211 with IEEE80211_TX_STAT_AMPDU, or m=
instrel_ht ignores them;
   - the attempt count of a status (word 2, bits 7:0) divided by its MPDU c=
ount;
   - a requeue in the driver for MPDUs the microcode reports unacked. It gi=
ves up after a few attempts, and without the requeue TCP collapses.

   Result: about 30 Mbit/s up at HT20 over 15 minutes, against 20 at legacy=
 rates.

One question: my TX gain sits at index 64 of acphy_txgain_epa_2g_2069rev4 (=
the reset value), and going to index 96 collapses the link at 1 m from the =
AP. Have you seen what a healthy board transmits with on 2.4 GHz, or is the=
re more to the PA/FEM setup than fem2_sub1_setup?

Thanks, Andreas
