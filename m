Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10344D6C3F;
	Mon, 28 Sep 2026 14:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790607137; cv=none; b=ruQ07zHvvKLenRlO0bNfuimJNHSo5BFIb41dmqT0jvKPeV4/nOEhBMShs4fGXPBKe5/7Ujqkl95wDrmt1+VAdEV67Kq9iopzBl57htqA7N0dCDHMb5hsd1SIa0ZrFxhlXHcHBtMzyGOb+U5B86R98+i29qobYqOwPHMjfduvSX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790607137; c=relaxed/simple;
	bh=czPzeGqBE78GgZJtD3Z+3/89Y3HONQ8a1fZdS7JTIzs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M7SEsHfwM1ikRaKEXQLo6wIuuCSOELZI7IdGRkoDFFULxejica6QXPOyNZBm0TmGC8/bR59z6F27icUjAhKjXvt8kIpluNboT8RHzNZ/6tFqMFeAvj2Z7PMCys0nrvSf8uKyf1g40Dx6EvxrOYGJqUSCaAlCNUZKUuf6GLPfjCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LP/RlWEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LP/RlWEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E201F000FF;
	Mon, 28 Sep 2026 14:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790607135;
	bh=nTxf3g7MHfc46jtOlfQr/x3upd+z4/f4dUMPgxfxrHk=;
	h=From:To:Cc:Subject:Date;
	b=LP/RlWEYCcno73BsmdUCQ3MYvg9M5gY+QItkF6nEzp9DJgDTRP9s2iUvqDBaX9kcd
	 4EoSagQq2MiWMgiyQNdG30Llr4nwZRM5zEwiDKZmB5k5M36xeq8CMig5C/rSr/9cjl
	 /FKE/Fe/I4zBoiaqPeB3pFMiEWRwaIRR1JMReCwxyB9SRlyf77EHfWjAGw4qPctrwy
	 y1qGCGYO/kB8hDgmnTmWD32H4BtcLs27d1kvBMFkOER5zGsWfawOpuZAInXJGC6fmp
	 KEV77oNs0fGGmtzZjUq5QvP7M5Ip/hWhZGnj4QRL1ei89TIuE9rS0/3wP/xlc07AIj
	 AepHjXkeD5vwA==
From: Arnd Bergmann <arnd@kernel.org>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] wifi: mt76: mt7996: add NET_AIROHA dependency
Date: Mon, 28 Sep 2026 16:51:44 +0200
Message-ID: <20260928145210.3153783-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

MT7996E fails to link as build-in when NET_AIROHA=m:

WARNING: unmet direct dependencies detected for MT76_NPU
  Depends on [m]: NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_MEDIATEK [=y] && (NET_AIROHA_NPU [=y]=y [=y] || MT76_CORE [=y]=NET_AIROHA_NPU [=y]) && (NET_AIROHA [=m] || !NET_AIROHA [=m])
  Selected by [y]:
  - MT7996_NPU [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_MEDIATEK [=y] && MT7996E [=y] && (NET_AIROHA_NPU [=y]=y [=y] || MT76_CORE [=y]=NET_AIROHA_NPU [=y])
arm-linux-gnueabi-ld: drivers/net/wireless/mediatek/mt76/npu.o: in function `mt76_npu_init':
npu.c:(.text.mt76_npu_init+0x4c): undefined reference to `airoha_ppe_get_dev'
arm-linux-gnueabi-ld: npu.c:(.text.mt76_npu_init+0xf8): undefined reference to `airoha_ppe_put_dev'

Add another dependency to prevent this configuration, with an explicit
special case to allow the NPU to be used while the PPE code is stubbed
out with NET_AIROHA=n.

Fixes: 377aa17d2aed ("wifi: mt76: mt7996: Add NPU offload support to MT7996 driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I am not sure what the use case is for using only the NPU but not
the PPE code, and it would be good to add a comment near the
dependency to clarify this, or possibly skip the complexity and
just make it a hard dependency.
---
 drivers/net/wireless/mediatek/mt76/Kconfig        | 1 +
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index 2ca96e0527c0..a4ece38f938d 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -40,6 +40,7 @@ config MT792x_USB
 config MT76_NPU
 	tristate
 	depends on NET_AIROHA_NPU=y || MT76_CORE=NET_AIROHA_NPU
+	depends on NET_AIROHA=y || NET_AIROHA=n || MT76_CORE=NET_AIROHA
 
 source "drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig"
 source "drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig"
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig b/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
index 5742bce12fbb..3c51b402f44e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
@@ -17,5 +17,6 @@ config MT7996_NPU
 	bool "MT7996 (PCIe) NPU support"
 	depends on MT7996E
 	depends on NET_AIROHA_NPU=y || MT76_CORE=NET_AIROHA_NPU
+	depends on NET_AIROHA=y || NET_AIROHA=n || MT76_CORE=NET_AIROHA
 	select MT76_NPU
 	default n
-- 
2.53.0

