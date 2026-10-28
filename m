Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793163860;
	b=B0zYly2RePJUl6N5dsBAnFYM7yBy5ZraiqBvuthT90x8Xox9UKagyq2QtaVme5Zo9QK+
	 uWjTTddr3bf1ApN/XPlNSeIfp10LnYJ+4H6+SfcUUBnC+P6DzPYGAv9eBXuzSy079QerN
	 z52ZJJiwzFR2M2n5C1CKiY6ESv2xqiq7/s/EqlMBK7WH5jw3rhYLpxvG+dmo1LMtFBpTp
	 +CFPFb6/k71JOZhlg/83+VOFJlNuY+m+ZT/BE8IsaZWlGn1+eHvK067YbEdnyo0sVNxyK
	 ndg5SsWPJO7z6uraP29YKtFZETyMNAw3jtrge2frOTyTdMHyPQBfaXNARxs/1ly5JLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793163860;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=5+/zEcisdUo3RoFY7nVtqHud5/KjEXoewWCOd/h8vI4=;
	b=qQxDVM+xkxoGYStGToEd/S7nPVyVXvfOloXgjgJSGnT28O3I0vt8ZMFD6c9M05ujpRcI
	 d5LwWGi2Udl1tlbnlSfXgzLpruxgoIiOfICPerIDlJf0CVMk7iS7Ue/cj0kXc7og9bpwQ
	 tkDsrZGgq/enZGojpAsCMIzy6/vWbgqZoqfnvmFSTP8jnbYPNdunwVU+Hki4NtnsQmlpl
	 l2HhzwL32kDpPHKTRR9IFCEqbvPSWHwo4ngpzGvj218Jbv+VuNGBK1he5c8e8nYQZ9zXa
	 XUw65iSBCL1ZskBqIb8qMuDBiG3uqi4RbT5S5C28vcJ4bsF4bC4TNI2WpFu+3+hE6RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=DepkwG9y;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB73606A31F;
	Wed, 28 Oct 2026 05:04:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDB73606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=DepkwG9y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=5+
	/zEcisdUo3RoFY7nVtqHud5/KjEXoewWCOd/h8vI4=; b=DepkwG9yHcqIxstD/W
	OMmGII+v6yaLEhGllylLD+7QHVrzaIwQhwt7hABwPWVGGyp59QckqAaTV9fm0PqJ
	VYC1WSFgBPr2ETgenpUclIlC0zI+tbHXtMi9b9PuVykdpXvn5pvraJiMYZhxdQ3t
	2BVpKGFxfyWNVxWl6uvJRDj9c=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3X28rguFqvXzDCw--.30877S2;
	Wed, 28 Oct 2026 13:03:40 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 0/4] wifi: unwind failed interface setup and recovery
Date: Wed, 28 Oct 2026 13:03:33 +0800
Message-Id: <20261028050337.127464-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3X28rguFqvXzDCw--.30877S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GrWxWw4DWw48GFyrtF45trb_yoWkXrg_u3
	4kXr95Jw10yFykKFZrCF47C3yqyFWIkFyxZFWaqrW3Ar1xXFW3Wrnavr43ur4I9a1jyr9x
	CrnrXryrXws3WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0Gjg7UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzg2++Grhgi3irQAA3u

Several wireless interface setup and reset recovery paths publish host
pointers or create firmware state before later operations which can fail.
Their error paths either retain pointers to vifs that mac80211 will free
or continue after firmware interface restoration has failed.

Clear the published ath10k and iwlwifi pointers on add failure. Check the
mt7921 and mt7925 firmware restore results, remove partial state and stop
configuring the affected interface. Each patch fixes an independent
driver path and can be applied separately.

Jiale Yao (4):
  wifi: ath10k: clear monitor interface after add failure
  wifi: iwlwifi: mvm: clear P2P device pointer on add failure
  wifi: mt76: mt7921: unwind interface restore failures
  wifi: mt76: mt7925: unwind link restore failures

 drivers/net/wireless/ath/ath10k/mac.c         |  1 +
 .../wireless/intel/iwlwifi/mvm/mld-mac80211.c |  5 +++-
 .../net/wireless/mediatek/mt76/mt7921/mac.c   | 16 +++++++++---
 .../net/wireless/mediatek/mt76/mt7925/mac.c   | 26 ++++++++++++++++---
 4 files changed, 41 insertions(+), 7 deletions(-)

-- 
2.34.1

