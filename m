Received: from smtpdh16-2.aruba.it (smtpdh16-2.aruba.it [62.149.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D844BE42D
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 20:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010664; cv=none; b=Rv+2Gbu+y/fCC7zKuE00NXX4zP0kRyKZ9wQbVgbCODNlhdxQEEvh4v/dRzDe8qTU0hQQcwv1nQGEP4qjv/8Q2NrYfx4YcnsO99Wdu5TMuaQ/4JGcr71hAXEvUEMhZU6sWcUdBZlW5y/AJYeUgfJwV106xK9ieo1ISK4Gs6yED38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010664; c=relaxed/simple;
	bh=vnxKdlktPGPEkbhDNu2bx7SncaHDHmPQdqwJyVebjWk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ctkc3jWy4O6SEPtSTow22FIXaeRHlj/XYkQX82ApjUUA6muXeDEXuIYdyOHytJ66GPBL6SbRAowUJacfJAOpR/57Pa5ne9y5GW7+7DhvgPclUBtaPmYFpve+D2t9pUlrBvbA956srSfROq/ZdJ0pqi86KOeCVBUg21s9gsMtqE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=giQiLLIz; arc=none smtp.client-ip=62.149.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="giQiLLIz"
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id H5mdx2rTsgYw4H5mkxSpCp; Wed, 14 Oct 2026 22:41:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1792010474; bh=vnxKdlktPGPEkbhDNu2bx7SncaHDHmPQdqwJyVebjWk=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=giQiLLIzASdGT9cnozy4Wi2Vi54Pf6sOGjlnjufl7j2tDyq74l44atAzamfahOBKz
	 19Xpa04GcFlzSSADKTrH3oh4ZE+H7xwrb9fNtswwtMP8LwvtPKMJ5ruZGlgms2I9RS
	 jVHbgDv7ejSToguMutAkRpR3wXf86HR6CDk9C607e+Qeao0VBXApJLSlq0Xd2bKSx8
	 aPR/mRYm9gm1VYYqy3hPn7u/bYump37aOyTgNifRoqpMr58z3YC8ZAyeByedbbLdC2
	 FvkOK1cXagLCRUmwlf4r+lm46zjBpStr0BedOKcvbKynWHoHKvMjqfmbnys+DbaxKl
	 gsSj5wxKDETyQ==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 14 Oct 2026 22:41:04 +0200
Subject: [PATCH 3/8] bcma: pcie2: request HT on BCM4352/BCM4360
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-bcma-ac-rev1-v1-3-b608e99d3f56@mythread.it>
References: <20261014-bcma-ac-rev1-v1-0-b608e99d3f56@mythread.it>
In-Reply-To: <20261014-bcma-ac-rev1-v1-0-b608e99d3f56@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfN6bvGWMrM3C7O32slcQTgHJbTXhr2UxDy/TzXIa2DcooUo5kdVgvXe81fVvf6wzmSgSnOaKHiSGsKl2IllWFyWYWr/hijrNkzps/zICNVKcY3nYBTr/
 qohWDO37teboALBM+PLNp4cyhwEYJCVBkZX+nlnxek2EYYk/UIzYQdW1aVIuQJshedE/JUNXq1wuPENeRXXERG26Gv9OEmrDXjpAmN8vkoGnRu3RauHZg1au
 mKegveVIEqU6Z9ZhYUCDrKIlFKqPkPus3gTD2KCcHzV44gbRmNXv/6A6JezWhN1EeQmgRQQA1xeFymDzEBLiExMyliHnRB89fiyCxQW1qSlJK6s1s6syT9/C
 kyZf+2ow2FchGDligTtg4DZwV/2Keg==

Set HAVEHTREQ in the PCIe2 core's clock control on chip rev 3, as
Broadcom's driver does.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/driver_pcie2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bcma/driver_pcie2.c b/drivers/bcma/driver_pcie2.c
index cf889fc62..fd8fab982 100644
--- a/drivers/bcma/driver_pcie2.c
+++ b/drivers/bcma/driver_pcie2.c
@@ -170,6 +170,9 @@ void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2)
 	case BCMA_CHIP_ID_BCM4360:
 	case BCMA_CHIP_ID_BCM4352:
 		pcie2->reqsize = 1024;
+		if (ci->rev == 3)
+			pcie2_set32(pcie2, BCMA_CLKCTLST,
+				    BCMA_CLKCTLST_HAVEHTREQ);
 		break;
 	default:
 		pcie2->reqsize = 128;

-- 
2.34.1

