Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793058838;
	b=cnRxHSbEi3p8SUYFe3cN0Lg3lZ8RmdwLgclcXUFUl5AdaJf5mjhdolGQ2X56l929sRTI
	 2xZZiNclrwOOy0KBz1cmPxtfWHjkQakYbLNNIPbrPxJdEtPKw15l7UBHQXByf+R01nkqD
	 NqriajqRLV7dlY7RPxFW5IfmCS4EpXVmbYYGEYzHCovDQ1D+S3e/V4g8Bjij2146EMwwE
	 6W9H+y6nL2bF87YDQmMW2Zqk7OX4/UbDXSivlmg2acewKwlw9mqQaj+nt0boWuQMccGLj
	 SvheocGpt2tUjLpY9viqQO/7llThraL6bTuGkwQALxFMn+UYEPC4ZSzCCefde3tX0/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793058838;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=4XltKv9j08futEKwreOKMozha5nBa7yYaFGpBttg/Vk=;
	b=RwCtz178GXYJBY25khWQ7ZotFOh6ibz+0GVEwX60VPkZEFhkyDNymVHAAnXMGP/tUxId
	 01brOUvxXG+wKkInSO3OZw6zTznV9eNCifXGNPd4Z3D6ESBL2iVGIzf8Na6QGZHcqTbi2
	 8WNffy21S8XHRgsD62DXFnIG4FTjeV0UUZUHVuDNp+o23HDTNy1rhoX9lWdCCWUfsWIJ5
	 DbCMlTcEUstEalqJXOaxBE5uf9QXYZU7K7hLyGHz0nxGqUtnofhiHYJscrmraSRjP2vrc
	 WKlaZd2V8F+yvudfUagFj774+TDut6KsBAHS7tsxLKGlM4BovH9w3NbdvdhYqPfPivg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=MIPyDcE8;
	arc=none smtp.remote-ip=62.149.156.101
Received: from smtpcmd10101.aruba.it (smtpcmd10101.aruba.it [62.149.156.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BC3606A31B
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 23:53:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28BC3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=MIPyDcE8
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id LUVexsCYFW41bLUVgxjBdu; Tue, 27 Oct 2026 00:53:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793058828; bh=vKCGoYZkyy2tX3DnxdaTcewcIzz4/PetZAI2mHkxFSg=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=MIPyDcE8rAf3M7DB81P3TrVyQXXjJErzL3cxcyR8d7Yx4khx+aroxfc/yY4TlrOoQ
	 GJ1OwAkEjeSyqBxedsjlJnmKt6bzftJTU7jvAH+V+zoja+REnrn8Oho5SHb3ATbfu+
	 vLYBVk4GNE5N7nPCO1+SENl+IXf78odYwGIbVk9Dc35FnRyFdU1fnrc5/4ih9DqHna
	 UWZBLVWs0xBpjLNQ9gtgD2M6X7xnS5DJUJ6YT9pcdrr9g0tIzU3/9nwjBRYaG5JOkv
	 sSW1WKg+YIiijOn6c3oBgQe47UN9UZqqYhSM639cfPQsLaIjy117y9NQWnWBLMS9R5
	 cOcvfpn1kXH8w==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Tue, 27 Oct 2026 00:53:44 +0100
Subject: [PATCH wireless-next v2 1/8] bcma: core: clear only FORCEHT for
 BCMA_CLKMODE_DYNAMIC
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
Message-Id: <20261027-bcma-ac-rev1-v2-1-b69b61c31920@mythread.it>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
In-Reply-To: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfOP1m5cBT0mHWlN8umXGisWkEp9/jgvHoBa7uIoBF1B+yIlT9XDT3/9JKUGr6e3p78sFPjhFb9GXxU/vDEOfN0utpqE6e70Lc67e6Dqp41D61uSKYxMs
 EpQn5B532ks7fjLqa6EYlb8sLi8IqGH0QYntpb7dyRq2S+zGmXppoe6e3+X+G8maAiIPrHBaXKhtHkspY90+lHg+SjcPYqZy7k3QI9JZ4MGg0MgV+Le7JBm8
 CIvo3Xe+Le3oqi9DSL7CPINhRx1MqkcWj7UDIcujgNSpLFRRcVMQl/WYV7GSh4HjuTgiac/6gG8REsrmiZ/WVI0SqUsSUfvlzcxQejDKye4m2ym+jy7uD90k
 3MmkKopY7n1KVxz9wmyunHSTEkQEHgTtxq1IOrTABKqY4GjpJW4=

Clear FORCEHT with bcma_mask32() and leave the other CLKCTLST bits as
they are.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
index 37a5ffe67..f4246689e 100644
--- a/drivers/bcma/core.c
+++ b/drivers/bcma/core.c
@@ -100,7 +100,7 @@ void bcma_core_set_clockmode(struct bcma_device *core,
 			bcma_err(core->bus, "HT force timeout\n");
 		break;
 	case BCMA_CLKMODE_DYNAMIC:
-		bcma_set32(core, BCMA_CLKCTLST, ~BCMA_CLKCTLST_FORCEHT);
+		bcma_mask32(core, BCMA_CLKCTLST, ~BCMA_CLKCTLST_FORCEHT);
 		break;
 	}
 }

-- 
2.34.1

