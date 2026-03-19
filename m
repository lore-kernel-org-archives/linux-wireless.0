Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC6140B6D1;
	Thu, 19 Mar 2026 22:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773959093; cv=none; b=ARKmlMgzjn/+c8ZpIGAvfr1wwfdCy5Qv9CV//NQF3mr2kQPzRHp6MlUVrBf5T0ohF4a8gQMScSk6tk1Vjky3EAqfzfSy1SAEAl5HbOPW2c2ylYQbo3UposjevjS4t1hPbHuDhtzK4Blxi0uUYHynBYBDKxpg2tOKIGUlska5DR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773959093; c=relaxed/simple;
	bh=PYlAslJCMZr5+HVdvaUdUa19VFxbM+K5DE/+iCdWcok=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc:
	 In-Reply-To:References; b=I2jWTVfPLnyBDBjtPL8bS4gUP5IWpmKWc++yUmSJwqapFHBF48SFVhK64q/r7eR4S02sfut5XXswFDPViuQUzazWiYUx6fjG2WyaFc+NW6J5az6EpkInCAUJuFvteIEqCELCGtk8DSJjOfm5Epps9AWdsVhm6L3VoR8fqfEKOrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jetm.me; spf=pass smtp.mailfrom=jetm.me; dkim=pass (2048-bit key) header.d=jetm.me header.i=@jetm.me header.b=cevtMucL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=w+yXR61z; arc=none smtp.client-ip=202.12.124.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jetm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jetm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jetm.me header.i=@jetm.me header.b="cevtMucL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="w+yXR61z"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id ECD951300161;
	Thu, 19 Mar 2026 18:24:44 -0400 (EDT)
Received: from phl-imap-07 ([10.202.2.97])
  by phl-compute-02.internal (MEProxy); Thu, 19 Mar 2026 18:24:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jetm.me; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773959084;
	 x=1773966284; bh=6BCjacgyBBQfzI6KlQ7yHr92rvcdU94u/TkCmemPomE=; b=
	cevtMucLzLJxleQXCszJxKVovnBj3gTno4K9Mb4qtvtRzxkuM4uJ7u8rXhfUGku0
	9L65v76WDbI1gUErykxR/V02Op59YKX2ZKCwM5+AscDnjFjPmSyP5RGMi+MYuQO+
	tbw0VKnjXQ4mu9hyCDjlcQ/vhKvWaPBmofgZ/S+zsfDv38Rgt0GxWixJTXghGs41
	fBxTZJDKq3jpZfiDZ9yzofxePXKLdsXhw1WGQTMf7QUEG11VJsvSz3z3zHY1P174
	w4109WvPQN8TnicmVm5rR3tQ3z/cBYoHuhbSKDmGmAC4NL09d27ocX3VGDdHUcBq
	xxqSo21J2wFkHpTaDLkNKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773959084; x=
	1773966284; bh=6BCjacgyBBQfzI6KlQ7yHr92rvcdU94u/TkCmemPomE=; b=w
	+yXR61zsxbWkpFV0EjrBNFwIXp1/d7/L95Lfb1nzZNmexQaFlSLJ3vn/AorUvT7y
	66pt6jGS7297YvwRhR4av6fchVEVJGazdxbOB52TcM2Dp+ev1bavOoquRwFqfFQ+
	WTJOX5405maqnvzYdUpumoXAPO3u8xTlwEaNHp9qOSxHoyvXKQuAiX/1gosYGur9
	AL3pPWvcBHf2MGmO9qg9sD7eCabgf5mLkYdbTvtzyEMom314HiYPxRx3sM3RNm7s
	GPIjIONzyBazcmzQFjs9zfwJrJz6OBkWhvqhkGZfiEJM23pT3CnEMwgxgXgo5EsR
	5F8RRYoI+TLSYhytdLMTg==
