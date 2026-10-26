Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793058839;
	b=omhCYncqU+DThmCy+VvJp+MX8owLGJzGsStoUJ0jdsYAQDzFGgZlot6pPiQqN7XxNpEH
	 GvU5xPWPiAqZ5S+LPwzxcVmhj42/BCGN7bvtq/s72iaAPYw0YIZ9+kK0dEc5GBgta6Yc2
	 e26PfI2bLCsjVMLRWkBdoWj+ymiwb2Q1thvzgxwYGwvB870dG31MTl2J8z89gWIvYApY3
	 uVdB3PLwxkBQwPzuiuGS0X5mspuCocSOgsrvS+pHvsKw2BmYJKlKRRIY9ks+sAKGVU7q0
	 WE7AHGXqhV5hkRbL4alNiyiuTf83L54sKMZMcJAcaPMGYpmgEO9EHjzyxeHvP+HMxwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793058839;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=xV/kApzEyLWCWdRIMRnSJSshFh34vPENMQ5p213FVss=;
	b=k1/WTDqHds9m4Ybd8sPrPViVAIfBt27k7DWG68CnSfVADHJ5xgB7peeOBZGbKRHitpCQ
	 IG7GkEjYkyiZ7lk/34Hai9mxVByUhJcDOgKMqhkZQ9TdfTbsT4sMy1n1hsnmk+AJlkQrN
	 QNARq6U3F1yUk2y76ELKvxsMBBYz4SKtvLHz/NKfaH1R3jrSfIVs64tb/69FSChUHciFu
	 pxLVy62rEaCSxLDxiF9EiErCaJ1NQC65ItaMZ2LJRwtymQxKaGp8O1hfhi4WJ7z6yGOLE
	 iUBU863z/LvdnPvgEtKpGFJ070yOsSH1MFNpDo0WsG3pegsUiSWPACgIhqScH/fkrKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=ShNB6M89;
	arc=none smtp.remote-ip=62.149.156.101
Received: from smtpcmd10101.aruba.it (smtpcmd10101.aruba.it [62.149.156.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2F0606A32D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 23:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB2F0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=ShNB6M89
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id LUVexsCYFW41bLUVgxjBea; Tue, 27 Oct 2026 00:53:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793058829; bh=vnxKdlktPGPEkbhDNu2bx7SncaHDHmPQdqwJyVebjWk=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=ShNB6M89G5ZnWs8AYbcyHmXFKUUGUFpRhfLeoFYCGUExjyYIiGv9zuUIfLz0+TnHH
	 vyyD11aEefcyYkXFMumPOdm4NFy41d3YIWTUpFI0D4Aq2UCIHFcxX/haa2+L5fPZkH
	 ZQjj5zVt4UahcaUJ33Wmxr15l99e+G0lL+j+0rXhd1gF3eQaY05vORJ+juSizWBT/V
	 IBJneQyaDYTk/hnHA2TYqt8xgUYzFxYPBib51E1PpqmV+ho58W6+tFoWQbREnSEY5L
	 ewCChJt13r18LOiPPLzd7Y38CawNi1725Q/csj0SDiDeddt6byas01r3I+Eh2Suhmz
	 4SGYi9mB2xZcg==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Tue, 27 Oct 2026 00:53:46 +0100
Subject: [PATCH wireless-next v2 3/8] bcma: pcie2: request HT on
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
Message-Id: <20261027-bcma-ac-rev1-v2-3-b69b61c31920@mythread.it>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
In-Reply-To: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfJTF5XyttIODpSGvzr+IyNa5pZ6s2Iy93f1vGuHU8PAc+2JXCCQEW+VJahQHRKzZfMSpaIsScInpp4Undro0Spc37izaQYfBvFAPBlQNo89WRv+nuTjG
 kITyRDM9iZU5OIkvS5gbAKWxP+yzx9AmUyCM4B4J/Ww6OaDA1q2rHLMsw9+Uq2JZaeIWm+oOthTEqx8wKINYYwO7d3Z05lIMo06PonQNuFRLWJQ+ANlXqvHd
 K9Ukfqd/gfb1eUrLm7VO3SeEnU6Jm3gSRwK1dwjJ6Wy8FmshmJGvFlTEPLFEA4BT9ROpzH5aI4EOnGaa7P5hE3jv8FFgfdcUNPBn4F3dkUgDbhJuGTFJQ+VV
 d0ZPgj44gQuvpaj6XmirDY1BNwcq8/5Cw5Ts4+wrhM4qYZuaHN4=

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

