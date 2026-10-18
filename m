Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E58470E85;
	Sun, 18 Oct 2026 10:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792320502; cv=none; b=fLdme434iQx7jxD0q8E43Gu1X8azWOkRfVN7fejUkocnl6RrfeXB7DOb4Xz2U+wfYU42qZyD1AvR/2LQ0cfcwkkRd58nniT7C73X7NvJQmTru1knhLAlyxWRnOCVBB9PvLL0mPamKiVd+B1IYrPHfjD6L5OjsCqT0RMgUdJaxfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792320502; c=relaxed/simple;
	bh=+HwUndoh40tH13apfXyjkPVVc3HfCXGh9016A4W1hsM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JT1IbQsYR74WyQH3OpveHcrAN23C9Ri2esVWfeRevMIcseQmbg3i0plPq6ujlT6YVJAtA5kMw46hqrR69mzdoXcwOpBz8DCNV5klEBFjDbSLc31N5IS2rkS5dt5r1ij68orYc9hJspv7MRo42hEDwulf21G8DwZ/M4sQfOngwIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VlWMxck8; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VlWMxck8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=qv
	GaHGcUtbNa8pA00YQRkxYIlyvf+Kc6B2WPJd4XCNA=; b=VlWMxck8TlfFIw58LI
	YU1swKyQNcFPqK1cIm3knCeQMSvM9ubylHR2Mw/Bbufw5UMXAi6qKG5p3WxChaG3
	i11zp7ks52km8A8xAc6MWe2K89ZjUjsJrrrPVYW7DqL2kqMSb3RjS+syOO5c4PBc
	zKxIH88uz2V43cGY2rX5GSrD4=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDXHyjOo9Rq9DXFAw--.17380S3;
	Sun, 18 Oct 2026 18:47:45 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Money Wang <Money.Wang@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 1/2] wifi: mt76: mt7996: unlink TWT flow if MCU rejects agreement
Date: Sun, 18 Oct 2026 18:47:38 +0800
Message-Id: <20261018104740.865520-2-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261018104740.865520-1-yaojiale02@163.com>
References: <20261018104740.865520-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXHyjOo9Rq9DXFAw--.17380S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr48uw1rtr47ZF48Gr4DJwb_yoW8Gr1Dp3
	yj9342vF9rGr4UG3W0ya109r4rZan5GFnxGFZ3uw1Fv34xArn2kF42vF9rAr1qkFsFkFyj
	qFyjyr1fWa95Z37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRy7K3UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzRLsJ2rUo9LJWQAA3L

The flow is added to dev->twt_list before the agreement is sent to the
firmware. If the firmware rejects the agreement, the flow remains linked
while its flow ID is left available.

A later setup can reuse and reinitialize the linked flow, corrupting the
TWT list. Station removal can also leave the stale entry behind.

Remove the flow from the list when adding the firmware agreement fails.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 1cba381a78b8..a9558381ad91 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -3285,8 +3285,10 @@ void mt7996_mac_add_twt_setup(struct ieee80211_hw *hw,
 	flow->tsf = le64_to_cpu(twt_agrt->twt);
 
 	if (mt7996_mcu_twt_agrt_update(dev, &msta->vif->deflink, flow,
-				       MCU_TWT_AGRT_ADD))
+				       MCU_TWT_AGRT_ADD)) {
+		list_del(&flow->list);
 		goto unlock;
+	}
 
 	setup_cmd = TWT_SETUP_CMD_ACCEPT;
 	dev->twt.table_mask |= BIT(table_id);
-- 
2.34.1

