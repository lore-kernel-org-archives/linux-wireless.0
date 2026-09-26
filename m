Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7E33E172F;
	Sat, 26 Sep 2026 12:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790424830; cv=none; b=DSxGu6gocffFVrcB2F7hPrQIu7TxWbHbNb+iZbZgt8ycA8DtbfPr7ZmnsTkXTg6VPCX9BOjHGQIzcxU66TkAv1emPbbFDxVH0hgOYhfT3LFN3mnzLbZcOVsBg43A1Wj9LK/xS41fFc82e8Znr/3PiQcS/gY7KHEsFm0skY9BQqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790424830; c=relaxed/simple;
	bh=coy66B4h9bPVMLFrnm1ncohjxZfe6XeN23wu0jiXsOE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FaJzKujBhC7A+OE9z2FduP9c5aMOJkrexTimsIuS0SlmZeVEIDm7NYTTCisKAFQdTFy7zaIf2rPPiRG9vI+mtX2V37ZR4YmpalAaGRkh76+DoUjUq8bTE2yR+VbkgVTRn2fFTOGlT5qEMIa2RhnbvOOXXRwNNJO92PjeGypNKoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gouEGYUU; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gouEGYUU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Pf
	Q+eUGvS5YGA/VscR/3oNIajPr36RjH9P3BCUg6xzQ=; b=gouEGYUUXLSogCO3Vq
	y8PvQsp8mE/Sw0PYpK9dBT5mgoQcsgupVmByKOxj2VevlCRQl1K/ghhwE94427oB
	XpulkpK0WtSRuG8U1YVr1fgMaUwBQZYudLHCe/45dCjKniXTQt4ociVOn1NyPR1B
	9sEEeJ+nX90Lz1Px6p3VL7yXc=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD338nKtrdqfXOcAw--.9011S2;
	Sat, 26 Sep 2026 20:12:59 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Michal Simek <michal.simek@amd.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andres Salomon <dilinger@queued.net>,
	Thomas Gleixner <tglx@kernel.org>,
	Paul Fox <pgf@laptop.org>,
	Dan Carpenter <error27@gmail.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	dmaengine@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	platform-driver-x86@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 0/3] debugfs: Reserve space for string terminators
Date: Sat, 26 Sep 2026 20:12:47 +0800
Message-Id: <20260926121250.3258285-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD338nKtrdqfXOcAw--.9011S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruFWrtw1kCF1fKw15Gw1fCrg_yoWfurg_Z3
	s5Krn7Jwn7Xws3Za42yFnFyrWSkFWaqF18Xwn8trySqry3JFyrAFs8WwnrGw4xWFs5Ar9r
	Gr9FqrWfZry3WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKF4EDUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wtoomq3tssfmAAA3J

The same boundary mistake appears in three debugfs write handlers. Each
handler has a zero-initialized buffer and allows a user write to fill the
entire buffer. That overwrites the only NUL terminator before the input
is parsed with sscanf(), strsep(), or strcasecmp(), which can then read
beyond the end of the buffer.

The write paths are independent, so the fixes are split by file and can
be applied separately. Each patch reserves one byte for the terminating
NUL while preserving the normal input size for that handler.

Jiale Yao (3):
  platform/olpc: Reserve space for a string terminator
  wifi: ath12k: Reserve space for a string terminator
  dmaengine: xilinx: dpdma: Reserve space for a string terminator

 drivers/dma/xilinx/xilinx_dpdma.c                   | 2 +-
 drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c | 2 +-
 drivers/platform/olpc/olpc-ec.c                     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.34.1

