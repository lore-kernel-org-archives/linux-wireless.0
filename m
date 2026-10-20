Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464611;
	b=zoa9itY+S67tjqBFne5rl+fB4la1krzwiuUPn2HHruAxXj7VmB/vxO31cgspRIhIws+A
	 F7c+FUFxnrZR8tfz4yWL/gmeRxXDC9tHonBtXkkgb/lUpE6QGGRBpi4JQ9fmN+coPYDqz
	 +4pFnhiEv8iCSC+4TAfUq7Ehr4AmqhpIbGROi01iM7cg5hdYnQTdAW2Zx/+GPC+W7vwyG
	 y12hGzAXiojs1QinNS7qtZGTXXG4Kdkt/HC/VNmaz7sY2HR6RclO7b9HaFfjKr0qgrGXB
	 O1WsjbhWZHPPV255oLsqEpAYpAhlBPMCx3PgvGo/txzXF8ZO/XqdZ4oKIns7HEXI0dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464611;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=E1wQ0lQppwgJy+LQuVEEB2dNmxOpABDONeSzv3dOwiw=;
	b=zOz4u2Tf96yHQYh73izAbzEfmu1Nznt2AkAsoEKZ/84mBVAKdj1aGoaOJWyDq1aP5g1i
	 inEFd/gwD3ghLlvC48LrIJ0jQ4jIbmhvmKy0RLgkpDrmh7xG2l0O96AwoeWTmPZHel1+s
	 sVudClry6F0kJMaa/PU8CMZ6K1rtfIekHWY4z7FnrvTcj67ZYE/NMDpjaqpa9wv9J1ulq
	 YFH78FIXY2y4/ZEjqWKOy9DrepMr09jAZWoKapVoLwzYG+bc2FVMDTx+UAp/FbQm3X3/S
	 gVFSkIvoRZpf7kxtEEFYGDRv/L1EDwnkIUJuuW5TM87nGF+DhF1qlNola3KfCuy8r4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="XJvPpY/z";
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439A4606A338;
	Tue, 20 Oct 2026 02:50:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 439A4606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=XJvPpY/z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=E1
	wQ0lQppwgJy+LQuVEEB2dNmxOpABDONeSzv3dOwiw=; b=XJvPpY/zGajeEENbR6
	Ve3sdXt5s3zTIuWSmMoSmtoinqZxXAHsIyOt4IBYg7EpHopHxdiY+r3iYsH6Yg8s
	qNjt1keD5GVJZ5FFhF0W1EPqCLRRo0qIVjdb6Rijn8z/l9h1Jy0qwgREtNKwYJbx
	MyrkDKGonIenygWh4lGuFpASM=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnr8C+1tZqMLhIBA--.5123S2;
	Tue, 20 Oct 2026 10:49:36 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Money Wang <Money.Wang@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Elwin Huang <s09289728096@gmail.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 0/7] wifi: mt76: validate mt7996 MCU responses
Date: Tue, 20 Oct 2026 10:49:26 +0800
Message-Id: <20261020024933.3205681-1-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDnr8C+1tZqMLhIBA--.5123S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZry7ZrWUZF45uryUJFy3CFg_yoWftrg_Zw
	4vyr98Xr18KFWDta47K3srAryxArWIyry7C34rtF15Jwn7trWjkFs7Jr4rZFn29F17tr4Y
	yrnruay8ZwnIgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8S1v3UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8AA2cGrW1sA0ewAA3T

Several mt7996 MCU paths trust firmware response sizes before reading
receive descriptors, fixed events, or variable data. The asynchronous
IE countdown handler also walks firmware TLVs without bounding their
lengths. Malformed responses can therefore cause out-of-bounds reads.

Validate fixed response fields and payloads, and constrain the IE
countdown TLV walk to the skb.

Jiale Yao (7):
  wifi: mt76: mt7996: validate MCU response lengths
  wifi: mt76: mt7996: bound IE countdown event parsing
  wifi: mt76: mt7996: validate EEPROM response lengths
  wifi: mt76: mt7996: validate free-block response length
  wifi: mt76: mt7996: validate channel MIB response length
  wifi: mt76: mt7996: validate temperature response length
  wifi: mt76: mt7996: validate RF register response length

 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 97 ++++++++++++++++---
 1 file changed, 85 insertions(+), 12 deletions(-)

-- 
2.34.1

