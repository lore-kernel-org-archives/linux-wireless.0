Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793438191;
	b=uyybASV9hZ5B/QeT0bFTK806d01zlTGK5Ahyz1tSxDSgy6fJrrUZ9GpKjYd/c8qZI2dC
	 WU0UXE6q56gBuBeBvR0rL7Odx4ezjgxkxoek0owW4V3ygdXIum5qn6c+CjmxJRPlrcB5B
	 PPcgCRJF4t3Np8PftQQGBwEQDYVAVZrtNbOv2gNWHCGuXEflPZIz5XMgDQwbFRh7Zb8jL
	 JBKURe2ydePlfteOZ8z8ZoxnI/AKXEtMCVMf5R5822JXq0XFDNyTEDjibWwz9IiJc4I9u
	 dNt9ZNqeRPvlhgyHMy34r+AtFDCOpgRwVpXMkZwr1RQp6kNZjGnAyi+48H1Cz5kKKcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793438191;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=2AhR0cicJfzpklKfCA03JPeN0llr819XE8fFB0cfqOM=;
	b=GtFsn38Pof//QBYLA+gV3VMIH/sLrC2zcQSvCHXZSk8wG1fn5SJnHnGAV1JliD3DY8su
	 YeN38oLCNh2i4YKk1VZVaH6LvSh1ZyXXhjrfrdOHqVKqvlZV/k6P5lQBTJFdYCzv0r6CQ
	 smZ9Kt/3GCoalG3p08Rx7HZ9OCNJ/l30QudRj+dTqg+tgh0GuCdWJcqYyoU3lygCoPJcR
	 VjC+8+aVsHEPrcNACff3i03JL8JN3Hl7BEFm9LsXUL0Yf0XX0ZJMiwwglWXD86GUyaLUG
	 DBXS4NVlHPW0LmMEFTaRY8hvhs26XjktZ5mZoILCRg0mBVtXnvZ9072TO0WXUjQO1bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b="Yi/gzTL6";
	arc=none smtp.remote-ip=62.149.156.86
Received: from smtpcmd0986.aruba.it (smtpcmd0986.aruba.it [62.149.156.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBD2606A325
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:16:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BBD2606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=Yi/gzTL6
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id N5BMx1hYL6q8sN5BRxVoVO; Sat, 31 Oct 2026 10:15:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793438130; bh=6bx59o3Z5Zhr3o5yP5KkMPMyyTXDqNwsakUJWRv9Yz4=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=Yi/gzTL61M60I+hjJn3fMJLn6k8UtcrrkwOr15fKf+2cTogglI2isbwxXwiuZgxV9
	 GvUlR8w4iZkqcfDr6Z//vgTXTePsDa9Qn9qK5MRLoYQKHnTgA/V2uflihto1/JVI1n
	 diZGsx0OhIBfhPehwaeDkyj5kGJQ2GB2C+sOCd1kQQDEkGaesI9Cbnd0SqjRxr2zTh
	 M04ZjG82BmKQsxuyyhlt+UuYzKTHcYYSrD1OPQZFfylhthsAHhNaRrVsY5pzqgxHj0
	 DNjJ+IbMCi4F/kMZwgrMX937vBQUG5aloDylziG9wRO3A/Hc8z/p+sdTsmiEp58ZSS
	 GmkCc4Nc4HVlg==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Sat, 31 Oct 2026 10:15:31 +0100
Subject: [PATCH wireless-next v3 09/10] bcma: add the single-band
 BCM4352/BCM4360 PCI IDs
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
Message-Id: <20261031-bcma-ac-rev1-v3-9-1fbe38e8179b@mythread.it>
References: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
In-Reply-To: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>, 
 b43-dev@lists.infradead.org
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfPBZNLEo71l/QFE82efaGzWt4iqwpfNEwXROuM2bg59CONH1IJq3AxNNmSxPglw/dZLw03jjAo6BQVJ67qxc0knWYrpo2bXZF0BwhGj3xuE6bWolradr
 0XyUXfvGxcNf9qgaIO8aj8Xg940oIeY3xqpjwGQlsUcvBdLIdHFyHxcjs1TAMVxki4ZcivUnFVOeAbf8VcUVzOaJBDQs+hAaDGgo/13vrPztWASl83/LgZlB
 eFI5HyLFmvlBuApDenByz9pDtmJYuljaqII2+BC0Z8BabjD4+9qQOBLjHZKg/gStorIyM/x8YP+EyAHfunDwz/qEDdOH/obgMxinALeFv5iG92zUow1k/vMG
 IrfAojJ9yZLxDH88G7pWbt52BiTLMm04bpTud3K6AZL9Nqo3U8g61yIQl2ip6dkHMywCVNkG/JoUh6PPbbag01HeyyXcRw==

Bind bcma-pci-bridge to the 2.4 GHz and 5 GHz variants of the BCM4360
(0x43a1, 0x43a2) and BCM4352 (0x43b2, 0x43b3), next to the dual-band
0x43a0 and 0x43b1, and name the chip and band of each.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/host_pci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 3dc298506..27f6cc10a 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -294,10 +294,14 @@ static const struct pci_device_id bcma_pci_bridge_tbl[] = {
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365, PCI_VENDOR_ID_DELL, 0x0018) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365, PCI_VENDOR_ID_FOXCONN, 0xe092) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365, PCI_VENDOR_ID_HP, 0x804a) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a0) },	/* BCM4360 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a1) },	/* BCM4360, 2.4 GHz */
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a2) },	/* BCM4360, 5 GHz */
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a9) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43aa) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43b1) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43b1) },	/* BCM4352 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43b2) },	/* BCM4352, 2.4 GHz */
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43b3) },	/* BCM4352, 5 GHz */
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43227) },	/* 0xa8db, BCM43217 (sic!) */
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43228) },	/* 0xa8dc */

-- 
2.34.1