X-ME-Sender: <xms:rHe8aczeiBXceQm1scrprSfdIpZDJuKDJNRLaBt-qepaW2l1UBI9pQ>
    <xme:rHe8abH4EEvdVl5RZYMTq_WStWQs1bFH4YZXLPPqPKX3EUTIiLYTFgRF7h5ZE0f8U
    V0zDXBUqN9_DTDI7S2BURoyEoLMPNnrC5h8D9nYp50wP5a-E6LyANo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdekvddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepoffhfffugggtgffkvfevofgjfhesthekredtredtjeenucfhrhhomheplfgrvhhi
    vghrucfvihgruceofhhlohhsshesjhgvthhmrdhmvgeqnecuggftrfgrthhtvghrnhepve
    ektdfhffevuddtgfetieevtddvheduhfeggfekveejlefhleefieevueefiefhnecuvehl
    uhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepfhhlohhsshesjh
    gvthhmrdhmvgdpnhgspghrtghpthhtohepvddvpdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopegrnhhgvghlohhgihhorggttghhihhnohdruggvlhhrvghgnhhosegtohhllh
    grsghorhgrrdgtohhmpdhrtghpthhtohepfeduleefieefudesghhmrghilhdrtghomhdp
    rhgtphhtthhopehlohhonhhgrddtgidttdesghhmrghilhdrtghomhdprhgtphhtthhope
    grrhhivghlrdhrohhsvghnfhgvlhgurdejhedtsehgmhgrihhlrdgtohhmpdhrtghpthht
    oheptghhrghpuhhishgurghrihhogeesghhmrghilhdrtghomhdprhgtphhtthhopehgih
    hoshgrlheltdesghhmrghilhdrtghomhdprhgtphhtthhopehmrghtthhhihgrshdrsghg
    ghesghhmrghilhdrtghomhdprhgtphhtthhopehrrgguohhirdgthhhrihhssehgmhgrih
    hlrdgtohhmpdhrtghpthhtohepshgrmhhurdhtohhljhgrmhhosehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:rHe8aVj-2OgPzTNRPjVPJEMtMAQFmCu7c1-yC1OjuWMJ1eqmeRPt9A>
    <xmx:rHe8aXOyP_h8QPgn7NlBzRUuAEekfkLDYO1eMYdRFbe6swphwlYi1Q>
    <xmx:rHe8aZnFLSFpuTZJKX0Qe9y8p1fQmnerI8Z2Yh0ut4DTH3YwKQuLvQ>
    <xmx:rHe8aWef2SyUPsiT9hG2fbfleA_z3NXjpFgVO69zgL-rprXlo0yUig>
    <xmx:rHe8aVBA_YijLhGrF-ndlWy7SHO85xGuMGvdWqnHRP3jrqM-GRpsgT-u>
Feedback-ID: i9dde48b3:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A278C1EA006B; Thu, 19 Mar 2026 18:24:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
From: Javier Tia <floss@jetm.me>
Date: Thu, 19 Mar 2026 16:24:28 -0600
Subject: [PATCH v2 12/13] wifi: mt76: mt7925: enable low power support for
 MT7927
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260319-mt7927-wifi-support-v2-v2-12-d627a7fad70d@jetm.me>
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Deren Wu <deren.wu@mediatek.com>,
 Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 Marcin FM <marcin@lgic.pl>, Cristian-Florin Radoi <radoi.chris@gmail.com>,
 George Salukvadze <giosal90@gmail.com>, Evgeny Kapusta <3193631@gmail.com>,
 Samu Toljamo <samu.toljamo@gmail.com>,
 Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>,
 Chapuis Dario <chapuisdario4@gmail.com>,
 =?utf-8?q?Thibaut_Fran=C3=A7ois?= <tibo@humeurlibre.fr>,
 =?utf-8?q?=E5=BC=A0=E6=97=AD=E6=B6=B5?= <Loong.0x00@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2465; i=floss@jetm.me;
 h=from:subject:message-id; bh=PYlAslJCMZr5+HVdvaUdUa19VFxbM+K5DE/+iCdWcok=;
 b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBpvHeRc4cmYJPBln9OK9QdhGO7p49+QnY5d7Sib
 wETU9ysHtKJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCabx3kQAKCRC17sMLqGd3
 H8BJDACyBzfw/ms19DMpM9SYwG47V11JEsvTkPt0AFM5YZcG+7QowV3LhaRAryaBinvBHORFqNa
 rIWxqyzxSxaBQf0zipQC1ZiHIX/wk8BX1TXcAKDDJ8JFUUYu4XKiAUcuu/51wg16MgwTeoWj4l/
 IqRzMd6XoT3dZA5XUi1q5fTSM+eovVOTf3VtIq3ZsFDDzh+e0a4KaiHwj4+1LGs0R9F8lp2uYHY
 USH8k4KHIx0Ik1Pun3qYBpha1L9gIOSsKBirimhv/huaiks5U5qbFRWjHDHnxF6GjFdC9jUjAUz
 U9A/HEplrp9AsAmK0ptSc4JTySlsxDCG3N8HLO6sXh2KbDH3IWkYJaDFeuymJvM2L+XMoblv9Z4
 8UPLHiKtnEz9+lAnHZCtOfJ5Rv6rCVjkoCtiMcXsd8h14SHHlIUXvnbWE7nCQsiBOaXbjctTY1r
 OX7uA9QyaExri5SwZHrNdXIOSgqlmj5gVa8QGWaw85Qn+q5ExwuEbNx1gKqDG4LGKOP4M=
