Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0FC4ADD97;
	Mon, 19 Oct 2026 10:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404946; cv=none; b=YCQF1cAgYy/hzyB6b2HlHwMkuxr+EV1ksoRhFzRv16cuwh9UOtyhelQYNusxwUgf9xyresqmeZMwHEgAp85XXwFNl4LlfLjpwVh/xNTo3TQ2VNSjM99ecHoBnIbP79saGS5ev1xYrcsQiDPjLOqY1mz9jc9uV/BFNPrd8+3xC64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404946; c=relaxed/simple;
	bh=oVg+/QN4ahp+6YuLherKAPfTwOpnNbmN/UlFcMinZEU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ev9krN84t2X4CoAmkRldseAsE3A+RZcI2SBAJSPmacJaTg2aU3qyB5VNqw0KuKF4Rm9QY7mIBTcAisuFJqw2qXFxUQLfA5qLHmjp1aAgW1JMWNW6tl9O3dTzG9EVOqD0zfSAviyNEHESBeRwBsLAgMZ992OdMoGQGWZQE+TiIlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Qj52vq9Z; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Qj52vq9Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=7Q
	NTHl222Odz+iuzSYAd8BpJ/jJCkrSI/ZtcNY8a9as=; b=Qj52vq9Zmu0t4qiVVs
	W/TYA7GADVHjycDe94GBdwVKJhDYuKaMKPvsIN+SWiePVOj68GF6ajMJENFWH+ZW
	akHDyk8wF8X3TEBN0qCSs3fqSTH/R+TKVTVjaLwkN+u7Sfdu3kgTi/LnV+puFZbG
	Gx8rbKneDimqsVcRhT0W9AZSY=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3Hxax7dVq4twABQ--.41578S2;
	Mon, 19 Oct 2026 18:15:14 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	YF Luo <yf.luo@mediatek.com>,
	Chih-Min Chen <chih-min.chen@mediatek.com>,
	Money Wang <Money.Wang@mediatek.com>,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 00/10] wifi: mt76: validate legacy MCU responses
Date: Mon, 19 Oct 2026 18:14:55 +0800
Message-Id: <20261019101506.1926943-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3Hxax7dVq4twABQ--.41578S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr47KF43uF45uFyDWrWUXFb_yoWkuFc_Zr
	1qkrZxWr18GF4DKFW7ta4akry8A393Jr9rAryrtr45JwnrArWUCan7Kr45uFs3u3Wxtr42
	yrsrCa48WrnIgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRK5l15UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzRO38WrV7bOK-wAA3M

Several mt7603, mt7615, and mt7915 MCU response paths trust firmware
response sizes before reading receive descriptors, fixed fields, or
arrays. A truncated response can therefore cause an out-of-bounds read.

Validate the common response descriptors and each command-specific
payload before accessing or removing data from the skb.

Jiale Yao (10):
  wifi: mt76: mt7603: validate MCU response length
  wifi: mt76: mt7615: validate MCU response lengths
  wifi: mt76: mt7915: validate MCU response lengths
  wifi: mt76: mt7915: validate MURU statistics response
  wifi: mt76: mt7915: validate EEPROM response length
  wifi: mt76: mt7915: validate free-block response length
  wifi: mt76: mt7915: validate channel MIB response length
  wifi: mt76: mt7915: validate RX rate response length
  wifi: mt76: mt7915: validate WED TX statistics response
  wifi: mt76: mt7915: validate RF register response length

 .../net/wireless/mediatek/mt76/mt7603/mcu.c   |  2 +
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 17 ++++++++
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 43 +++++++++++++++++--
 3 files changed, 59 insertions(+), 3 deletions(-)

-- 
2.34.1

