Received: from e234-50.smtp-out.ap-northeast-1.amazonses.com (e234-50.smtp-out.ap-northeast-1.amazonses.com [23.251.234.50])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D953E7BCE;
	Fri, 17 Jul 2026 11:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784286022; cv=none; b=Bs+zxpRZgd3cC0B+XLX3KvZr9hHseDXYhzck8SY0wXSNBUh1OSqWZ1J+wtej7t2AME4h9FY936D63ISDa7efZ8hh2INLPq27HV1JpEKPTGmKedJ8p6UIsEzSZI08U+asihv0IhQltp1MS9txfKlMcz2WY0QEQ490Gi5Tia2lxR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784286022; c=relaxed/simple;
	bh=2Toci5uqsLuvPPWzuz/cs1WrKdJj/X8EFzQGQ0alrm0=;
	h=From:To:Cc:Subject:Message-ID:Date:MIME-Version:Content-Type; b=qkwHYeBSsO9g45Cd2ddddY4IGHBxaaX1WTg/TqbPRDOyD6/GD6LzrAyzd2gIGqphwohW4Dxod1nRRd2iZ4Nhq7RePwlvHYWwyPwL3SLilughJkWE8Dq0S3rN2SS5BwMd4z5pC/ASCWaMtzfDCamCb/zVN49remh1QjmTjcKm+Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=clipsneko.cc; spf=pass smtp.mailfrom=send.clipsneko.cc; dkim=pass (1024-bit key) header.d=clipsneko.cc header.i=@clipsneko.cc header.b=X4ctrmHd; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=EMi4x7xw; arc=none smtp.client-ip=23.251.234.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=clipsneko.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.clipsneko.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=clipsneko.cc header.i=@clipsneko.cc header.b="X4ctrmHd";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="EMi4x7xw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=clipsneko.cc; t=1784286008;
	h=From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=2Toci5uqsLuvPPWzuz/cs1WrKdJj/X8EFzQGQ0alrm0=;
	b=X4ctrmHd2UoeBcwe4PM2rJd4QTPGgnwSMa5Cj2oP7lwk5Bgno3QkEyY8hXCbmVrp
	MfCFc22fW4PgIOLe2qD1/ifdg39sINJKwCv7Vxr7ksfMrln8LVSFBwxu0l9I07B82dL
	yUvh6chRGvUAC51AnAsaKvqGbOQRbSuZUGE7Fjsw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=zh4gjftm6etwoq6afzugpky45synznly; d=amazonses.com; t=1784286008;
	h=From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=2Toci5uqsLuvPPWzuz/cs1WrKdJj/X8EFzQGQ0alrm0=;
	b=EMi4x7xwzuiUd96Y7/C2tDoycsBLOXyzZIzxIjmlo6JWIt4gIs7IiWakiZyuQ0dE
	5ygiHYVP7rMP4i1SpZR6kQ5NMvbnvzkeSVsf6vpoAQfjrhwsAKk+TCyegsBrUVn52oQ
	AlhuWcHkEl9tPp36/T5pu2bp92zI7hrqRQwAFfMI=
X-Mailer: git-send-email 2.55.0
From: Goliath Zhu <goliath.zhu@clipsneko.cc>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com, 
	shayne.chen@mediatek.com, sean.wang@mediatek.com, 
	matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mediatek@lists.infradead.org, goliath.zhu@clipsneko.cc
Subject: [PATCH 0/2] wifi: mt76: fix RX NAPI teardown on mt7996 removal
Message-ID: <0106019f6fbbd2b3-deb608fb-9fee-4026-98b5-5b108c95e4af-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Jul 2026 11:00:08 +0000
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: :1.ap-northeast-1.T/9jWCDXa31y4gauYStyPOpWTrkJmzALuy1iq6HUX1VjlgPUmzq7ZFI3EvLLZ39jJzv+2I2PP/uhCYcS7tWi4X9gcnDJGZZVVULSu7C54EK8m7rG19VNcAtmWQSUeF+Ydw79jCgmJ2QuxiKzKA17O4fInWrH2kml2UpMwmQGC6+Ow2RWdTIMP19sAecDaYp3:1.ap-northeast-1.tL27A1JIpKR2Y51a8BkHZBekDcSR82jwOhKrSwgRw2U=:AmazonSES
X-SES-Outgoing: 2026.07.17-23.251.234.50

Fix two RX NAPI teardown issues in the mt7996 removal path.

The first patch disables the RX NAPI instances before the common DMA
cleanup deletes them. This is the RX counterpart of commit 78ab4be54953
("wifi: mt76: disable napi on driver removal"), which fixed the same
warning for TX NAPI.

The second patch fixes a regression introduced by commit 6b470f36616e
("wifi: mt76: Fix memory leak destroying device"). Keep visiting WED RRO
queues to release their page pools, but do not delete NAPI instances
which were never registered while WED is active.

Build-tested with CONFIG_MT7996E=m, CONFIG_NET_MEDIATEK_SOC_WED=y and
W=1.

Goliath Zhu (2):
  wifi: mt76: mt7996: disable RX NAPI on driver removal
  wifi: mt76: skip NAPI deletion for WED RRO queues

 drivers/net/wireless/mediatek/mt76/dma.c         |  4 +++-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 11 +++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

base-commit: 58717b2a1365d06c8c64b72aa948541b53fe31eb
-- 
2.55.0
