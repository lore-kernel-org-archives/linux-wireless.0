Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793438142;
	b=m8Qh7U4AM9uXwmDNvra/SYq84R4FSnpid+VDF6CGtBLwuR9MLDqw4xeCy5mzaa3ceaFd
	 Lpvks/I+oEgK7nVqkd5lkCaBx0p0uLjsb0EjmUzqK2rj7IVOEXR8vy0PtuEmVBU/b1cn/
	 4jqrX1+FSSKnBlDNmBMsgbrFPivK2mc4/We7DaKZqwIRui9n44ofQLqrbMTyJL3zIsXUz
	 kiMg8yMgT3fK3WiQqLnO8JxbEATsjTsG4dB4/M9a2HIKxb916Iv1nuOVg/DVwnBmwcajK
	 2Xn7bmqg9hNht/cHOJ/lsd2EBxKUt7Uf5xirQsmqieIoajLhjWQdCqBpUs9gwIllkFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793438142;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=WvG0kClh0TtoSxBVHbwJqxA9jzJi1q8SGW5f3Mvk2Ls=;
	b=z+IsI7C1Vh4NZ7ZO/GcByfltE2WsPLkJYEuML2NM862mVrjg8vHGMaoranuc10nGOFKn
	 m2eno54ABC4LsamrMpmOepUtC3Tr5Nw9yPv4FTz3aeYy3+vI8/dDXrDM16MZ9avZahayR
	 rZp90vO1jiGePz79aeqMLSt8o3iLy6sTIxDDtjA76mlNdt5AQ7jqbi6RMh6Nr6Rd8aMaz
	 s4u57WLFsR6gvU7vU/Bz2umULLLIUr2oJ/4zBsbg2Au1YFS9VSIAxU+3aJ3tiLJ+eXErt
	 sxkon1kbQIYMtnG0JLMH+ew0vOmuQmfrW9pAmRGx7r04TBb3csqC00vTxwHzvX42OSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=kLYFVlG+;
	arc=none smtp.remote-ip=62.149.156.86
Received: from smtpcmd0986.aruba.it (smtpcmd0986.aruba.it [62.149.156.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2D9606A321
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F2D9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=kLYFVlG+
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id N5BMx1hYL6q8sN5BQxVoTY; Sat, 31 Oct 2026 10:15:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793438128; bh=oLRFKUwHbKhCHiC98MhkOwsf0J/5kYlXvF/Sbi45IsU=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=kLYFVlG+VuwFQuO/+rVyYamfoQH+7fPZs3AI7Bg3WlQxVSFGSlvj+5Thvd07S/vlJ
	 U+Eai+VTOGA02m+KmFTGaK0npTANJ9OqaHRPgtS2oAuYjZ+uMlTW0W6IjSNsDlHQND
	 iXwsn9D0bevkfsLBuWDHi7j3GRCFNBoiyU6RCcQPxcGcjCc4b6JFmnPmXYrIKvSbS0
	 kspBPp26qA7QwnV74mjKiTxOjY8EZQ7UQU94Zej5p106PswubQntxXqLTPHA6+Ov9Y
	 WJAF9yrtNAKFGINKPhHBt26FWdK2g1Qdp3ZBMqvKTs6hcIn3C/6GBrC+GxAWSMZIaG
	 CMHtK3f6SmASg==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Sat, 31 Oct 2026 10:15:25 +0100
Subject: [PATCH wireless-next v3 03/10] bcma: pcie2: request HT on
 BCM4352/BCM4360
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
Message-Id: <20261031-bcma-ac-rev1-v3-3-1fbe38e8179b@mythread.it>
References: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
In-Reply-To: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>, 
 b43-dev@lists.infradead.org
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfLXXc5T4eu0nzpLMSWy+X5gfVikXSiNlEnMUR1sGQcqxa6SVj1y5a5wd0dIRkGGZoqwr4hPUxi5I4aohl7w1Fu6FJI/2ZDNSe1Yw8QD+5xrg5es9zSJq
 bG+l3GjKmx7dKTLLx7M7sZ5GB8o518feW0DT5e1Gbqh73uDSat3ZS31rlwytDhnVIuz/dxTbmbY1u4PXnwAWDn/INFjf9kjwXgPedXc4p/k7acy9mAhR033H
 SDXhXP/V5eYCEg50yMUi52TFaydiMm7Xx46MXbDqHcmG2OQ9Eup0t0G5MMnN1ooBkh2IkNMS9DZg/FMEN6nTP7nJD/fp78DT+kp96s0AXXHj6ZtkxVcJi4Il
 NnoIGNBrsJS+ImjydHvTtXFfYTb6w7/MKLrrg75LPB+xXp4AV3u+XHLYiJZtY9f5ULRWNX0/Pm6ox4B4yPuRQibKbgtm6A==

Set HAVEHTREQ in the PCIe2 core's clock control on chip revs before 4,
as Broadcom's driver does.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/driver_pcie2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bcma/driver_pcie2.c b/drivers/bcma/driver_pcie2.c
index cf889fc62..54daeaa43 100644
--- a/drivers/bcma/driver_pcie2.c
+++ b/drivers/bcma/driver_pcie2.c
@@ -170,6 +170,9 @@ void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2)
 	case BCMA_CHIP_ID_BCM4360:
 	case BCMA_CHIP_ID_BCM4352:
 		pcie2->reqsize = 1024;
+		if (ci->rev < 4)
+			pcie2_set32(pcie2, BCMA_CLKCTLST,
+				    BCMA_CLKCTLST_HAVEHTREQ);
 		break;
 	default:
 		pcie2->reqsize = 128;

-- 
2.34.1

