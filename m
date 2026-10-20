Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464418;
	b=kOoSsRyT+wkj84meUnYboBNcaiwciYxej/4eNtXeIEjUmHnDFwci97VtdD8PfN35kRtV
	 10AQn1KYn+xP632++WRQkLE8Qn1ojWM73pOWL/kpmlbzfYg8Sl8YzLHuANQi0DGZm3zPa
	 OZsfWw7kLmqJTqqPw3p8PwcUlMhCK1TsWrzyyWv2aWg9o61FwaJ0J1I4v1E9VV9njJ9xM
	 fHT6Fo72HIYAibSDrJkeBijeW6rrgspvx3WnJ77i/xT9ckxJyxsDI7gPoF602D0aN2ELz
	 fEgawj2DK3jp2nezeULhy48M91vjYvOXTnofCmxurUR30FS+wjx0Ji+5RmWG6EXJvcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464418;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=3eT8W1wovMahicNrQMVsGghdo6IMiGhCZifPmKN1tqY=;
	b=Hx7hEgiu63B6A856O2EOLRIhDJ//eh8nQaOYMa66a2TOJtTR0VwytjLCMaNEBvRetE4J
	 V4AqX+z9PXQs9Y9/Qq9KUl6amW4GvCCIdqX4zN6+OKS5TH0sXlClqgK+uZlqR/qMH0whQ
	 i1hOzetBrJq/VIjIF8obj74PvEN5TWJT7o6qSltXCOIZNBvttPFq3rLxf2k/WWaE3s2v5
	 pgyjuBsWP78DoJbwi/9Q8Q+36XQsaG3HNacq9kIFx5pAJXSkBVvPhOs3nLoRGbDl4FpVl
	 wHQCUaOECL8VjCbs2KBjc8MZ+P4gRsV8K6rUy2bEpuFae3CsdRnSuReqXlSY9/Ml25w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=lZozn5LG;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D8C60A2614;
	Tue, 20 Oct 2026 02:46:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0D8C60A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=lZozn5LG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=3e
	T8W1wovMahicNrQMVsGghdo6IMiGhCZifPmKN1tqY=; b=lZozn5LGTFlQoOFR47
	/K58CQZjn1BUL7GdND2zn34Ji3n1rUOuWuxBC//txmNUXUxpac9lz5fPIos/8skf
	IGIi9ykQalukyei1gVC3N+W+Xusbyvkq1dI4lyECYN0OqB0oFNzKcW/VI4dgt8MF
	Sr5UhOZd4IfpGuA8BZPXQxZGc=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H9HZ1dZq2OtmBQ--.60682S2;
	Tue, 20 Oct 2026 10:45:47 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Soul Huang <Soul.Huang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Rong Yan <rong.yan@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Nelson Yu <nelson.yu@mediatek.com>,
	Allan Wang <allan.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 00/11] wifi: mt76: validate mt792x firmware data
Date: Tue, 20 Oct 2026 10:45:32 +0800
Message-Id: <20261020024544.3101738-1-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3H9HZ1dZq2OtmBQ--.60682S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr13CFykJw1kGw18Cry7Awb_yoW8GFy7pF
	y8ta15tw1UWr4fGws3Aws7ZFyYy3Z5C3WUAF43Ww1Fqry0yr1rJayjk3W8WFW2ka92kw18
	ua1jyFsxGFyq93DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jeksgUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzRv7NmrW1duB7gAA3G

The mt7921 and mt7925 MCU paths trust firmware response sizes before
reading fixed fields or copying payloads. The shared mt792x firmware
capability parser also derives pointers from unchecked region and
release-info lengths. Malformed firmware data can therefore cause
out-of-bounds reads.

Validate each response before accessing it and keep every firmware
region and release-info record within the loaded image.

Jiale Yao (11):
  wifi: mt76: mt7921: validate MCU response lengths
  wifi: mt76: mt7921: validate EEPROM response length
  wifi: mt76: mt7921: reject malformed TX power responses
  wifi: mt76: mt7921: validate testmode query response
  wifi: mt76: mt7925: validate MCU response lengths
  wifi: mt76: mt7925: validate register query response
  wifi: mt76: mt7925: validate EEPROM response length
  wifi: mt76: mt7925: validate temperature response length
  wifi: mt76: mt7925: validate TX power response length
  wifi: mt76: mt7925: validate radio status response
  wifi: mt76: mt792x: bound firmware release-info parsing

 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 34 +++++++++++++-
 .../wireless/mediatek/mt76/mt7921/testmode.c  |  4 ++
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 43 +++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt792x_core.c  | 44 ++++++++++++++++---
 4 files changed, 117 insertions(+), 8 deletions(-)

-- 
2.34.1

