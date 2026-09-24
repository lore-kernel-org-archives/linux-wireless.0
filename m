Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AB4483811;
	Thu, 24 Sep 2026 13:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790256060; cv=none; b=ctg1xtqLWe2XrzkCGP1LauR30JFzBI9EnArRtfTAmo8HptzFMpv8T198TkCyT4ajjz4aFqEdxfqLOKxqWMQKIAzsPj+awjCPbZcDsZg0RAEfWTpEFgddu/EGTB7a3zDQhJOYAonH7X1LhPo5nAos2qoWKq7N1jxh60y9aM6MDBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790256060; c=relaxed/simple;
	bh=/KyA7tKonygoOySgnjTqNaqmS1C4JHDR0vt6rj4vuSI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dcIpfFXLQrfptHsk2SJZIID0oUbilGJkSbjIUUFsIqxcMvVgMXwR2xREWNmuhM06kbUCXzpi2ISMIXDTJ2Y3umISA0fmIMyOsNeaMV7wCMLscC4kdqjIvcMGJJCKZtgaKyehfhU7813A69uAomvItd44mMOqrVPgkLt2kOs4+Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AviqJg6P; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AviqJg6P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=aH
	522iYrBWel5jUV2dQMkekOyxwAP46HVzh5gq/6fUQ=; b=AviqJg6Po4eDyI0rSA
	sM22jazysuvF+piZcFyY/oqxAtAtzBlKTkilD2+fRUW7HW03xDsZzRqcmNYM934F
	5pfDHC2IM06N+1mYKe+7NErSkRe2G7I8P09WIgYbyd2PoQHm0+5DUDmEPwa5/r2h
	+Rhuj7E0cbT8rXEbfjSxIrK4A=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3d5ROI7Vqq0FrAg--.32720S2;
	Thu, 24 Sep 2026 21:19:13 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Javier Tia <floss@jetm.me>,
	Leon Yen <leon.yen@mediatek.com>,
	Eason Lai <Eason.Lai@mediatek.com>,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Marek Vasut <marex@nabladev.com>,
	Ville Nummela <ville.nummela@kempower.com>,
	Nelson Yu <nelson.yu@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Rong Yan <rong.yan@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Amitkumar Karwar <amit.karwar@redpinesignals.com>,
	Kalle Valo <kvalo@kernel.org>,
	Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 0/4] wifi: unwind state after add_interface failures
Date: Thu, 24 Sep 2026 21:19:00 +0800
Message-Id: <20260924131908.950229-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3d5ROI7Vqq0FrAg--.32720S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw4rCw13Xw1DurWUAF4fZrb_yoW8Gry7pr
	s2g3yYkrn8Gry3tw43A3WxAF95Wan3Gr45Crn3Jw45Xr1UAryfZr4qya4UZFn8C392k3WU
	Zr4qyr98WF9rCFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0z_YFAJUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BHkH2q1I1FJdgAA3I

mac80211 does not call remove_interface() when a driver's
add_interface() callback fails.  Drivers must therefore unwind all state
they published before returning the error.

Four wireless drivers leave vif pointers or resource reservations behind
when a firmware operation fails during interface creation.  Depending on
the driver, later RX, interrupt, or testmode paths can dereference the stale
vif, and leaked mask bits or counters can prevent subsequent interfaces
from being created.

Unwind the state at each failure point, following the approach used by
commit 2fb6480c52f6 ("wifi: mt76: mt7915: unwind state on add_interface
failure").  Each patch is independent and addresses one driver.

These paths were reviewed against the driver state transitions and their
remove_interface() counterparts.

Jiale Yao (4):
  wifi: mt76: mt7615: unwind add_interface failures
  wifi: mt76: mt7925: unwind link BSS add failures
  wifi: rsi: unwind add_interface failure
  wifi: mm81x: unwind add_interface failure

 .../net/wireless/mediatek/mt76/mt7615/main.c  | 19 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7925/main.c  |  4 +++-
 drivers/net/wireless/morsemicro/mm81x/mac.c   |  9 ++++++++-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c   |  2 ++
 4 files changed, 31 insertions(+), 3 deletions(-)

-- 
2.34.1

