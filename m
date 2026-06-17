Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEC93B9D99
	for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2026 07:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781680393; cv=none; b=c9oMW/XSuqZ3rT6Wr4trefIpS4kWPgmVGtxlf4TJa94VgB66OX1B+LTCOzGesZne0CM2TYFm57Fx37pxR8PR/0kWZNma6ylxvEKlysJOlnW4S8PnpM4CF+qky5HKC435Gt9oMPHPO4vifrExB1gfFFH5McKbF76Vq2hKkQi0UzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781680393; c=relaxed/simple;
	bh=ft2Hbv8CPBwP0g7Qfgp6aPF/EtYL8Avnxnv6hTm0qdU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sLuf4Y0kTc7NWm30XJZK4zkdCI1hQvpGQ3aQsNEo6NdAErF6enihdrP7LmMOrGp/h/ns+CTPl7EXlsuLlh7uQK94qKrdiF9FxyhJI08N7JenRb1XFwK+IrcVYVc8aKn4q3U7L/5aG0DRVPF9bSv6i5Hv8mPHwEnsE6YgbJokX1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Bkwh7i6r; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Bkwh7i6r"
X-UUID: fd43f44c6a1b11f18dc8c9802ae25ab1-20260617
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=7pPEGyznt8zx2nGwkMD/hEWm9QWv8j1adOO6kvRVOjs=;
	b=Bkwh7i6rMNcmZblWvugNi7tpDlDiGHrjMQcgBzF95XNunWedgOugmwBd8TpP6/4n/AX06+Xf4gfsBoKLgbvaiZHqMltiYMLuhqgIcQ3iEuIePvrYXriyZNU0tqY3CLP0L3VKUfUcr7tHh1nXWVyNxXjVGmIAfBY6suYyKUoha3o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:ba811ce4-c871-44ed-831d-713cec349853,IP:0,U
	RL:0,TC:0,Content:-5,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-25
X-CID-META: VersionHash:d497b38,CLOUDID:4f1221c0-67b2-4eaa-9791-4df3e7abe4cc,B
	ulkID:nil,BulkQuantity:0,SF:102|136|836|865|888|898,TC:-5,Content:0|15|50,
	EDM:-19|2,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fd43f44c6a1b11f18dc8c9802ae25ab1-20260617
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 41618854; Wed, 17 Jun 2026 15:13:07 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Jun 2026 15:13:06 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 17 Jun 2026 15:13:06 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Deren.Wu@mediatek.com>, <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jared.huang@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7925: update clc before setting sar power table
Date: Wed, 17 Jun 2026 15:13:05 +0800
Message-ID: <20260617071305.1808394-1-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: "Jared.Huang" <jared.huang@mediatek.com>

Fix the power table update sequence to ensure CLC is loaded before
setting SAR power table.

The firmware requires CLC baseline to be established first
to properly calculate the final power limit as min(clc_limit, rate_limit,sar_limit).

Fixes: 9557b6fe0c8b ("wifi: mt76: mt7925: refine the txpower initialization flow")
Signed-off-by: Jared.Huang <jared.huang@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index a9059866b701..afb2b473bef7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1824,9 +1824,15 @@ static int mt7925_set_sar_specs(struct ieee80211_hw *hw,
 	int err;
 
 	mt792x_mutex_acquire(dev);
+	err = mt7925_mcu_set_clc(dev, dev->mt76.alpha2,
+			 dev->country_ie_env);
+	if (err < 0)
+		goto out;
+
 	err = mt7925_set_tx_sar_pwr(hw, sar);
-	mt792x_mutex_release(dev);
 
+out:
+	mt792x_mutex_release(dev);
 	return err;
 }
 
-- 
2.45.2

