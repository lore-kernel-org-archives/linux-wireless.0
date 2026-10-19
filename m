Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230864B44DB;
	Mon, 19 Oct 2026 09:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792402427; cv=none; b=CJM1+HdIa6mRbNQuZIww7cfMR0S7U5xHG1TKFmNSPyohBaUB2wOf6FTMuhj/bNTTu3+5ictJvcFsJlBRFoR+DYKlZ3m/8HRg6zG+ckdpiQ+BtJeIoNdezmYaGXMy+KxHq2Qer+uK0HNWvK+QAUJODDBHfoiS/hA/JbVE7eudei4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792402427; c=relaxed/simple;
	bh=ZsDB7UVL/LmloWNnVluFsvsrHlfyNh8c7eT+F4/l8Ng=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EeZT69e4ilvCNcp+noXsTMSup3tlWrIvZ8Qma8FJeUJGDcjK/Cr9A0t+AgkzXBvstKKeMSwoaNu8Allpe7y10G6YPpvpOrMxjy6La12xjghjgQkjyMBes4Qu1K+FVBYpu8pqxy6BMAWJh00tcj/X4AchBB5gl4T3GehHt+v90xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LI7XT3pK; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LI7XT3pK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=VB
	omzRk9uUTgk753tHBnspcaDlOQMppIF8orQT9r2mI=; b=LI7XT3pKwH1BQw30Gm
	3Mpv/Wk+Ex+kdYYifhKsQM2TjcXW74AaQfqYDZ2GXm0fCyRT9Y3kh02uYq2TNTiC
	4TsAWS9pihgdCBa4/MjYOJGi4FksYb+W6fVIAXrGbOyy3KbIN7gcRRpD6atTW/PY
	fOvFWpU9ZxE/u0cZEAnxzstEI=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3H73U49VqbIAVBQ--.320S2;
	Mon, 19 Oct 2026 17:33:11 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <jiale.yao@example.com>
Subject: [PATCH 0/2] wifi: mt76: mt7996: clamp beamforming NSS
Date: Mon, 19 Oct 2026 17:33:05 +0800
Message-Id: <20261019093307.1869749-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H73U49VqbIAVBQ--.320S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFyrurWrJr1UZFyxJw4UCFg_yoW3trg_C3
	4vyr98JF48tFWrKF17Kwn7XryI9ay8Kr1DG34Yy398Xw1xJrs3WrZ7Jr17XwsrWay8XF13
	Jrn3XFyxA34SvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjLL07UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xc+eGrV49dfWAAA3y

From: Jiale Yao <jiale.yao@example.com>

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

