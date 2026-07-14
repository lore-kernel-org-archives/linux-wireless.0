Received: from smtp.smtpout.orange.fr (smtp-19.smtpout.orange.fr [80.12.242.19])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8682DCBE3;
	Tue, 14 Jul 2026 06:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784011049; cv=none; b=X+oDaOp1snfu4CtRbITxHZzhjPznVctzmEVRefhYiaGbZBk2CNviW4XO9zgTUFU1QaM+E/L0iIngjChl+PqY1WIf3vO7k8ohqjdm43sKzdPkqTvh7ZBYw3Z6f74oW3kKmP6GepvRtVmob+It8R9ZLSgBX9O3hNUJwc2L6tlvVOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784011049; c=relaxed/simple;
	bh=GkGwn376F7BE5RVGZppjjfouvV1bsKEXfbRQpIrL1tk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CcBGhAi5GhfY/Zt2tIKI0VVYrwoBDTpijvBYvRqdFS/xHqxEuBxI83A1pw0if3ocQm8H1eFlN1tQmLak5An47kfjztgZVFT+y0jFlBAf+B9x6za6Io1Lxur20OdGXCYerR+tbxMU+ZzUBbweUvbha57pJn1mv0OOgGKKNmVmK58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=Mshau6pM; arc=none smtp.client-ip=80.12.242.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="Mshau6pM"
Received: from device-97.home ([10.64.95.101])
	by smtp.orange.fr with ESMTP
	id jWkYwgEf6fzaIjWkYwrYuv; Tue, 14 Jul 2026 08:36:14 +0200
Received: from device-97.home ([IPv6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e])
	by smtp.orange.fr with ESMTPSA
	id jWkPwSgdjLgO9jWkQwhwg5; Tue, 14 Jul 2026 08:36:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1784010967;
	bh=s7dq0hK5vSS4LjpG7VM2pGMjoaS2RCGYKJDzNBOXpDc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Mshau6pMTQgZcvDkQ7CxS77/E5zwAMEQjfMF1vuWNtuVylovOSJaAHBN73A0O3ulU
	 ideZXz63XUnNFMhZqBtLnQe1Z3lxThYWf1CXSLLrYVd7P+WxuYDHCYKmhzIsWU20He
	 DIW03Smj5SM4BQPduJjDQW0R44XV0NcSVrKA0j+FZXde9JrZy9w+tZXG7QbAHS/vGC
	 EtCu4Yc90kgo9GH7Ot92H3Ccrdo0AXcZV83W03MuHjqaOxNwkDW8w4hWUCq1GJq+Rz
	 yXSNI1lEu7wWsct0HBXW3vghmfKnIFHrQkLN4W7bFBhWGXUGNldY/QRacsCEWKEjLM
	 SDa3MeCHTnbEw==
X-ME-Helo: device-97.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 14 Jul 2026 08:36:07 +0200
X-ME-IP: 2a01:cb10:785:b00:26fb:aefb:6cd2:db0e
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org
Subject: [PATCH] wifi: ath12k: Constify struct ath12k_dp_arch_ops
Date: Tue, 14 Jul 2026 08:35:56 +0200
Message-ID: <469d732e2c6f159e1a05e89c7e417c3a10db5fdf.1784010931.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct ath12k_dp_arch_ops' is not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increases overall security, especially when the structure holds some
function pointers.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
   6318	   3384	      0	   9702	   25e6	drivers/net/wireless/ath/ath12k/wifi7/dp.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
   6478	   3224	      0	   9702	   25e6	drivers/net/wireless/ath/ath12k/wifi7/dp.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.
---
 drivers/net/wireless/ath/ath12k/dp.h       | 2 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 64f79e43341e..a94bbc337df4 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -538,7 +538,7 @@ struct ath12k_dp {
 	/* Lock for protection of peers and rhead_peer_addr */
 	spinlock_t dp_lock;
 
-	struct ath12k_dp_arch_ops *ops;
+	const struct ath12k_dp_arch_ops *ops;
 
 	/* Linked list of struct ath12k_dp_link_peer */
 	struct list_head peers;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp.c b/drivers/net/wireless/ath/ath12k/wifi7/dp.c
index c72f604661ce..01a45f428990 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp.c
@@ -139,7 +139,7 @@ static int ath12k_wifi7_dp_service_srng(struct ath12k_dp *dp,
 	return tot_work_done;
 }
 
-static struct ath12k_dp_arch_ops ath12k_wifi7_dp_arch_ops = {
+static  struct ath12k_dp_arch_ops ath12k_wifi7_dp_arch_ops = {
 	.service_srng = ath12k_wifi7_dp_service_srng,
 	.tx_get_vdev_bank_config = ath12k_wifi7_dp_tx_get_vdev_bank_config,
 	.reo_cmd_send = ath12k_wifi7_dp_reo_cmd_send,
-- 
2.55.0

