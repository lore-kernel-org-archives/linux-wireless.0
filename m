Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A3347A0A9
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784128880; cv=none; b=Lye08TbcSkmLpJfi8aNxPPS4YibRqhIvcyylrPNs1ckkJVQfHxgBM71Gms/jcrpPn8hzBvbjlc3KKcu3URykMA6GuU/W0Uso1o6cSNfzIlkxnHp+Ry0FHbiXsGzWn5CwOc/sC2HQjnMOxr4G5YjOHii5W2H2KOToITw9PYkiemE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784128880; c=relaxed/simple;
	bh=aXD072FEnIHgF4SWBIyM+PiPgjDGjjhs9Xm1MTgvbJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DKwXRMQ7h6SssS13YO8kjRDGudrNKtm23YYymbA/Z0aMHgiTypBxuN2EWNAZ2Bmxq5Dd4prvThiOb5SnKAES+zj84JCOKJXwoz7Yx0z2wzKdvNMxYE0k7tSMZaLg0yKmAdnShhRgXb4PxO4kOq3G7ljuLs6dXoQPx49Me0XyMJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jz+t48Jb; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jz+t48Jb"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84830c774a0so1746366b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 08:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784128879; x=1784733679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MQZZDFFxqTDdSnsRY8wqJD42CyjhcA/Zlppkdex9wbI=;
        b=Jz+t48Jb7UoFRl9te5Og8jgzMDHBdWYko8VD0eJzn0jWes5rPcyG3AMQoFnp/TvKi7
         yKVL2oKOUjtdo07lyT0O0qVwUbEalESmZP5rQ4Fqwc50y79yqtngwq/fpe77iabvYned
         qRPbE271pJHz9puFszlj0VmfLexoa3HWJm49K4TSphAZ7Bc4Eetd8Iv1B6ahXpU/7ctR
         2hiSgYnkjK0UROzleGyhmQSef0Za4NAnylGopajxhC4Cx8OTRfHhDs+7xx6MHmZG0G4w
         VavPz4wRKNeZuZLON/uKxzHCIXOwZNrCcOvKJKa4TMaQoWyTfoT6Nh+BEREHLXwKo0Sz
         uvmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784128879; x=1784733679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MQZZDFFxqTDdSnsRY8wqJD42CyjhcA/Zlppkdex9wbI=;
        b=jHhdnh3rglfRtToz2upvZOvTFYvZivjcmm+vGNygcaOjoxoYPywAb+pJRrEdims7iC
         63eCGb0uYqdD0rBZ3FmDc+sANPb1Q8AnsJIz+ChxE83XkenQdWS8D8TRCNrDuRXOmd9s
         cHdtBnvckllYMofbLCDgGFVlXLQKKfbgDG/S2ea06ZR0zH2v9Uu/uNdzG1zbL83Ocv0Z
         WjKWjocYeXdVICxu1m2vIu96JlafF/m7WrBrZIIKvGuLLJbN5uHbl90hvfdZAyTQhARD
         vDCpCNJo7F7UdzvYs1eQvM6e2FrR+g3pJF/PvBFy3bmoWP71E1pxMREWisifz+eN3KMR
         Cfmw==
X-Forwarded-Encrypted: i=1; AHgh+RrgJ/EcIEmHXgifwZUbY/OySYCo4ov93V0S0DGP5r//NDyGb+PZIvlz1odjZk1WeoI58tA8ZgGYjw+CDoyi6w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyAToLGLrR1tBza7eEeBvawq+bBj7CXtH4WERM9Off+EJEAUjGy
	hUrwJp/OK2d/Aq5bXFyMCIz1nPkFolDPah6Cv90JATq/gxRHXKpUfDrF
X-Gm-Gg: AfdE7ckfbIe/hdjVSIJ8wdD/jaAOln2wigxrF7UHFoI2y5D0eE8dHl1l09TIhGF94FA
	VEgu8oFqbruasmwNJX6AUKATN8s/E2Xxsr8ymEqkrhfWnl73daxOjK4e+YAbeFH+HgtbhtI/2ry
	J+em/gpeg0tJ1q7Kv9nxtAetQSSAI0llsbI+X5DCRQfndNyifhLV9LjhxDTniCjw5I95gReS+17
	gEKc6JMGu63haLQcvu1HL5MvDf1YOj1avLyePUlcvbhCf8FMvhA0APh6+EJ6qKEIt0dPG8sEHtQ
	3BsrRb9Bgqxjlc1CyDNbo3UEnFk9hzte4fC7GQT6AFIRWjAomaqMkKfA6DrDQq2w7zdrFVq2dtk
	76OaCOqYOIOxg0tk2/wyE3MPKnucCswiTJhRTXZgorvd/G7uMsq8z9VfG+MVVQn2oirxT42WHcW
	d3dZYwBhZ0PMIhLeBQ5QZSNKpuWgV2+rr+l/Ds2/vI3F9KUDonfURc6w==
X-Received: by 2002:a05:6a00:b4a:b0:845:31a6:d84d with SMTP id d2e1a72fcca58-848896c3a47mr15383950b3a.7.1784128878556;
        Wed, 15 Jul 2026 08:21:18 -0700 (PDT)
