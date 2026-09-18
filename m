Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9547C4519A3
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 20:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789762311; cv=none; b=A9GIcvfEZp0OTD3BjmTxyWQS5Z72YEttolLtzkcXUX2AaGve4xPf1rUL4Eh6qWmB3y2COOyPhNkSHHn9GTFVeuhZqyRZ5YuhKMjrpbRO+4nOLrQomOmQV5+1sMS0m/wug+5v6vd1g3J0BBIN3qKnWgMvawisKEnUIbyRhJCNGpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789762311; c=relaxed/simple;
	bh=aMI4Cs2Zm+pxMhbUHrwVWnyHKhr1DZ0T4zk9qYRUNiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CeJRxoznJ3xwAv7cNOUwYuHLXsx5izvZ23k0E9IND8mQWtj1koRzPVuuA5USuV23fHNVDtKYJ2WSdr2GVJNYqEm1HdWAN0TSGQG5Z2OSeVMsLMP5mAU7DGv8u/oIU4tyzZ7mzRV88WxOXBcvDYxWpA3D+HTMd8FTYmrSpwKZ1hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=BFHx/Z9H; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1nKa8lOS; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="BFHx/Z9H";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1nKa8lOS"
Date: Fri, 18 Sep 2026 22:11:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1789762307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KDJ4yAEXfk+uaWUK/hLTPmGHxFoj0+xAA2MyDf5pLKw=;
	b=BFHx/Z9HOnni3fUHyaoEJnAw1/gDrZ2QUg2wSqoab+1ihzBVuzFP5lIj5aFMrJOGlIOlCO
	TNDLDDg3GWdTEkMZzoTY9cKNvukIuu0hI0DtsC9pLeBBCrVpQYBzsPFubhGI+Cl1XaYdcq
	b+1AljYdw4I2ii0MmJYJCPvs06c+tvKdc0X4zxEIe57DS0CPdzc36O4+AyPDb62PL1YOvm
	aKI3BjwwCK7EB6FGkM0ufTHdVL26tuYGvQJyBXn1/Rg0Xyw2i+kHwHS09RHvZEr91moEIR
	H/YYIBEbmSCd5cDHFHshnrGuHl4HzNo6zg0HucIYDM2TFC7S3mddYFmB9wTG3w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1789762307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KDJ4yAEXfk+uaWUK/hLTPmGHxFoj0+xAA2MyDf5pLKw=;
	b=1nKa8lOSFvpfShx4DnzFnITlhUkaY+WBYs6Sg4FRvY1zlfxBQi1bj8BWoUgbA/TqPsgY/3
	1PN4fRsi/B9gi0Ag==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] wil6210: Replace %pK with %p
Message-ID: <20260918201145.kQDy1UrD@linutronix.de>
References: <20260918105632.pDhc9gIB@linutronix.de>
 <35e7ac7d-534a-4001-b076-56ca3e12bdb3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <35e7ac7d-534a-4001-b076-56ca3e12bdb3@oss.qualcomm.com>

Commit 71338aa7d050c ("net: convert %p usage to %pK") which is from
2011 and changed the %p annotation for pointer to %pK. Back then the
default behaviour for %p was to print the pointer. The %pK modifier was
introduced to able to control the behaviour of specific pointer values
without changing the behaviour of %p for everyone. It was dedicated to
avoid leaking pointers via /proc.

Things changed over time. The default behaviour for %p is now to print a
hash pointer which does not leak the address but allows to correlate if
two pointers are equal. I intend to remove %pK from the library.

Replace %pK with %pK in order to retain the pointer output for
debugging.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1=E2=80=A6v2: https://lore.kernel.org/all/20260918105632.pDhc9gIB@linutron=
ix.de/
  - Keep existing %p, just replace %pK.

 drivers/net/wireless/ath/wil6210/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wirel=
ess/ath/wil6210/debugfs.c
index e06e45323272c..79f5785697081 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -200,7 +200,7 @@ static void wil_print_sring(struct seq_file *s, struct =
wil6210_priv *wil,
 	seq_printf(s, "Status Ring %s [ %d ] =3D {\n",
 		   sring->is_rx ? "RX" : "TX", sring_idx);
 	seq_printf(s, "  pa     =3D %pad\n", &sring->pa);
-	seq_printf(s, "  va     =3D 0x%pK\n", sring->va);
+	seq_printf(s, "  va     =3D 0x%p\n", sring->va);
 	seq_printf(s, "  size   =3D %d\n", sring->size);
 	seq_printf(s, "  elem_size   =3D %zu\n", sring->elem_size);
 	seq_printf(s, "  swhead =3D %d\n", sring->swhead);
--=20
2.55.0

