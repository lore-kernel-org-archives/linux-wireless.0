Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793058891;
	b=MtmVDHg7NArCYX54RVqqhC/XrImj/6Z590DbGkPi7ngXJWLs1JwfWX42O9zOJ4nvbRSB
	 NVC79btLWEuPC0G9SGMgWPgD8LZaBNfsquZgSlH6D85u6W9gnKtSOw6NNLLyP6MzgHX0k
	 7Xkyb8flfTqnGrg6nlk92HBEjHMoOtIZ4YGPCOC8kKXmTuAc/i41NeMz2oM9bqM7fcdGc
	 JyxVYsamdte2HgLsPFRU8pV/Lvql9CcgVoPkS3/bEySN2EKV3MY0HhDg4/nVWXyty3SiT
	 cQA2qeU/0OYamF3WPGkx2L2VpjMWQzpniJtTKYw2C7GfuzDHbb/Sz/J4sK2OeuzyqgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793058891;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=1rbZZM92EewBFIKqO25Z+Fr2+4X/GzpJedO6dI13tck=;
	b=Yw7pq+KjoB0pSvRS4NN/TDmaAjlKngL6M3M9LAxW7OUfqXr6wEmdabRuxtc4iqEUAfos
	 V83cuw5eK+jJ0QQFUgiS4NHmsMJXbts3YpbffwU9s5GIumhCdMNjDm7qOC1+nXeLhwklz
	 nIfPvDiRqiRg4DGUQP17DLLBD6jQKnIAV4X6GHr387KsRHlDDlfFeAgM0tU2hNwpIllNb
	 wE2NZO/us8iYWkKhkC0+Z4XSnWGu2YebAhuqLnWxuEcJJgz/ST7V/WiwGZfR91bfCj7Oh
	 UyQhyIEw5ctXdp3SxqW6ZlE9D+kfVTv78gwwA4JbzDXKI/AyIG40CemaUo9Ap5K957Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=Syled8T6;
	arc=none smtp.remote-ip=62.149.156.101
Received: from smtpcmd10101.aruba.it (smtpcmd10101.aruba.it [62.149.156.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62756606A320
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 23:54:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62756606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=Syled8T6
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id LUVexsCYFW41bLUVixjBgD; Tue, 27 Oct 2026 00:53:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793058830; bh=5iUEvhleMNRhgFjox1R6x5dcIaCScRIRYb5QDa3E5AM=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=Syled8T6PSideLz6f71TVMd3nZ0LvPMRaK2S4MBxXG6vXhQ7QP/IcAm4aD+4zRYs0
	 mwumCKiAegekS5T1omLmTA7Fxl7BrkQY4Bqmxi2SR6VqdPkBwNVw1EXskcHEnyRqfz
	 pZIBtlEdq/BsJzB53Qa5+oFqmr30A52i1fm31l8bJy0l2DrQt51lYcB5lp7KHVfxjb
	 YjmeC/Su7c1UG2Utj+kHrkc+8IlUq+7cQ2cXVgtzeU9n1GSWcsm3aX1Hxm9a72oTkp
	 Ia0F1qQPfR5grt8bd/f1kCK3TfMGeWygS1+MFkZWTfSE9ou+cV5mM6xujPfTaVHGnf
	 iKpTf1radmpOg==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Tue, 27 Oct 2026 00:53:51 +0100
Subject: [PATCH wireless-next v2 8/8] bcma: add the BCM4352 PCI ID
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-bcma-ac-rev1-v2-8-b69b61c31920@mythread.it>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
In-Reply-To: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfGKOy2UZ5BM+jnYiTwLEWzZm9Bqn9y/XHLMt91Xe039y1mbDS6zN0sl+Ucfo/cVe5tkuNjlp6Rw5hN+pifebbZjZn2Ot8f5D3LabQYjPCd/QfoiIkk2z
 JRJRI98Ftv5kvfHOqcJ1mtIfbRgImpA+peqL7328E84g79omkE9gdyAGEk2JXHETX2SDT04LEZH/kbK507b5ZcEL7VoJ38S47JO1LyQfbEB7UNOtNEZiRvGv
 vvXnSdrxqhHJY0KqsWG1LTLCbhu75G2uAsRslHmkmNgWC99Gu/V4nYcdiRUV2aLrl537YzJvKQybbZt8yxAgZ4dcX2fuvGRKgnGYwPFNpFScuw+o8SNY9+l6
 gQ11Azqo6whfTqXDkAFnfhVyHKz3Tn6hteUXv2jso0pvDihPObU=

Bind bcma-pci-bridge to the BCM4352, 0x43b3.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/host_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 3dc298506..f6cf722a3 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -298,6 +298,7 @@ static const struct pci_device_id bcma_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a9) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43aa) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43b1) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43b3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43227) },	/* 0xa8db, BCM43217 (sic!) */
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43228) },	/* 0xa8dc */

-- 
2.34.1