Received: from DESKTOP-VNSSJ2S.lan (59-127-145-64.hinet-ip.hinet.net. [59.127.145.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a5c699440sm2268842b3a.34.2026.07.15.08.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 08:21:17 -0700 (PDT)
From: Zhi-Jun You <hujy652@gmail.com>
To: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com
Cc: shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Zhi-Jun You <hujy652@gmail.com>
Subject: [PATCH mt76 v2 1/2] wifi: mt76: wed: fix kernel panic on non-DBDC MT7986
Date: Wed, 15 Jul 2026 23:21:12 +0800
Message-ID: <20260715152113.553-1-hujy652@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In mt76_wed_init_rx_buf, it's hardcoded to use MT_RXQ_MAIN.
But for non-DBDC MT7986 MT_RXQ_BAND1 is used for RX data queue which
leads to kernel panic when attaching WED.

Use the correct RX queue by checking WED version and band_idx.

v2 and band 1 -> MT_RXQ_BAND1
Others -> MT_RXQ_MAIN

Kernel panic:

Unable to handle kernel access to user memory outside uaccess routines at virtual address 0000000000000000
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
Internal error: Oops: 0000000096000005 [#1]  SMP
CPU: 1 UID: 0 PID: 925 Comm: kmodloader Tainted: G           O        6.18.26 #0 NONE
Tainted: [O]=OOT_MODULE
Hardware name: Acer Connect Vero W6m (DT)
pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : page_pool_alloc_frag_netmem+0x1c/0x1bc
lr : page_pool_alloc_frag+0xc/0x34
sp : ffffffc081dab660
x29: ffffffc081dab660 x28: ffffffc081dabc60 x27: ffffff80091af040
x26: 0000008000000000 x25: ffffff80091a8898 x24: ffffff80091a5440
x23: 0000000000001000 x22: 0000000140000000 x21: ffffff80091a2040
x20: ffffff8003f1d780 x19: 0000000000000000 x18: 0000000000000020
x17: ffffffbfbf0ac000 x16: ffffffc080ee0000 x15: ffffff80049d47ca
x14: 000000000000037b x13: 000000000000037b x12: 0000000000000001
x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
x8 : ffffff8003f1d7c0 x7 : 0000000000000000 x6 : ffffff8003f1d780
x5 : 0000000000000680 x4 : 0000000000000000 x3 : 0000000000002824
x2 : 0000000000000000 x1 : ffffffc081dab71c x0 : 0000000000000000
Call trace:
 page_pool_alloc_frag_netmem+0x1c/0x1bc (P)
 page_pool_alloc_frag+0xc/0x34
 mt76_wed_init_rx_buf+0xf8/0x2ac [mt76]
 mtk_wed_start+0x79c/0x12ac
 mt7915_dma_start+0x274/0x63c [mt7915e]
 mt7915_dma_start+0x5b4/0x63c [mt7915e]
 mt7915_dma_init+0x49c/0x81c [mt7915e]
 mt7915_register_device+0x24c/0x530 [mt7915e]
 mt7915_mmio_probe+0x91c/0x1980 [mt7915e]
 platform_probe+0x58/0xa0
 really_probe+0xb8/0x2a8
 __driver_probe_device+0x74/0x118
 driver_probe_device+0x3c/0xe0
 __driver_attach+0x88/0x154
 bus_for_each_dev+0x60/0xb0
 driver_attach+0x20/0x28
 bus_add_driver+0xdc/0x200
 driver_register+0x64/0x118
 __platform_driver_register+0x20/0x30
 init_module+0x74/0x1000 [mt7915e]
 do_one_initcall+0x4c/0x1f8
 do_init_module+0x50/0x210
 load_module+0x15f8/0x1b10
 __do_sys_init_module+0x1a8/0x260
 __arm64_sys_init_module+0x18/0x20
 invoke_syscall.constprop.0+0x4c/0xd0
 do_el0_svc+0x3c/0xd0
 el0_svc+0x18/0x60
 el0t_64_sync_handler+0x98/0xdc
 el0t_64_sync+0x158/0x15c
Code: aa0003f3 a9025bf5 a90363f7 d2820017 (b9400000)

Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
---
Changes since RFC
- Replace single band with non-DBDC
---
 drivers/net/wireless/mediatek/mt76/wed.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/wed.c b/drivers/net/wireless/mediatek/mt76/wed.c
index ed657d952de2..f210a0c57d81 100644
--- a/drivers/net/wireless/mediatek/mt76/wed.c
+++ b/drivers/net/wireless/mediatek/mt76/wed.c
@@ -33,10 +33,15 @@ u32 mt76_wed_init_rx_buf(struct mtk_wed_device *wed, int size)
 {
 	struct mtk_wed_bm_desc *desc = wed->rx_buf_ring.desc;
 	struct mt76_dev *dev = mt76_wed_to_dev(wed);
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	struct mt76_txwi_cache *t = NULL;
+	struct mt76_queue *q;
 	int i;
 
+	if (wed->version == 2 && dev->phy.band_idx)
+		q = &dev->q_rx[MT_RXQ_BAND1];
+	else
+		q = &dev->q_rx[MT_RXQ_MAIN];
+
 	for (i = 0; i < size; i++) {
 		dma_addr_t addr;
 		u32 offset;
-- 
2.47.3

