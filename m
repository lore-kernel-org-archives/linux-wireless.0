Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394F022FDE6
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 09:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785921862; cv=none; b=NU+AG1zaWZZfy5+TmgKNE8t2BlYfYRM7hRv44IHLzMsQrQrHhk+9DRdO/tp8Jv0aofPnPeOMfucyElMyzmY9KyGqs+HI6R6Hp5yKrPoJfr8/dHMgLLjLWc8+Q+6hiOIhiXbdCacHlYey7RkWrdogvxbnkfUaS0ohHHMQLhAA9/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785921862; c=relaxed/simple;
	bh=8lVo8otnFlDKZz+FYMzTxUmqORNMnciN27g6cbuJeDA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Nm60440/Cna8QxCaB2svqAgZDKMKh5A4IcbiMtUlaAQ05Fhpooo68zYYnettbhwYyBnqoy26oFQDo76ZR5aHfzDj4KSUfkYMBwIzcvPpKXWBwYAFRTe3tlg4Db9cg0qpInFpwNnRTlwVSZYhLE2V1LIBaSImr6POB4hnbNRgUzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=l1yxXGuS; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="l1yxXGuS"
X-UUID: 6b95bd6890af11f1b1788b6acf885367-20260805
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=3GSE1NgwkA5p3F58tN4CaqTO9EWZqthxiM5xWRmvUAU=;
	b=l1yxXGuSLfU0mU47mdCYEgO6tRcbiBZ1Ppgd2FNlp32wY/+noOB7o+IZHo0yIzzlB9CO8at0dBBlxVOW/Zl2TxU9sgJClzOZE0yqQbM5ItGJsUf6kNhomNK4SpSqadvsgCjVXASbLGmlZIZWxE+PHapwey0nxMyYGiJGDcjB2RI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d4c4c805-d07a-436f-8ae1-256c0d6a9ff1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:9d761e29-e704-4a93-91c1-f411bcd0f018,B
	ulkID:nil,BulkQuantity:0,SF:102|136|836|865|888|898,TC:-5,Content:0|15|50|
	99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6b95bd6890af11f1b1788b6acf885367-20260805
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1516359898; Wed, 05 Aug 2026 17:24:12 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 5 Aug 2026 17:24:11 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 5 Aug 2026 17:24:11 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <ck.chang@mediatek.com>,
	<eason.lai@mediatek.com>
Subject: [PATCH v1] wifi: mt76: mt7925: Fix reset panic by removing MT7925 irq mask config on tx done
Date: Wed, 5 Aug 2026 17:24:09 +0800
Message-ID: <20260805092409.1489401-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: "ck.chang" <ck.chang@mediatek.com>

Fix a bug that cause kernel panic when trigger reset.
When reset, reference irq mask and disable napi, but 7925 do not enable tx done napi since dma layout config, cause dereference null pointer in napi_disable function

[  133.383988] BUG: kernel NULL pointer dereference, address: 0000000000000a40
[  133.383993] #PF: supervisor write access in kernel mode
[  133.383994] #PF: error_code(0x0002) - not-present page
[  133.383996] PGD 0 P4D 0
[  133.383998] Oops: Oops: 0002 [#1] SMP NOPTI
[  133.384001] CPU: 2 UID: 0 PID: 457 Comm: kworker/u48:5 Tainted: G S         OE       6.17.0-061700-generic #202509282239 PREEMPT(voluntary)
[  133.384003] Tainted: [S]=CPU_OUT_OF_SPEC, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
[  133.384004] Hardware name: HP HP EliteBook 840 14 inch G10 Notebook PC/8B41, BIOS V70 Ver. 01.03.00 10/26/2023
[  133.384005] Workqueue: mt76 mt7925_mac_reset_work [mt7925_common]
[  133.384014] RIP: 0010:mutex_lock+0x1c/0x50
[  133.384017] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb e8 9e d1 ff ff 65 48 8b 15 ae 4d 9e 01 31 c0 <f0> 48 0f b1 13 75 10 48 8b 5d f8 c9 31 c0 31 d2 31 ff c3 cc cc cc
[  133.384018] RSP: 0018:ffffcf68009c3d60 EFLAGS: 00010246
[  133.384020] RAX: 0000000000000000 RBX: 0000000000000a40 RCX: 0000000000000000
[  133.384021] RDX: ffff8b25d250aa00 RSI: 0000000000000000 RDI: 0000000000000000
[  133.384022] RBP: ffffcf68009c3d68 R08: 0000000000000000 R09: 0000000000000000
[  133.384023] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffc1de2880
[  133.384024] R13: ffff8b25ca0b2040 R14: ffff8b25ca0b2900 R15: 0000000000000000
[  133.384025] FS:  0000000000000000(0000) GS:ffff8b2da5b80000(0000) knlGS:0000000000000000
[  133.384026] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.384027] CR2: 0000000000000a40 CR3: 0000000158438002 CR4: 0000000000f72ef0
[  133.384028] PKRU: 55555554
[  133.384029] Call Trace:
[  133.384030]  <TASK>
[  133.384033]  napi_disable+0x1d/0x50
[  133.384037]  mt7925e_mac_reset+0x327/0x420 [mt7925e]
[  133.384039]  mt7925_mac_reset_work+0x9a/0x1a0 [mt7925_common]
[  133.384042]  process_one_work+0x18a/0x370
[  133.384045]  worker_thread+0x33a/0x480
[  133.384048]  ? __pfx_worker_thread+0x10/0x10
[  133.384050]  kthread+0x108/0x220
[  133.384052]  ? __pfx_kthread+0x10/0x10
[  133.384053]  ret_from_fork+0x121/0x140
[  133.384055]  ? __pfx_kthread+0x10/0x10
[  133.384057]  ret_from_fork_asm+0x1a/0x30
[  133.384060]  </TASK>

Fixes: 5c2da0751454 ("wifi: mt76: mt7925: replace shared rx irq masks with per-chip definitions")
Signed-off-by: ck.chang <ck.chang@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c  | 1 -
 drivers/net/wireless/mediatek/mt76/mt7925/regs.h | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 02ef09dd797d..d2c0a78ae9f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -493,7 +493,6 @@ static const struct mt792x_irq_map mt7925_irq_map = {
 		.all_complete_mask = MT7925_INT_RX_DONE_ALL,
 		.data_complete_mask = MT7925_INT_RX_DONE_DATA,
 		.wm_complete_mask = MT7925_INT_RX_DONE_WM,
-		.wm2_complete_mask = MT_INT_RX_DONE_WM2,
 	},
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/regs.h b/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
index ab6c33b4a180..e040dff321dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
@@ -48,8 +48,7 @@
 #define MT7925_INT_RX_DONE_DATA		HOST_RX_DONE_INT_ENA2
 #define MT7925_INT_RX_DONE_WM		HOST_RX_DONE_INT_ENA0
 #define MT7925_INT_RX_DONE_ALL		(MT7925_INT_RX_DONE_DATA | \
-					 MT7925_INT_RX_DONE_WM | \
-					 MT_INT_RX_DONE_WM2)
+					 MT7925_INT_RX_DONE_WM)
 
 #define MT7927_INT_RX_DONE_DATA		MT7927_RX_DONE_INT_ENA4
 #define MT7927_INT_RX_DONE_WM		MT7927_RX_DONE_INT_ENA6
-- 
2.45.2

