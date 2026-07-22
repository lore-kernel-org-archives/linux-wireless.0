Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6543C5837;
	Wed, 22 Jul 2026 04:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784693256; cv=none; b=b1X1OCrGK6JJKZ9HLHQGsBhGc5Qb6UvOQjVMIg9r1O14yucKQKJtQ/HarEp7E2LvCWYFFCczwOHtsr6oTGSorWgTkr8YDxUADJMh50BHDCxgaTM1Yq+pbKvo5WJqCpYSHujRb0cF7USjKqmW56ozs5SFdgNghe0lZ53H3dYkriY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784693256; c=relaxed/simple;
	bh=9k1+dnpfmtAWF0KXRcKDakGmXWB/ADwzlyGhjbNb12Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EBElP6/guhV2TtAQzll4eONUt0k0uyYCnjzBQA30GyM81j9E6v9dRBCYjk2IYfOOfb4Td8EDq0tL94BKfCygD4/vCrdf081oLXffmEQX/PWF4rtKnlcNjKlNrz2mTzoT1DILsc4MD9C3lSsOrb0ZRMbfctbOZaCSLZH5vUsHA4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowAAnlT_6QWBqMf26AA--.23657S2;
	Wed, 22 Jul 2026 12:07:23 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] ath6kl: avoid advancing node count past node map
Date: Wed, 22 Jul 2026 12:07:21 +0800
Message-ID: <20260722040721.74876-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAnlT_6QWBqMf26AA--.23657S2
X-Coremail-Antispam: 1UD129KBjvJXoWrtry3Gr48WrW8Wr4kKrWUtwb_yoW8Jr1xpF
	4xK395Ar1qqr4UW3yIya18JF98tay5trZrCF4jy3y3Cr1DAryrKFn8WFy7Wrn8tF48Wa1a
	vF42qryDJF90q3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUym14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUywZ7UUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

node_map has MAX_NODE_NUM entries. When a new IBSS peer arrives after
the map is full, ath6kl_ibss_map_epid() currently increments node_num
before rejecting the mapping. The failed request therefore leaves
node_num one larger than the array.

A later call walks node_map up to node_num while looking for an existing
peer, which can read beyond the array. Reject the new mapping before
advancing node_num.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/ath/ath6kl/txrx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 97fdac7237e2..3b0033431b29 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -67,10 +67,9 @@ static u8 ath6kl_ibss_map_epid(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	if (ep_map == -1) {
-		ep_map = ar->node_num;
-		ar->node_num++;
-		if (ar->node_num > MAX_NODE_NUM)
+		if (ar->node_num >= MAX_NODE_NUM)
 			return ENDPOINT_UNUSED;
+		ep_map = ar->node_num++;
 	}
 
 	memcpy(ar->node_map[ep_map].mac_addr, eth_hdr->h_dest, ETH_ALEN);
-- 
2.43.0

