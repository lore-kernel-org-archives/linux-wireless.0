Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793697001;
	b=skydbfh91sZiiMkK2ZDCizoTvCX65BIc2Atth/kJPaWZ2gQ2DPf7qhVK50kanOxISoA6
	 /dBns0tPihqiiooqEPbyTzov32JrI+OKbaMloicRJgtG6DCd7R9YZ0xntVHK8vJBeyTMG
	 Fp4rIr8m/fwUZI+tnSdrNI10sgSFQfZ6XfeD4VOqac+JAg8HQYH5qn2MkjVIRQm0V0YSD
	 iWm8zi8xgOgxwQ3xsXPJapbINaKkZiglHATfub///n1NI2H/xl49AjlRzUX/oNcqVdlX4
	 WA9b8dGmHEg8PARMKaQ0YNERDu2XFlKljXRk8hWpdrJPX9p2zJ60Mt9I5DMcVZyDWLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697001;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-MTK;
	bh=v/FpDG427viY8CwqO1g7Q3Hr8Tb4FHtEPxku2gNFaSQ=;
	b=WuqKkq8R+zPEHGvPhpV6o0T9McWUGXfj9511vxtrKwXa4teQP1Ll5vRTWtqGQztnt9GB
	 mjYktxRj+VbBggVFGnXpCLkuV7d10Y0xI4QzRx0CIZwZZmwsAOExddwY2wc50oDnIfdYl
	 3qDhWuchcgGHZyuu+M9FZJ9AMxzjxchAP+d28n1/RTHjwx6LNlCehGGdo8uLMBD+nh6SS
	 C2xN1tCp9OniXJFofFI+b0znKZ6fx2oahG/1AV8aBuXRCLoUmIP822JeusJiiWkMMzbjh
	 Skx3R4E/qPwA9wYgFBvmsmIg77xY8wy1y1mTI7pj58se0ezIp4aQpPk7s7don6ZyWVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=TIkHMe7e;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B620606A327
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 09:10:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B620606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=TIkHMe7e
X-UUID: 56875d66d76611f18dc8c9802ae25ab1-20261103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=v/FpDG427viY8CwqO1g7Q3Hr8Tb4FHtEPxku2gNFaSQ=;
	b=TIkHMe7e1JyNHMiLNxf4HSA9Y2qRZz5K07u9sGMV54isw22v1sFjv9yErRMkG/JXcS8E+6jSlioYDkJOvm6d5fO+rryopPkc9q/rjTx8Kw7OwjHWy+xgJc0XaJ4ZYYajm0OFNTj+yjivYu8ItMHqsRvvtix57v9/DcIWJLlaxGA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:24f3a8e0-f44c-458b-9252-3399bc780c11,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:07a00cee-6961-456c-adce-6d277e14e6ad,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 56875d66d76611f18dc8c9802ae25ab1-20261103
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 777112873; Tue, 03 Nov 2026 17:09:56 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 3 Nov 2026 17:09:55 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 3 Nov 2026 17:09:55 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <johannes@sipsolutions.net>
CC: <nbd@nbd.name>, <lorenzo@kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <Sean.Wang@mediatek.com>,
	<jb.tsai@mediatek.com>, <Evan-ym.Li@mediatek.com>, Yin-Ming Li
	<evan-ym.li@mediatek.com>, Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH] wifi: mac80211: drain TXQ wake tasklet before freeing hardware
Date: Tue, 3 Nov 2026 17:09:53 +0800
Message-ID: <20261103090953.1148722-1-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
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
Content-Type: text/plain
X-MTK: N

From: Yin-Ming Li <evan-ym.li@mediatek.com>

Driver queue wakeups schedule wake_txqs_tasklet asynchronously. Stopping
the driver work that issued a wakeup does not wait for this tasklet, and
ieee80211_unregister_hw() does not drain it.

Drain the tasklet in ieee80211_free_hw(), before destroying the local
mutex and releasing the hardware allocation. Drivers must stop their
asynchronous producers before calling ieee80211_free_hw(); this drain
waits for a tasklet those producers have already scheduled. Using the
final free boundary also covers deferred wakeups scheduled while the
driver finishes bus teardown after ieee80211_unregister_hw() returns.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Yin-Ming Li <evan-ym.li@mediatek.com>
---
 net/mac80211/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f996e15e3d9e35cacddedf482a34c40c587d3e52..086b9ca3485398b4ef2ff60c3f9387dd909a8008 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1755,6 +1755,9 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 	struct ieee80211_local *local = hw_to_local(hw);
 	enum nl80211_band band;
 
+	/* Driver callbacks have stopped; drain their deferred TXQ wakeups. */
+	tasklet_kill(&local->wake_txqs_tasklet);
+
 	mutex_destroy(&local->iflist_mtx);
 
 	idr_for_each(&local->ack_status_frames,
-- 
2.43.0
