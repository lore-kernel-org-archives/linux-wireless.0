Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F58018D62A;
	Sun, 18 Oct 2026 10:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792320499; cv=none; b=mzWbDPtTiYft6SciP6/hYFI6p5ye6p1PkDEBlMYa/l9gyJH7neiBsqweHfCBdS9HWQHCXDHIPVCvTnTxby2+ghzEJTadUGf9+RjARDX1f/narmZQ2ZnW36TGqfqG/B66cWX0wvGvM81fQYhUt23BdNvZ8/ApLp2zDFUy5mGMwzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792320499; c=relaxed/simple;
	bh=7QqqKur/X9xQxCGE9ArCDEIvgdV8jsjy0SuiUFNU6ps=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UmeuMPvkLFa6uMH8O3fM/+fRiyHS0Bj+R3DqHgaVjVj+DVoEw3prpkIqvFq7oo//89vnS1c1QO2qbCu0He21zriQC7cfVH2cyTrBulkTpjrcBAuOlqno+spIfxPi72mbexnatD5pFn99SbZpJLT9gykSgqfVJk424u5YXT/odnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Df2I55a8; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Df2I55a8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=aV
	3QHZpzOHPfDb9zU7r95hbA5Y2mZWIiVFdWzeyQP7c=; b=Df2I55a8LHOrYjC13T
	Y9/QsM72zoFNkxE2S168o6PFnJzVjPYrIFyYZwDyvaonYk0m3zB8g0qLvNFERF3+
	1dRiSwofPNT5dzmVbeqg00xV4LDgcug4LKK3OYJ4MVc+O4J4vfWSl5WpZ7XYGpfu
	2WRImamjG5AzuIS3qJeWWAaKQ=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDXHyjOo9Rq9DXFAw--.17380S2;
	Sun, 18 Oct 2026 18:47:43 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Money Wang <Money.Wang@mediatek.com>,
	Evelyn Tsai <evelyn.tsai@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 0/2] wifi: mt76: mt7996: fix TWT and MLO teardown races
Date: Sun, 18 Oct 2026 18:47:37 +0800
Message-Id: <20261018104740.865520-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXHyjOo9Rq9DXFAw--.17380S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF4UKrW3Wr4ftF4xuw4UJwb_yoWfCrg_Gr
	95JryUK3Wv9F1DAFWfKrnxJrWjk3y8Wa47Cayrt3y7t3yfArs8CFnxKrnxXrs29a1xWrnx
	Ja98Z34I939F9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRRMa07UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzRDsJ2rUo9DJRgAA3U

Fix two teardown issues in mt7996.

The first patch removes a TWT flow from the scheduler list when the
firmware rejects the agreement. Without this, the flow slot remains on
the list while it is available for reuse, which can corrupt the list.

The second patch clears every link WCID of an MLD station before the
network synchronization in mac80211. The generic callback only clears
the default WCID and allows the RX path to retain pointers to the other
links while station removal proceeds.

The patches address independent paths and remain independently
buildable.

Jiale Yao (2):
  wifi: mt76: mt7996: unlink TWT flow if MCU rejects agreement
  wifi: mt76: mt7996: clear all link WCIDs before RCU removal

 .../net/wireless/mediatek/mt76/mt7996/mac.c   |  4 ++-
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 27 ++++++++++++++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

-- 
2.34.1

