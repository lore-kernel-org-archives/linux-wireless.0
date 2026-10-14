Received: from smtpdh16-2.aruba.it (smtpdh16-2.aruba.it [62.149.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2D24A92FC
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 20:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010662; cv=none; b=Nmw9kkcTxS2GeQxdDcIPzcmktp7xCZp7aP5onaA+hAoA7FxvmjDWMZn/90YU9yWDApca5qDL4d4nqA10pfIA7Vuz82ADQpBtgR0Kgiw7xnyBX+xAAAJ86n2YSD1g45LOY5x4SGkIXsZuHNw72XdGr2BtbF7DKXnrLZnZMr3xN8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010662; c=relaxed/simple;
	bh=vKCGoYZkyy2tX3DnxdaTcewcIzz4/PetZAI2mHkxFSg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BzTaqkG79fzJO1Ii7m7Uy1GzXgOVojAtyAiIH5jJCpAHl0sTsv0rdAXrWPdXkf3DMNPKBxisR75nK1fQ65+m4lgf5EiCLO2LkQEcKihk63xXeh7hau1OAWp8MkjOKLhFwBkGkv1gFjhzyL8Z43roPQbiCkOGdGfkKKd/04c4tyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=Aw+tFIeb; arc=none smtp.client-ip=62.149.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="Aw+tFIeb"
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id H5mdx2rTsgYw4H5mjxSpCL; Wed, 14 Oct 2026 22:41:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1792010473; bh=vKCGoYZkyy2tX3DnxdaTcewcIzz4/PetZAI2mHkxFSg=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=Aw+tFIebYZJ6zdTapjeOS4/QGHTOuBXGYCVW/M61QiWQujIsPFfOLoPoXTMnxtaOT
	 1gLHQGWVI9B35sODBCczEuoHVe73MtwRvtp3fNyIx6/5E3UQbc2ZjAek0bZIQpcbKK
	 hioHYRTA0aDeMirR9GyxFu9eV2c5inw3bdAlGAnbvfByNkvZkN+Gazu+DViEL0Sch0
	 kZ6E7pbOFidxkd41O5W7t7FDGYEN6JbtPz08jRpq7m0+odW0Wo1ZccNTQyFjjRLbQT
	 b3I+NE0tt4MndWZZnE0/x1sWfnkbgCU4x+c3OAiqVCOyYKKRrEU7hE1qS2mI7r3uEJ
	 KEpIDIRUs9QWg==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 14 Oct 2026 22:41:02 +0200
Subject: [PATCH 1/8] bcma: core: clear only FORCEHT for
 BCMA_CLKMODE_DYNAMIC
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-bcma-ac-rev1-v1-1-b608e99d3f56@mythread.it>
References: <20261014-bcma-ac-rev1-v1-0-b608e99d3f56@mythread.it>
In-Reply-To: <20261014-bcma-ac-rev1-v1-0-b608e99d3f56@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfJN6aUMWVTjyiHFlqSbsKeZSW6xP+jdx1SjIjpoGY4uWNTV0gKvUVw3FYL84pLgtYmg2ix5Zm0gW9AVNUJLIbPfPl1QskPJ3vyGbj4Ybljjw2cn/sy1r
 kAwGpZvGggFAILdBvKhGK3Rjnvlt4AsnfqlNxePDQJTlIBQrr9UuMJbAou4bmLe23JIQ9HedYNo5tCZj+wFlsKG+bbDvn97Itywim6szkQOzgS9m2pul/tyy
 j3fG3Zs2Yzqv+ubZI5ejLxhKLMw3yIZfJGQkTLWsN+zyt67CzpiKJr0f033vTS5RNZuB48UQ2XMOnb+WcnKQq+yU7WrGwcPA7t+nXwAvVkv7WIyUP1YDj3Ji
 d7G0fMYXqhutk5HN9A41YgVlgc+Asw==

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

