Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA784D09F5;
	Mon, 19 Oct 2026 10:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404958; cv=none; b=dxn2U0TkXTEmjm8DYrcAZbg/KMuE8LnBJcpz15dOj2pKXkyqAuhXIRsgVpyzhhOK1hvOIdZffiwYIuD95qP3JvP2TKNWgqyQzYh4pw3UmavPCn0ONzJugPp/BDqEad///Ock7/udyDyK93ZQe8kuhelV9sCyvvfD0z/WyWVHU5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404958; c=relaxed/simple;
	bh=t4PllrrYRyk59/eCVQ5fkdN3KIu88QJjRwFFhvS3tVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KLtOr/mFv89TqEyFzqbcy/TiRskP5qIkyCZ1y49dG/qywZCVa9JV6OCpjL8qaQtynW9QbOi5F/+vAtrCRKDTOsw64QXlx2t6s86yz41+KB9zkdWHhSE60LNsIlLruPMmjmrn6JMOjygL6OznAG6kBl64P7cd96wNTuimLAxqSsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BIY9THpN; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BIY9THpN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=JM
	dvjLbmygaAxKZ4470P9jf9J5rCOTHbqfSHY5SXp9A=; b=BIY9THpN9z3EpLKmw6
	4URT/x8Kal0nnp8LhuXSCxTBtnN/5V3sL4UiJBDx+a5+ZCA83gqPH5NJOWLa5Suy
	8FqvlrgAH4H2QHR3+1e6wxEnHqpXWncVSXbY4XoMyFpKcOuVlg1BCHws04oUVd/c
	RCQUxVyiHd6O+gtpnrrn5Q5Sc=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3Hxax7dVq4twABQ--.41578S9;
	Mon, 19 Oct 2026 18:15:27 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 07/10] wifi: mt76: mt7915: validate channel MIB response length
Date: Mon, 19 Oct 2026 18:15:02 +0800
Message-Id: <20261019101506.1926943-8-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019101506.1926943-1-yaojiale02@163.com>
References: <20261019101506.1926943-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3Hxax7dVq4twABQ--.41578S9
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFW8tr4UXFy8ur47Gr18uFg_yoWkArX_ur
	nY9rnxKr18Gw1qkr12k3y293yqy395X3WkZrZ3trW3XwsrAFWfCr9rZwnrGrZF9rn2vF45
	Gr98CayUAa4agjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRiuWl7UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzR+69GrV7b+MHgAA3j

The channel survey query reads several MIB entries at a chip-specific
offset without checking that the firmware response reaches those
entries. A truncated response can cause out-of-bounds reads.

Validate the offset and complete MIB array before processing it.

Fixes: 654300281196 ("mt76: mt7915: use mt7915_mcu_get_mib_info() to get survey data")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 05614b99165b..955c0e6c7cb6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3239,6 +3239,10 @@ int mt7915_mcu_get_chan_mib_info(struct mt7915_phy *phy, bool chan_switch)
 					req, len * sizeof(req[0]), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < offs_cc + len * sizeof(*res)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	res = (struct mt7915_mcu_mib *)(skb->data + offs_cc);
 
-- 
2.34.1

