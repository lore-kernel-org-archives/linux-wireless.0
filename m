Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D743B841F;
	Mon,  7 Sep 2026 02:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749414; cv=none; b=OSlwi6O/lcot1vEFCngjoblOnW68MrTmRju38ctCiMKxpMM6uywdJ7amGAUxhKRa+Ol4AZsp3XsfAhPp2/nklHrCyi/swZN8vVlNoy11fP0DZyBdxFGZ8eMBhGhxyxVXRuFZNJynkES2TKZ+hluDZJlLgbOtHLf23GF7CRs8cC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749414; c=relaxed/simple;
	bh=1s4OSi2LE+BFdFYaO9yRObeMq88VPgaAIPcbeMtdpro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cfy9x53xYb/WIG5CVMqGIVtdJWVnXmXkTWdIOarYYm8JGgIdhZj6BQl0+XjJhhA4kgbQPjFLD8Oek7y0WTRnytSI+qGyvFplSTUH54nIt3NtIcxdMxzjdHFlqQNPnTLhfd2JZ07cuor+wzfDZ1LTbzPvyx62wuhxRbzQClyYaO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d4198218aa6611f19a56ed5b684f684d-20260907
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2f6105a8-1d59-413f-b8ee-9d267bddb61b,IP:15,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:2f6105a8-1d59-413f-b8ee-9d267bddb61b,IP:15,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:705ee84b4401f5608ee74b689a9c3fec,BulkI
	D:2609071050071KJSCARE,BulkQuantity:0,SF:17|19|66|78|81|82|102|127|850|865
	|898,TC:nil,Content:0|15|50|99,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d4198218aa6611f19a56ed5b684f684d-20260907
X-User: wangyan01@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <wangyan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 444161527; Mon, 07 Sep 2026 10:50:04 +0800
From: Wang Yan <wangyan01@kylinos.cn>
To: chunkeey@gmail.com
Cc: johannes.berg@intel.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linville@tuxdriver.com,
	wangyan01@kylinos.cn,
	zilin@seu.edu.cn
Subject: [PATCH v2] wifi: p54: remove redundant length check in p54_find_ie()
Date: Mon,  7 Sep 2026 10:49:41 +0800
Message-Id: <20260907024941.302630-1-wangyan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <bdca394f-0371-45ad-bfee-b044444ad724@gmail.com>
References: <bdca394f-0371-45ad-bfee-b044444ad724@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The check in the while loop condition and the bounds check within the
loop body guarantee that "pos" is never returned unless the IE is still
within skb->len.

Additionally, sizeof(mgmt) evaluates to the pointer size rather than
the actual management frame header size, making the check incorrect as
well.

Therefore, removing the redundant check is the right fix.

Fixes: e5ea92a7528d ("p54: AP & Ad-hoc testing")
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
---
 drivers/net/wireless/intersil/p54/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index 57a62108cbc3..8f921dc4ecd3 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -76,9 +76,6 @@ u8 *p54_find_ie(struct sk_buff *skb, u8 ie)
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
 	u8 *pos, *end;
 
-	if (skb->len <= sizeof(mgmt))
-		return NULL;
-
 	pos = (u8 *)mgmt->u.beacon.variable;
 	end = skb->data + skb->len;
 	while (pos < end) {
-- 
2.25.1

