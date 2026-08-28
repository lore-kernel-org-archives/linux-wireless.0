Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3103955DD;
	Fri, 28 Aug 2026 09:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787908594; cv=none; b=hJ9NIKmxQ7cKAEgwe1bB9SdxS3jjpJcc7CSJNpH9TGopCyz6FIvu6HImjLINR3rQyL6w+3OaQmwtaghmCPOoWC205TD06QcCFuMaj0GoJzsXKwGjcGAnjfD0Vk5MCHlCwLTw6QYrLAYLZodQeYv+9DALN2Kq773dx6GVTFdSEXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787908594; c=relaxed/simple;
	bh=SQq5GP/TLNYb3RIwava0r8rQrBs8n0twbXSL0rfNFFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T6T5LA+vbLRHv5htm91lLbdTpN/wLhcZHNdmZR3wkXnLygUdtH2M7gtFeQTy5gTCdoyuh/h5XO4tr9bm4NttOUXeckS+1pBdcUPWQ3jOUGZxWRfjVnFLrxAlFRQk5Uj9C8eT7aQIw075fCO0bwfbLQ3fgE7v/xNenUTbnoJ2lYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowACnrjztUZFqmz91Bg--.15582S2;
	Fri, 28 Aug 2026 17:16:29 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: linux-wireless@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: libertas: Propagate SDIO power-on errors from resume
Date: Fri, 28 Aug 2026 17:16:27 +0800
Message-ID: <20260828091627.7198-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACnrjztUZFqmz91Bg--.15582S2
X-Coremail-Antispam: 1UD129KBjvJXoW7trWxAr13CryUCw4kZrWkJFb_yoW8Jw48p3
	95uFWjkr4jya1fCan7AanYvry8Ga1Dt3y3GF4j93s3uryDZwna9rnYgF15Xr9YvrWUCas0
	qF4jqw18XrnagrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb3rc3UUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

if_sdio_power_on() can fail while enabling the SDIO function or
programming firmware and already unwinds the SDIO function on those
paths.  Resume ignores the result and can wait for firmware readiness
and call lbs_resume() after power-on failed.

Return the power-on error before waiting for firmware or resuming the
core.

The issue was identified via static analysis and manually reviewed.

Fixes: 7444a8092906 ("libertas: fix suspend and resume for SDIO connected cards")

Assisted-by: LLM
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/marvell/libertas/if_sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_sdio.c b/drivers/net/wireless/marvell/libertas/if_sdio.c
index dd6756c1242e..5406c8fcdba0 100644
--- a/drivers/net/wireless/marvell/libertas/if_sdio.c
+++ b/drivers/net/wireless/marvell/libertas/if_sdio.c
@@ -1359,7 +1359,9 @@ static int if_sdio_resume(struct device *dev)
 	dev_info(dev, "%s: resume: we're back\n", sdio_func_id(func));
 
 	if (card->priv->power_up_on_resume) {
-		if_sdio_power_on(card);
+		ret = if_sdio_power_on(card);
+		if (ret)
+			return ret;
 		wait_event(card->pwron_waitq, card->priv->fw_ready);
 	}
 
-- 
2.43.0

