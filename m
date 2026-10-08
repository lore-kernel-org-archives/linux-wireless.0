Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFED37B007;
	Thu,  8 Oct 2026 18:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484489; cv=none; b=q6qeEBrR4iQpyhrmf/R15FDOdOjR4AwFLs2yDbl/TdcVGGRWXLlvz3J7zAA73CUotrQFPjVNC4swNgQCtjmckxY4d6+U9oVqrUwbM0umtFBuogZpfzKixgnF0n6MJQcM/IggiZdPnIF4bbHmQtCjpxHOA7uFgIoYC42yhVpoT/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484489; c=relaxed/simple;
	bh=w331LYYohqHoSENv8sGiApnC1kUXtK5b8F68wPpy0mM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mpGID4u+FxvcUakQbNcwSCBGO6HP6aC1dll3TB3wYM6owDiBLWXJ6OaS6jK+7IYZgJW5aHxgDBtan/jnMSDyCFy4bj8m5iNbR/VAR/Qjn5UR9lvYGnPBZQCkLYl0k9lpf5V3iVPdyS6mSTw9EH2rHo766PAImWIkAzkoFjHKBQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fc87d0ffb700.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAC3vjxD4sdqrI4QCg--.14675S2;
	Fri, 09 Oct 2026 02:34:44 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: =?UTF-8?q?Rafa=C3=85=C2=82=20Mi=C3=85=C2=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcma: fix device node refcount leak in bcma_of_get_irq()
Date: Fri,  9 Oct 2026 02:34:46 +0800
Message-Id: <20261008183446.2777503-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAC3vjxD4sdqrI4QCg--.14675S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrWxCr4xAF1UGr4DGF43trb_yoW8Xr4Up3
	yjgFy5A3ykGF4Uua48C3Wvva4Yk3Z3t395CFWIkasa9rZxJFy7CFy5GFyaqr4DZryrZa1j
	qr4aqa18WF1qkFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUklb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
	C2z280aVCY1x0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JV
	WxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_
	Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU5pBT7UUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgEOA2rHo1OWWwABsb

bcma_of_get_irq() parses the interrupt specifier with
bcma_of_irq_parse(), which on success returns with the refcount of
out_irq.np increased by one, owned by the caller. The function then
passes out_irq to irq_create_of_mapping(), which does not consume that
reference, and returns without ever calling of_node_put(), leaking one
reference to the interrupt parent node on every successful call.

Release the out_irq.np reference after irq_create_of_mapping(), matching
irq_of_parse_and_map().

Fixes: 71783576b534 ("bcma: get IRQ numbers from dt")
Assisted-by: DeepSeek-V4.1-Flash
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/bcma/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 72f045e6ed51..0a7f6ef6434b 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -182,6 +182,7 @@ static unsigned int bcma_of_get_irq(struct device *parent,
 				    struct bcma_device *core, int num)
 {
 	struct of_phandle_args out_irq;
+	unsigned int irq;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_OF_IRQ) || !parent->of_node)
@@ -194,7 +195,10 @@ static unsigned int bcma_of_get_irq(struct device *parent,
 		return 0;
 	}
 
-	return irq_create_of_mapping(&out_irq);
+	irq = irq_create_of_mapping(&out_irq);
+	of_node_put(out_irq.np);
+
+	return irq;
 }
 
 static void bcma_of_fill_device(struct device *parent,
-- 
2.25.1

