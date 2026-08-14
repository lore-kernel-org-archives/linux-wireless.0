Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ACD36EA80;
	Fri, 14 Aug 2026 08:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786695091; cv=none; b=iZfSHjfFv2urq3g1TZmejip7wLCNl56ibbYhZ7FOSuF703dBVcU9XVJAD02Ges/ZE5CN0C2XsHp85xYUFL6MM3oH8gn7SikaM5Ub6fTlTOetMObs6yI+tnJiYusuFilkQ6VfPg1TfzSjTK9y2OOG+RHUdEqJrlu+XrWDdM8f5AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786695091; c=relaxed/simple;
	bh=YmcFx91RbxlDvJdAAaI4Y+kAnZEiw/24k0vZnzFj0Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WANixapIcpX17OSGL+y0imH/Pwl6tEsPaXZJJKjMlilxONOqT+KQLhX1oMpRWbesr7b+mb8Uftvyfb49lJ72w7OvodJIxbckJgF0hWElo2rBm59hPLhtZb6yVVZF1ujfQ0JmyBs+dQGiTbK0daRNiRtNZOEd3UM+sjNM0NGYZOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowAAX6+6tzX5qwxWfBQ--.5955S2;
	Fri, 14 Aug 2026 16:11:26 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2] wifi: ath6kl: keep the IBSS node count within the node map
Date: Fri, 14 Aug 2026 16:11:25 +0800
Message-ID: <20260814081125.25006-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAX6+6tzX5qwxWfBQ--.5955S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1UJrWrKFyUKFy7ZFWkZwb_yoW8Xr1xpF
	4fK397Ar1qqrW8W3yIva1xAF9Yga93trZIkF4qy3y3ZrnrAryrKFn5KFyjgr15JFW8WF43
	ZFsFqF98JF95ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyK14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfU0pBTUUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

node_map has MAX_NODE_NUM entries. When a new peer arrives after the
map is full, ath6kl_ibss_map_epid() increments node_num before rejecting
the mapping. A later lookup then walks one element beyond node_map.

Reject a new mapping before advancing node_num.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
Changes since v1: https://lore.kernel.org/all/20260722040721.74876-1-pengpeng@iscas.ac.cn/
- rebase on current ath6kl sources
- reject a full map before incrementing node_num

The IBSS map state transitions were reviewed statically; no ath6kl hardware
test was performed.

 drivers/net/wireless/ath/ath6kl/txrx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index d81825413906..b340c795b7a3 100644
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
2.50.1 (Apple Git-155)

