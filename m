Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B073BCD2A;
	Mon, 19 Oct 2026 09:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792402423; cv=none; b=cC4GsXBK0mF9nHQ6RpmR4Jj2QWD1huHRpMkrGFOM3WFSb1IOFdFsEempun5JugnQigm+imnm2okOL06UzlKkIDJApSyipLgqQogJ954f+LYrKk3Py1l27hZWKsEc1qIhj8ZS/BmNVK9vkHys3/VEHTjOw2aQKqX1b+CAEvpkbew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792402423; c=relaxed/simple;
	bh=XWGrvW2HiLDIksf7BHfnmbAiv3I3WvN0k/Su0wCsrio=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U1Qe6oXFPT8VrMqm+QukGWzMMLQH7QCbU+/VimTfcDe0lBXUU9z/mRMhwKJW7nqrdTTCEXJFD1HcZKrSbJ9NgdflFLrTRzYz/TTo3aar7Dm/Iy7udYH6h5IKMsTt/oRU3rs5VUWlKsIsB0Lzh73gBE5RllFao8JGr+c/iTOyffw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TQRl2KGu; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TQRl2KGu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=//
	Nz9GXytPYhtZz3+9TgaX3FgtxnYUSmb1UPwYaHVGc=; b=TQRl2KGuZr1+dpMKVe
	GY6tGtlGGS2DXNI89cY5d3ZAHQ/+FW28BS/PJjYHxi8GIy6LswE4jk04sbTI34Jm
	lwXHwef0lS/xj2MTqwLD+cyFCT4Itvra1G9MOXK7cMuOVYxlD9Ofqcg3u5kPe3Mv
	e0pCFiw6yRS5PSIHzARXR9/gE=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3H73U49VqbIAVBQ--.320S3;
	Mon, 19 Oct 2026 17:33:13 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Money Wang <Money.Wang@mediatek.com>,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <jiale.yao@example.com>
Subject: [PATCH 1/2] wifi: mt76: mt7996: clamp VHT/HE beamforming NSS
Date: Mon, 19 Oct 2026 17:33:06 +0800
Message-Id: <20261019093307.1869749-2-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019093307.1869749-1-yaojiale02@163.com>
References: <20261019093307.1869749-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H73U49VqbIAVBQ--.320S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFyxXry8Gr17GFWxuw45ZFb_yoWDGrcE9F
	n5ZF1IqF48Kr1jyr47ta9xCrySkay8Xr1kG3y3t3saga17J39rCFy0vF1DWrsrCF17ZF17
	Gr9xXFyjk3yagjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjMKZJUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8Bk-eWrV49nb2QAA3o

From: Jiale Yao <jiale.yao@example.com>

A peer can advertise a VHT or HE MCS map with no supported
spatial streams.  In that case mt7996_mcu_get_sta_nss() decrements
zero and produces 255 for the beamforming configuration.

Return zero when the MCS map has no supported streams.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Jiale Yao <jiale.yao@example.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index cd7587ce5b8a..e6243dd33c31 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -120,7 +120,7 @@ mt7996_mcu_get_sta_nss(u16 mcs_map)
 			break;
 	}
 
-	return nss - 1;
+	return nss ? nss - 1 : 0;
 }
 
 static void
-- 
2.34.1