X-Developer-Key: i=floss@jetm.me; a=openpgp;
 fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
In-Reply-To: <20260319-mt7927-wifi-support-v2-v2-0-d627a7fad70d@jetm.me>
References: <20260319-mt7927-wifi-support-v2-v2-0-d627a7fad70d@jetm.me>

Enable runtime PM and deep sleep for MT7927 now that the DMA wake path
properly restores all MT7927-specific GLO_CFG bits (ADDR_EXT_EN,
CSR_LBK_RX_Q_SEL_EN, FW_DWLD_BYPASS_DMASHDL) via the DMA config
struct on every PM wake cycle.

Disable PCIe ASPM unconditionally for MT7927. The CONNINFRA power
domain and WFDMA register access are unreliable with PCIe L1 active,
causing throughput to drop from 1+ Gbps to ~200 Mbps. L0s savings are
negligible for a PCIe WLAN card, and mt76_pci_disable_aspm() handles
both device and parent bridge in one call.

Tested-by: Marcin FM <marcin@lgic.pl>
Tested-by: Cristian-Florin Radoi <radoi.chris@gmail.com>
Tested-by: George Salukvadze <giosal90@gmail.com>
Tested-by: Evgeny Kapusta <3193631@gmail.com>
Tested-by: Samu Toljamo <samu.toljamo@gmail.com>
Tested-by: Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>
Tested-by: Chapuis Dario <chapuisdario4@gmail.com>
Tested-by: Thibaut François <tibo@humeurlibre.fr>
Tested-by: 张旭涵 <Loong.0x00@gmail.com>
Signed-off-by: Javier Tia <floss@jetm.me>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 393d9f408b84..693e08f35d68 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -530,7 +530,13 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto err_free_pci_vec;
 
-	if (mt7925_disable_aspm)
+	is_mt7927_hw = (pdev->device == 0x6639 || pdev->device == 0x7927);
+
+	/* MT7927: CONNINFRA power domain and WFDMA register access are
+	 * unreliable with PCIe L1 active, causing throughput to drop
+	 * from 1+ Gbps to ~200 Mbps. Disable ASPM unconditionally.
+	 */
+	if (mt7925_disable_aspm || is_mt7927_hw)
 		mt76_pci_disable_aspm(pdev);
 
 	ops = mt792x_get_mac80211_ops(&pdev->dev, &mt7925_ops,
@@ -562,7 +568,6 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
 	dev = container_of(mdev, struct mt792x_dev, mt76);
 	dev->fw_features = features;
 	dev->hif_ops = &mt7925_pcie_ops;
-	is_mt7927_hw = (pdev->device == 0x6639 || pdev->device == 0x7927);
 	dev->irq_map = is_mt7927_hw ? &mt7927_irq_map : &irq_map;
 	dev->dma_config = is_mt7927_hw ? &mt7927_dma_cfg : &mt7925_dma_cfg;
 	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);

-- 
2.53.0

