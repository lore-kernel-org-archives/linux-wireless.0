Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793164073;
	b=a33XFmCrqYEWCJh33UsojRJuvxl/wTbnx6AaYMVCUpKousddzQedJ1wecImXk9xNc24u
	 l7jsw1Sf2ArJW/CEoUra8t85W3LhEXDRBab0cWNWJzuMtPBSMRplwzW4x5voAFeOL55MP
	 c5lYEUZshk23CZCboEu/ZVWeoO22BhcmVDlmmlAKQrXhdXGF7vuzUWbvsadzBffuPzW4+
	 dnDfTq38NFbsjr8XCRsawRvUXKcU7Lof5Vuv8feS3z9YASvAnn6b/kJHRgo5m9tRfxn3W
	 cZF2VipykYSR4R9aUmoJR+HCTE8hguOzS0zmVeTHae/cRzXsf3viSDShgaupjS4mMqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793164073;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=MEd5yoolpftLGplkK7bcv5qF6vsCs9gM+M90KSk629c=;
	b=ItvyeuIQN9XXtUxWzCdqUTxJ6hlV1efn76a8icDgKATz0FMzRKsy0Y+iPJC8P9uc1deX
	 UfBsviBmbE89wJjGMsdJpHisbII+YnGFq5Y7Xh7/y1jFsL3Bv+AiSMbzJ5zZhuebe2r00
	 cuUG/9+nux8+fkjkWi7IUiFqVCD5ljlhYI3FMiuvtPnPDALraBDbyxa51/5XJh+9kgpkk
	 6IzKCshx8X+fMOkqllNcfrtEJ3C5GKmqZ+aLNoJWYwQuTVWEsDtDrPdo2t7y9ZEmR1gSt
	 fcHqMPg3Y+mobkglIhfqagBNyr3vtj3LmQyo+kifucMwCUEE7nzRG/7k9n2NcXPlvug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=D0zYKSbl;
	arc=none smtp.remote-ip=117.135.210.3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF9F606A31E;
	Wed, 28 Oct 2026 05:07:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FF9F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=D0zYKSbl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ME
	d5yoolpftLGplkK7bcv5qF6vsCs9gM+M90KSk629c=; b=D0zYKSbl6lJIdDjoPi
	WX2V+iILXVyAhyf2nw2o54mhE2BbIC0pW5ZJ3j88y45R4S0TEH3Y+F0vTiC+j1UI
	qMlo6/gbCvF9W3qPoQ5rQ6+QX/9ISVcCxwJOnMfKWBVYp27WnPAZscbhnP21/iZI
	UlJcJZkE2aO0cRcxvolz9fqZs=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDn31cMg+FqswGRDQ--.35366S2;
	Wed, 28 Oct 2026 13:07:25 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Nelson Yu <nelson.yu@mediatek.com>,
	Mingyen Hsieh <mingyen.hsieh@mediatek.com>,
	Rong Yan <rong.yan@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 0/3] wifi: mt76: validate mt792x firmware TLV payloads
Date: Wed, 28 Oct 2026 13:07:19 +0800
Message-Id: <20261028050722.135598-1-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDn31cMg+FqswGRDQ--.35366S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr43Ary5Wr17Zw1rGryDWrg_yoWfAwc_Zr
	yvyryqqw48GFyUtay2kr12krW8t3y8ZF1kZFyrtry5AryUAr1UuFn7Xrs8CFn2kF4Iyry5
	KrnrWrW8JwnagjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbIPfJUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzg32MWrhgw33qQAA3f

The mt7921 and mt7925 firmware event parsers validate some outer skb
lengths, but several paths still trust type-specific lengths before
reading fixed fields. Malformed responses can make the drivers read past
a TLV payload, and a zero-length mt7925 capability TLV can stop progress
through the response.

Validate the fixed and type-specific payload extents before consuming
NIC capability and debug message data. Each patch covers one independent
parser and can be applied separately.

Jiale Yao (3):
  wifi: mt76: mt7921: validate NIC capability payload lengths
  wifi: mt76: mt7925: validate debug message lengths
  wifi: mt76: mt7925: validate NIC capability payload lengths

 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 41 +++++++++---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 67 ++++++++++++++++---
 2 files changed, 90 insertions(+), 18 deletions(-)

-- 
2.34.1

