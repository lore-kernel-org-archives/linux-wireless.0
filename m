Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6544B8285;
	Mon, 19 Oct 2026 10:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404681; cv=none; b=QI2gNbeZg4ZKoKd+bL3/JwzSDakCWndtC2GwJB8VSY04jqbYPUjJx1alZ+dqAJPtNQEa9r4ohUX3E6tcCRIVpsC0YMQp4UUusgkqe56JLDeYqIqYWPGl5ucR/7bXWkI4nfJAeBYRgk2H/UELjfVb7tEXmlauf785RjoTFiz4dxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404681; c=relaxed/simple;
	bh=zVqAZWwdL91u+X2L2sSv4uMJqku/bL40qw6pKmkFwpA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=obQS3QJamhtrMLdBATX69WZCmpIGyDvLI6DetWL6XBKGGdgDbkw15HYxsgXymT4V6vg7Rh4AO5AhaS6UQ2MOy8JHEIT56HOVEIVKPmPzfrQ/hKxtJIUqFEzMdtaIBHjB1hCyqcau2nz8AZ9OxjVFYOgNsos1NJ1Ws+ds/XJIs4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=HmM1/NcZ; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HmM1/NcZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=wu
	IWijRtYYAq+6BiQ98mjJUGC3M/zZZs5wiFaBV7CKQ=; b=HmM1/NcZRdhsrpk1Mv
	Fcv3FyCerOktb9bZmHZp527joX1ZoMtCfwslgUMxPRcJMQ50eryxc0p5ERYOcRsr
	WdFr86uo3162damvcw81es03JFf0P5VGukwDL0z6mNfLcVG3W/qdmYvR8myUx4Xi
	i/94gioD1HJIQq8rt5MwX5PiE=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3_8Wk7NVq1VPPBA--.45843S2;
	Mon, 19 Oct 2026 18:10:45 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 0/2] wifi: mt76: mt7996: clamp beamforming NSS
Date: Mon, 19 Oct 2026 18:10:40 +0800
Message-Id: <20261019101043.1922205-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_8Wk7NVq1VPPBA--.45843S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruF1fZr1rtr4DGrW7Ar1UJrb_yoW3AFg_C3
	4vyr98JF48tFWrKa17Kwn7XryIvay0gr1kCw1jy395X34xArs5WrZ7Jr1UXwsrWay8XF15
	Jrn3XFyxA34fZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUUtl13UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wV0rmrV7KUf4gAA37

The mt7996 beamforming configuration converts a peer maximum NSS to a
zero-based column count.  A peer may report no receive streams for a
VHT, HE, or EHT MCS range.  Decrementing that zero value underflows and
can send an invalid beamforming configuration to firmware.

Patch 1 fixes the shared VHT and HE MCS-map conversion.  Patch 2 fixes
the corresponding EHT conversions for 80, 160, and 320 MHz operation.

The series was checked with scripts/checkpatch.pl, and each patch was
checked for application against the common base.

Jiale Yao (2):
  wifi: mt76: mt7996: clamp VHT/HE beamforming NSS
  wifi: mt76: mt7996: clamp EHT beamforming NSS

 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.34.1

