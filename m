Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580264;
	b=5TWF5lEAi2yRAn2HQXzrTUSfAmp+UG+712RpitOxsD5jmBbuk0yCvb9PrBHhBHJMhWtt
	 KNsQR1TGEAPtUqFIh1kx2y0l5mua3hM8X88A2ReIrhX11P+7MkoY0MzrPuS7EpkpA+wYS
	 E2QtPCK8hYsXeAcQ6Ltw5zHungsmQCaKUJA0amhk/IU6BeXhk8aVYj5TOX9zH1cu4htiU
	 mrdfxxVvR9SNODJ4P8zic5mGH0yoQxnJDC+dB2/yWQ12SloZBxUViafYms+5jz9nUAnWq
	 QqN2v7f0R8Q7sfE/zT1jD5kvxvhxlNXiadMHMXIqIF7DCceCGkbBZPzPur2ncD1qYDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580264;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=jmjusv+/TilRvZcy4hr7+HvEUCRXyzMIezmOMmn48E4=;
	b=AQbYdTsZwZ0DmMuHKd1lq9W+OiNKccfjPjLbmLpqh92DJlbPEkJ21RAghP+5Z0KT7GhD
	 S0r4xJ/nAZB6JN7d4TSeC8fo6m/SaG8ipRuLCOZuLBUUpMmMrDFHouPduNiaOw/30xhJo
	 cF19kfiBCSDzKySMtRtfjvEKjx11lKQPL+VxJifgCrpBfJNu0r//lygjVsP0aKY68mhI7
	 drouPllGo8z2NzARh+UGA66lNo6FNvD+O0s0QKKFlnxSvX9SSyHDAq2rEIh3JIRGz0tpq
	 oLIrJkM16IZf4p1YJ1Ubeuk/SQqk6vAASCbbNqwdWwHwqfN4RdUHq0qWZB/eyHhIsTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=IvzovugP;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1495606A31A;
	Wed, 21 Oct 2026 10:57:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1495606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=IvzovugP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=jm
	jusv+/TilRvZcy4hr7+HvEUCRXyzMIezmOMmn48E4=; b=IvzovugP2uPXzlP9SN
	lomj1rAijISQFJ1claqNiVNkf2ChAbuKvSn5DYDooGPeX9ymNFhKfbxY8gfjpp9i
	iG2nXLcz3qkEcw29uDO7E5NuDbH/5M1j+34+dpm1HXOePNxymbrJNLAwWCRf7ZAF
	lLbK29/LJNWae6qJX5sEglmek=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3_1CJmthquYHTBg--.25487S2;
	Wed, 21 Oct 2026 18:57:15 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v2 0/2] wifi: mt76: mt7996: clamp beamforming NSS
Date: Wed, 21 Oct 2026 18:57:10 +0800
Message-Id: <20261021105712.4124467-1-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3_1CJmthquYHTBg--.25487S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruF1fZr1rtr4DGrW7Ar1UJrb_yoWDWrg_u3
	yvyr95GF48JFWFka1xKFn7Zr1Ivay8Wryvkr1jy39xW34fArs3WrZ3tryrXwsFgay8ZF15
	twn3Xas7Z3sxZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUj48B5UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wya1GrYmoxBBgAA3O

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

---
Changes in v2:
- Correct the author and sign-off email address.
- Add Cc: stable@vger.kernel.org to both patches.
- No code changes.

v1: https://lore.kernel.org/r/20261019093307.1869749-1-yaojiale02@163.com

 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.34.1

