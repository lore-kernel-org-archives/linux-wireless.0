Received: from smtpdh19-1.aruba.it (smtpdh19-1.aruba.it [62.149.155.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EC8377575
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 14:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791641635; cv=none; b=pIoFs9UMB2+LSK8D4zlqvC4DoEnh07KKg/WRRN9eTBXNJ7RRcioPZJtDXcOorMzkP1eH9LJrG3x3mfzy7dK2b5BZ8dwdAhX72nVT4RV96ZDlmfyVLZPQ42n+3qBtv5wkxgh2FPphsHjF1REljNLt5bkwCgHXbUP2QdLkPjZowLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791641635; c=relaxed/simple;
	bh=Iyl6TGaVibC42zbsZ2aQAgRKXV8UOHZwL3f1fJOabgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kdXRpqroy2iSMIdB9887+l2DVtrbfadgLROkbRnAbcaOSuplCAdq8nyIgZOz4IDArzoUyWhmWU26RSkKJ2UfOiDzWp6MvfnARMOXgxHQGe+mDqp3KuGWY9ASr+FbhjtiuL+sFVWUyS9PvwygQKfkC2FekiF5Uj7GKCxqJ7Lw5Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=MkP1R+JG; arc=none smtp.client-ip=62.149.155.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="MkP1R+JG"
Received: from fedora ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id FXmdxl0jOQG1DFXmdxp4Wy; Sat, 10 Oct 2026 16:10:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791641444; bh=Iyl6TGaVibC42zbsZ2aQAgRKXV8UOHZwL3f1fJOabgQ=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=MkP1R+JGcSin1spya7qnNInITaMM+Gjm3FqYldhRnlyZGJ9Rm5kUxgQyIz+fqEGkG
	 nMHfFdJ+wEWF8tV2IR3TbEiqiPILR2u5BmqGwTZDhFpAMr+k+oB5N0sA+Xc2DxS/p0
	 jExeY31BNL8Z8mPOsjlqdttD32Z4lEQ7EbRR7dcznYqV5qBys0rdQWqF0ft7IPMo2K
	 1bJxdUcjvXefgB32yBQ78tkj1hR7x+bzzXQcVDfnVncW8qQGe+upUnOCNqEhD3PTsj
	 SbUYTC3TxlbcsOXpSYW4LaQ7JkjfguhE5SLf3cRxV8pkXcd2+ckkxJ+FaOhCOBcyA3
	 ihYjkNtyaqvOg==
Date: Sat, 10 Oct 2026 16:10:43 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: b43: ac rev1 captured packets with ampdu
Message-ID: <20261010161043.5dd21203@fedora>
In-Reply-To: <1NF3n26c1UQ1YcYwXT-JD8OKl7dIr_22x7bgdLLwLHkWHnKlZAtcYw7504hufNHGIBEo3qr8atDAoKtK6qxtLUfVWhVSazjaIH5QPYGAgs0=@proton.me>
References: <20261009173133.0e534ec2@fedora>
	<j7yDoG5_QzsvHn2hPYg-t1IRCKILne4bSf-E0ix15-48INcyh3HHnBydtcLdyWJCXh61NfsV1HawpRIBKpsGYzVzAfMCJIo3Z4Q-c20M15E=@proton.me>
	<1NF3n26c1UQ1YcYwXT-JD8OKl7dIr_22x7bgdLLwLHkWHnKlZAtcYw7504hufNHGIBEo3qr8atDAoKtK6qxtLUfVWhVSazjaIH5QPYGAgs0=@proton.me>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfKbL/v6FFsbOLu3r63I+xWYyxvPT1UQtO8fj7kKcOjWJEe5keWRHjLoHGftXSX2gAKii3hqjHxBiJ/EOHjOATYF4OHvpMwD4bn6jNe36aLV0JUc2L4Fx
 PjYChlsP+jUN0SICTZmjPg82QOA7niBCJ6I3ejXWXBLlWL8XOJPyQVKQlG/w8w09tIWdqcRS3E1/8QPEKG+Y12yt4oQ0Wl++oA+oE00g6MEX17gYQW3RQAMQ
 ppadGR9GcTYBokUNR00zRag6RCvbHUcZ5LTLc7v5Qf0=

Il giorno Sat, 10 Oct 2026 12:59:10 +0000
"andreas.wendleder" <andreas.wendleder@proton.me> ha scritto:

> Hi Alessio,
>=20
> Three findings on the MacBookAir6,1 (2.4 GHz, ucode 832.127), all
> thanks to your code and captures:
>=20
> 1. RX level. Your rxgainctrl write 0x1726 =3D 0x000c is worth 26 dB
> here. With it my remaining PHY table replay is gone. 2. Second TX
> chain. The chipcontrol |=3D 0x8 at the end of your fem2_sub1_setup is
> what turns on TX on core=C2=A01. I had ported the two PHY writes but not
> that one: core 1 did not radiate and MCS 8=E2=80=9315 failed completely. =
The
> bit survives a module reload, so it only shows after a cold boot. 3.
> A-MPDU TX works, with the microcode building the aggregates as in
> your notes. What it needed beyond 0x45c0 and the cache info:
>    - the frame's seq_ctrl in the header's sequence field;
>    - cache info bytes 0=E2=80=931 zero when encrypting in software. The s=
tock
> 50 04 makes the microcode encrypt again: the AP acks the frame and
> drops it;
>    - session frames reported to mac80211 with
> IEEE80211_TX_STAT_AMPDU, or minstrel_ht ignores them;
>    - the attempt count of a status (word 2, bits 7:0) divided by its
> MPDU count;
>    - a requeue in the driver for MPDUs the microcode reports unacked.
> It gives up after a few attempts, and without the requeue TCP
> collapses.
>=20
>    Result: about 30 Mbit/s up at HT20 over 15 minutes, against 20 at
> legacy rates.
>=20
> One question: my TX gain sits at index 64 of
> acphy_txgain_epa_2g_2069rev4 (the reset value), and going to index 96
> collapses the link at 1 m from the AP. Have you seen what a healthy
> board transmits with on 2.4 GHz, or is there more to the PA/FEM setup
> than fem2_sub1_setup?
>=20
> Thanks, Andreas

Increasing bits density per air time cause transmission power to drop,
as the modulation is more sensitive to distortion. By raising the index
you reduce power, so it works better near the device and much worse
from afar.
