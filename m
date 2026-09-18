Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC39C4C77BC
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 10:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789728998; cv=none; b=HTn1maRFxA1Dh7X1px6yJ14YyIZbOIieYAM1E53n5SyOIrelIKqOhXitfTBsPTTFaoeqqB6d6t+JTL15G1AnDxz3F0D2uZbmhRHXohnN7DkXHdd/AvsNhs+93OqmILyUtll+CfXWaYticuEISlOWcf2ZNabEK105kE5Z4YUYhlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789728998; c=relaxed/simple;
	bh=QtWvfpizCZX++EA3+GcmcpRKDUI1xzro2UKBuhxd9N8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LOPYRT/3k9A9ICokOvFTpjK5/yg4urDjWcBUnmP6DkBCFsEHTnrmhx1nv9Zqi7v5wLv1R+E1tJpPxJs46yW4Yst1/BOcSIU49nROCSEpIqhwWhYFESkTbrWvWz1+NJZfoisWGVQhklmgKWXLGIUErZWKQzT0wPKTKEbv2coFHSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=HWsvkfDq; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=crFOtm3p; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="HWsvkfDq";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="crFOtm3p"
Date: Fri, 18 Sep 2026 12:56:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1789728994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=tptM9TuYo57odITT2NrV4hMuvxcH//DonB0NGfqPJ4E=;
	b=HWsvkfDqQJRZQFD7PWDivfgSxN6FDs/RLbn0Z4KA7/z5+bOArngFH4agyoqJ5jOJzV+mfF
	SJPZE6uQxQRhZchCse5JQTX/x3qS6ufhvUBdXuP0HVClMc+7jfUfljzgjos/prBkobuKep
	Tx5ayFV6WoDGIeK6/TwYgVUiYQtesZf4LUt9FaDqhGSCewKya9W6XzAJluqB6cOXYzotHC
	T/uXsaP7mf+vcDiz7zoYHPzS5RvKiFarEYJI/V+3/P3twY+nMGLTDhon7IB2CEhE8Z5fq9
	hmcqbQIZwU9rJ6hqpUFiKOYT0W9jWTlXFzT5Nz+SiJenGUpWKuTng/O0Gy7YfA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1789728994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=tptM9TuYo57odITT2NrV4hMuvxcH//DonB0NGfqPJ4E=;
	b=crFOtm3pAbvUYmPyRCHz4mT4xPgjjx/EWpnoTcT9Hz1zhTHEd4RA9xDj3iNtjqmisNR/NK
	tGfOWd/JM5IYP4DA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wil6210: Remove %pK and %p
Message-ID: <20260918105632.pDhc9gIB@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Commit 71338aa7d050c ("net: convert %p usage to %pK") which is from
2011 and changed the %p annotation for pointer to %pK. Back then the
default behaviour for %p was to print the pointer. The %pK modifier was
introduced to able to control the behaviour of specific pointer values
without changing the behaviour of %p for everyone. It was dedicated to
avoid leaking pointers via /proc.

Things changed over time. The default behaviour for %p is now to print a
hash pointer which does not leak the address but allows to correlate if
two pointers are equal. I intend to remove %pK from the library.
The policy on %p is to not introduce new ones. This is somehow in
between since it already exists.

The driver uses %p to print the address of skb, %p for the address of a
transfer ring and %pK for the address of the status ring.
For the skb it is probably enough to print if there is one mapped. The
address of the ring probably not matter given the physical is address is
shown and it is virtually mapped.

Remove the %p and %pK line from wil_print_.*() so it does not end in
debugfs' output (debugfs is not ABI so removing does not break
anything).
Replace the skb pointer with yes/ no.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index e06e45323272c..093ec04e4a052 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -80,7 +80,6 @@ static void wil_print_ring(struct seq_file *s, struct wil6210_priv *wil,
 
 	seq_printf(s, "RING %s = {\n", name);
 	seq_printf(s, "  pa     = %pad\n", &ring->pa);
-	seq_printf(s, "  va     = 0x%p\n", ring->va);
 	seq_printf(s, "  size   = %d\n", ring->size);
 	if (wil->use_enhanced_dma_hw && ring->is_rx)
 		seq_printf(s, "  swtail = %u\n", *ring->edma_rx_swtail.va);
@@ -200,7 +199,6 @@ static void wil_print_sring(struct seq_file *s, struct wil6210_priv *wil,
 	seq_printf(s, "Status Ring %s [ %d ] = {\n",
 		   sring->is_rx ? "RX" : "TX", sring_idx);
 	seq_printf(s, "  pa     = %pad\n", &sring->pa);
-	seq_printf(s, "  va     = 0x%pK\n", sring->va);
 	seq_printf(s, "  size   = %d\n", sring->size);
 	seq_printf(s, "  elem_size   = %zu\n", sring->elem_size);
 	seq_printf(s, "  swhead = %d\n", sring->swhead);
@@ -1140,7 +1138,7 @@ static int txdesc_show(struct seq_file *s, void *data)
 		   u[0], u[1], u[2], u[3]);
 	seq_printf(s, "  DMA = 0x%08x 0x%08x 0x%08x 0x%08x\n",
 		   u[4], u[5], u[6], u[7]);
-	seq_printf(s, "  SKB = 0x%p\n", skb);
+	seq_printf(s, "  SKB = %s\n", skb ? "yes" : "no");
 
 	if (skb) {
 		skb_get(skb);
-- 
2.55.0

