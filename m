Received: from smtpcmd10102.aruba.it (smtpcmd10102.aruba.it [62.149.156.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4005841CB57
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 08:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006278; cv=none; b=aOMGDZYS6cE1edMNWho0b9ge/0SNw0f9n01E9L351Ug5J+ELpm62nhRZ3RqOBgVyHTKSLtpESpZRDei0b/9C4ncnhXh0D6R7wMZZFTm27i7Nc1EzqSIyOrVmSfFHDJaieaTBMRZUcR6TNxYN+RQWm/IyCxhx7UmJen6xs6kF9BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006278; c=relaxed/simple;
	bh=WeWgdOo7ZDytIYaKKU/Onqw8G8iiC0gsRwYKQt8aT7k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=PatEJoTkNhMl7TjIwqVzPojzOX9UQdJ4Z1HRzHyPVJ5syR+RsBltZwfT1VZBE+GPqOj5X1/ybfB5IU0JzBDmN4PSIXraAq1x2LrYl9VGanpCLIjKD2hX55en/ozDTZed9Gtw3Ctsys3m2eB+CMlJYS1rtAUskyhqEYqffq4BDwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=Ix8iffuE; arc=none smtp.client-ip=62.149.156.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="Ix8iffuE"
Received: from DELL-MOBILE03.ad.smart.it ([77.89.54.34])
	by Aruba SMTP with ESMTPSA
	id rtliwdfMAIfDkrtliwYU4u; Thu, 06 Aug 2026 10:48:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1786006083; bh=WeWgdOo7ZDytIYaKKU/Onqw8G8iiC0gsRwYKQt8aT7k=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=Ix8iffuErGQgzAKnsIi4oR49G8x2FtV7PnkVLOseJaSKwz1UuQhYDL0ftHGeCa1Sc
	 YlEa60xU4POmfCkAwZlIEnYQZ1Hsb8E/Lw9l0maNMvAEQ828UuiDGTbUePupNTdL6T
	 /+1lsIuzX8sF3DTgbQJNzZai6qHCM6EPrm3DgnFB8OEimMExmsbb4VE7nO+7mq1X6h
	 2r9o5fvROb8uwnalOpt1D3o/p04eWiWXgMN9GO1cmp1tPfkiLMW9i/Wx1mEyWVqqK7
	 y6X1UbDKeOKV6AmFEUAcyzg3yi9uXJasSzm/33rjIgnDF30QvTjIPoL/nSEu+47RX1
	 gYHPJezlXEh3g==
Date: Thu, 6 Aug 2026 10:48:02 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Michael Buesch <m@bues.ch>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: b43: multiple parens bugs and double CORDIC_FIXED
Message-ID: <20260806104802.147ff076@DELL-MOBILE03.ad.smart.it>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfIwNugalfKyKKYa0X6tFVmHTaw19c0ck2bxh/8lVA4ZODp7deqLqLSSoxQcgkQElc6kszbI53awt6HEr90QzlrkEPxgg0BXJYJ9rGNkzqro6dlcoxJP0
 tvnfeeBnGGpZhebcf0Ns32xWKZaT/ZslNyGMliaQAGYYXhP7ivV4bxRTrKabZfWCM+ucn/fb6TpClslR4U6yj150pLW5N5I+8c+ZAsnnlJmpedyCpjqSWhyY
 gA6nPj2Hm0NOiPHxfqoBgYITHuHgmQmRVmClrV5iaqY=

I developed a tool to capture io traces of proprietary wl driver by
hooking on its io accessors and then started to check mainline against
the captured trace, i already spotted 3 bugs:

1) in b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)

abs should accept only offset[j] and not offset[j] + 4, immediate result
is failure to reproduce the write 0x3e for the same reads

records #3723-#3740, from "PHY.WR   addr=0x01b8 val=0x003f"

2) In b43_nphy_load_samples()

shift has more priority than and, so samples[i].i & 0x3FF << 10 masks
with 0x3FF << 10 instead of shifting the masked value into place. The
in-phase component of a sample sits in the low ten bits, so it is
masked to zero. brcmsmac packs the same table as ((buf[t].i & 0x3ff) <<
10) | (buf[t].q & 0x3ff), in wlc_phy_loadsampletable_nphy()

3) In b43_nphy_gen_load_samples()

cordic_calc_iq() call CORDIC_FIXED(theta) as the first op, so the
pre-scaling of rot by 2^16 is wrong. For reference brcmsmac computes
the step as ((f_kHz * 36) / phy_bw) / 100 into an s32 and passes it in
unscaled. The wrong scaling and the double CORDIC_FIXED() result in
wrong values.

with both fixes it reproduce correctly:

records #8638-#8959, from "TBL.WR   id=0x0011 off=0x0000 len=160"

Bonus: with the trace I also found that I introduced too many values
for the table r2057_rev8_init, while wl write only a subsection of them:
the ones marked with an extra flag in the raw data.

I'll send patches in a few days once i verified them on hardware, do
you see any problems with the capture & compare approach?


LINK:
https://github.com/aleferri/b43-6362-wip/raw/refs/heads/main/router-data/dsl-3580l/opinit-ch1-ch6-bw20.decoded
