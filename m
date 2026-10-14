Received: from smtpdh16-2.aruba.it (smtpdh16-2.aruba.it [62.149.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDB049EC61
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 20:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010659; cv=none; b=hplB7LjEoJcMVN5jupHDtX52qsIg1NAIFXPBkm4i2VVQL5CdmrMniojlbLk0yKfUntFiI1fLX+LRP/v1/X8dmTETueSIDVHiuhy7Ax/GYkFpXN7BD2kMBNMIfwmdDAUutcXIreZmFiUQsSc4AvDUz5CpuxX2NS3YcyCy8nv1Vrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010659; c=relaxed/simple;
	bh=5iUEvhleMNRhgFjox1R6x5dcIaCScRIRYb5QDa3E5AM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cONiOQiD6ZZeFGhS7zNBGavRsCzMV4cgjm3FqteyxgRvHQdiqhKJd4MIndFXQv+X6mZBYyhwKpeUtp+NpDyAfKRAxYbvxoHG+LzOB1FvmG6jNxTWFak5Ofj+a9TRuo+cbFsUS5xiXpNFGc+iBmLajfeSDtXISDmYmy2GVMnvR00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=RrN6OAtQ; arc=none smtp.client-ip=62.149.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="RrN6OAtQ"
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id H5mdx2rTsgYw4H5mkxSpDv; Wed, 14 Oct 2026 22:41:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1792010475; bh=5iUEvhleMNRhgFjox1R6x5dcIaCScRIRYb5QDa3E5AM=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=RrN6OAtQWLhDbTrOtOfAy8x2lm5L4MPP0gpg1zJzBpDF1+oImFGoL5kJin2nAnDOa
	 Gb0r/wozsAix0gtNK5xwgu3wZRSijmAs7vAfZoG3Rd+2KmYy2vi4fnR3A5vtODwWos
	 5IlPi7HvZfHx+NZcqT1VJV1c5WAorDkUMNbxjCtCsQoudj9CNSk6/gu6WMqm+scVKS
	 PVxAaMN5BPaQO4fb/vSJOSe1JEWVKiK5ITfhx8w04ojS7rVJ1dlB1KOh4oXLdK6qeo
	 JHCRF+VmpQOor5j5OTeXmgLXCQsZVu8nbM9jxaZOJQipeeUV7zdsRJcEXUTLOGYq2T
	 /YgFI8/Gnvf5A==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 14 Oct 2026 22:41:09 +0200
Subject: [PATCH 8/8] bcma: add the BCM4352 PCI ID
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-bcma-ac-rev1-v1-8-b608e99d3f56@mythread.it>
References: <20261014-bcma-ac-rev1-v1-0-b608e99d3f56@mythread.it>
In-Reply-To: <20261014-bcma-ac-rev1-v1-0-b608e99d3f56@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfOcpYM9Gj/xVt69K5AFL5hB04TEoDMiDhPirzThf4TIQdQtQtMaQbIaZ2X7aS15X7w+yih8YrXvxfRxV3GksTRU5LpcijTbGPG60FSa02FCfKQogx0KR
 J+M5E0qKVeMsHaACVdroYXK6LcmK6Hzozbcl2UdPFNyMdnsKep5XiAWciYITBP2uCzEJjTknEqJwkIIo4PxH40NShuX1mCyFoAPdirBGralvf/V5IL4uOa/+
 xkxv/GxEkSZjHcuIDvty0C6HcH9QVytvTdUI7Qzevg1zSi5K6ag6x2T/euBpOdxPUoIzk1pVbf/SxpG+1Cq/j5QA/al5nfUh0nlqNjdCtRWCxX+SgON8y/dl
 5eFlVGym6OMYUYhluNgigNAavicFHg==

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

