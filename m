Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50EB3FFD;
	Sun, 30 Aug 2026 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788098228; cv=none; b=tj92gvTQbj9HiQWwviKLmEyNyigQTQaU2f5x7kGa/R1HjHHwE0+I0R5qyP1SCwdZsNPMEEovEB+oWciK4UGUBEnEU1JU/hHZUI6n8tscnKeq+ZYiJ82hWFwnLfJRdzfGienZaED9Vc86OjbOflpyu5l8L4AFuQY4toes48pEw3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788098228; c=relaxed/simple;
	bh=SFr/jG1P6J7E5kz6/PvNMke/movN76BOtXQEiLG6IFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lqJ0Qm6SJWequ9ELStbvCufy/uao7jL1nIsnlOfpIZAGs4tNKr6E7Q3tRY0HNdbWqtX23cb21HvUDNPv3uA2ZzAYMnzrx3LPKx+nz5QTX/nPbkANbOk50W3pAWI/T3ZckR8zslPQKyibg45bNKpecz+irnvzYtsUAzBZWC0L+oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowADHyzmvNpRqxmubBg--.17628S2;
	Sun, 30 Aug 2026 21:57:03 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: linux-wireless@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: cw1200: validate RX header before use
Date: Sun, 30 Aug 2026 21:57:01 +0800
Message-ID: <20260830135701.18080-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADHyzmvNpRqxmubBg--.17628S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CFyDtrWkAF1UXw1UtrykAFb_yoW8Wr1DpF
	45X34xtrs5Jrs0v3WUJF1rZrWrZan3X3ZrWrWxC3yrZrs3tr1rJryku3WfJFn8trs3Za4S
	9FWqkrs3AFn5XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUa9akUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

cw1200_rx_cb() interprets frame_control and management-frame fields before
reaching its existing minimum IEEE 802.11 header check. A short firmware
frame can therefore be read before it is rejected.

Move the existing length check ahead of the first header consumer.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/st/cw1200/txrx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless/st/cw1200/txrx.c
index 084d52b11f5b0..e5435595a78f0 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -1018,6 +1018,11 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 		/* STA is stopped. */
 		goto drop;
 	}
+	if (skb->len < sizeof(struct ieee80211_pspoll)) {
+		wiphy_warn(priv->hw->wiphy,
+			   "Malformed SDU rx'ed. Size is lesser than IEEE header.\n");
+		goto drop;
+	}
 
 	if (link_id && link_id <= CW1200_MAX_STA_IN_AP_MODE) {
 		entry =	&priv->link_id_db[link_id - 1];
@@ -1062,11 +1067,6 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 		}
 	}
 
-	if (skb->len < sizeof(struct ieee80211_pspoll)) {
-		wiphy_warn(priv->hw->wiphy, "Malformed SDU rx'ed. Size is lesser than IEEE header.\n");
-		goto drop;
-	}
-
 	if (ieee80211_is_pspoll(frame->frame_control))
 		if (cw1200_handle_pspoll(priv, skb))
 			goto drop;

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

