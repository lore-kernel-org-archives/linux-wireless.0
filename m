Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784066;
	b=jc+HIQs4LFnd/lPS6IdU1eR/+Pu4+ou7ndfOjCXPRlYUAyaBJ7JHpE79DwV9k+tmKY11
	 PDR4SjDE8Qogb2Ucw7XZCdMKyIiugOO1XJBhiE9V36cJeF+4KlqK/oHIKZf/HaoYDSzPg
	 tBO0cNGlic5Y1tyxSJK8yIjSkyF0TC5YsWaeFvC+adhWvJFaSWhu8yVX6EeqO11Uf0A/k
	 8N4wbkUwne/D/qeJhHdZIhQvtuC21casss3+VBFz+D9x+n6i4/GgYRgi8obezJVIdqKwh
	 +e8WOh6VKoNxsMJBR5Y6UBW0/XhiHsC7TuEgcr8tlZmfjcusvThwqealBPRYK6KCciA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784066;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-MTK;
	bh=6AB0aUftO+vEy/g2psH5+jOjb1/rV0ha7zr/Qi/8gcE=;
	b=g9vPL8SY0vK41SQDUDlRU4yI257ntLlSfbqhhu8VYHit7FZL8P1ufRSS7ZGIo51l2QfV
	 +hxDr5AAS8aQtEMxtwqbrHFA5rKBUqL54woTI3k48zBdtcbASTKtnEZbxIEGwJ/mzR6VW
	 hJsmm/HKkA6aFi8TOP3mThb1rProFkXCs5bZYWlFNer/lxIn97sahwISSIYg8nFQBKpXX
	 fabFSqRE8dsWr3Pcum8v/wA3KiXNb7t5TkuHaCK6kuJXr2NKpvW9Vby/1tO4xkE+4NZCc
	 V1sH/6w9anN6ry0LhXFBFNiGvr8nMQoLambi/frtDNr5zGxZ8uMENPYQbDfd47XvRWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=YlCByzyE;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609E2606A326
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 09:21:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 609E2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=YlCByzyE
X-UUID: 086e5f6ed83111f18dc8c9802ae25ab1-20261104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=6AB0aUftO+vEy/g2psH5+jOjb1/rV0ha7zr/Qi/8gcE=;
	b=YlCByzyEwHv+dBZM5cHnNcrKbEpVq95FyE+uye20jD7q7uk5dTVp1A4OEa78lxJvc2ua3molRuPc4RMca/TGFk1at5n9WExu2aCZHFN9fCo3x5kM7TRKu2CHJX8QnupIMomLTEHLe24dhbpioTXKqU9VjMilVg9xwSpBtwAfX1I=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:7a222dfe-aec9-4656-b88b-0d9a15d25d81,IP:0,U
	RL:0,TC:0,Content:25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:b0318ac,CLOUDID:eaf616ee-6961-456c-adce-6d277e14e6ad,B
	ulkID:nil,BulkQuantity:0,SF:102|136|836|865|888|898,TC:-5,Content:4|15|50|
	99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
	I:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 086e5f6ed83111f18dc8c9802ae25ab1-20261104
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1427352781; Wed, 04 Nov 2026 17:20:53 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 4 Nov 2026 17:20:51 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 4 Nov 2026 17:20:51 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <johannes@sipsolutions.net>
CC: <nbd@nbd.name>, <lorenzo@kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <Sean.Wang@mediatek.com>,
	<jb.tsai@mediatek.com>, <James-LY.Huang@mediatek.com>, james-ly huang
	<james-ly.huang@mediatek.com>
Subject: [PATCH 1/1] wifi: mac80211: don't coalesce a new ROC onto an expired one
Date: Wed, 4 Nov 2026 17:20:50 +0800
Message-ID: <20261104092050.1930716-1-jb.tsai@mediatek.com>
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

From: james-ly huang <james-ly.huang@mediatek.com>

ieee80211_coalesce_hw_started_roc() computed the remaining time of the
running ROC as

	remaining = cur_roc->start_time +
		    msecs_to_jiffies(cur_roc->duration) - now;

and merged the new request into it when the new duration fits. When the
running ROC is already over, that subtraction wraps around (unsigned),
the "fits" check passes, and the new request gets added behind a ROC
that will never produce another on_channel or expired event.

The expired-but-still-listed state is not rare at all: the driver's
ieee80211_remain_on_channel_expired() only queues the hw_roc_done work,
so until that work runs - the driver's UNI_ROC_ABORT round trip can
take tens of ms - every ROC on the list whose time is up stays listed
with started=true. A remain-on-channel / mgmt-TX request arriving in
that window hits exactly this path.

Check the ROC's end time explicitly with time_after_eq() and refuse to
coalesce once it has passed; compute the (now guaranteed positive)
remaining window from the same end time.

Signed-off-by: james-ly huang <james-ly.huang@mediatek.com>
---
 net/mac80211/offchannel.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 44808120ff51..a9cc802f68dc 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -529,7 +529,7 @@ ieee80211_coalesce_hw_started_roc(struct ieee80211_local *local,
 				  struct ieee80211_roc_work *cur_roc)
 {
 	unsigned long now = jiffies;
-	unsigned long remaining;
+	unsigned long end;
 
 	if (WARN_ON(!cur_roc->started))
 		return false;
@@ -540,12 +540,20 @@ ieee80211_coalesce_hw_started_roc(struct ieee80211_local *local,
 	if (!cur_roc->hw_begun && new_roc->duration > cur_roc->duration)
 		return false;
 
-	remaining = cur_roc->start_time +
-		    msecs_to_jiffies(cur_roc->duration) -
-		    now;
+	end = cur_roc->start_time + msecs_to_jiffies(cur_roc->duration);
+
+	/* The current ROC may already be over: the driver's
+	 * ieee80211_remain_on_channel_expired() only queues hw_roc_done,
+	 * so until that work runs the ROC stays on roc_list with
+	 * started=true and no remaining time. Coalescing onto it would
+	 * leave the new request queued behind a ROC that will not produce
+	 * another on_channel or expired event
+	 */
+	if (time_after_eq(now, end))
+		return false;
 
 	/* if it doesn't fit entirely, schedule a new one */
-	if (new_roc->duration > jiffies_to_msecs(remaining))
+	if (new_roc->duration > jiffies_to_msecs(end - now))
 		return false;
 
 	/* add just after the current one so we combine their finish later */
-- 
2.45.2

