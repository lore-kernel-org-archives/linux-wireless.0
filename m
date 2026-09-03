Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8FB42E420;
	Thu,  3 Sep 2026 08:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788423134; cv=none; b=AVMMWIov9tBU+S55aichNc+Y+NLKEd2fGGOplQUqVc0uike2qNXCi/w+UcN06sNKG3Ae/fEeW5nvtMimMDhPAWtBZxFU00FfzC3ZF529cgo8dWBtNsJufWo05Ej05C4awhbHJFIAuPMmGfY+l28ktT3cFWXQQpIho2A8xgY1AIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788423134; c=relaxed/simple;
	bh=MIHSYS07q4uwcFA4MbFu3S/olppq06bL+JWmRGhocLM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Gbl2AIqyAaHc4Zub+uRTv6CYPNiNwSXLEU8coGUKpu363MPvqX3qycJ1kjXHcIXCJctWtZzNd8JViF4Sx3JHsPjSuVPHqvdvV3VxY6vs+xFsKiI/oFoRpZ+ZEKKR2ZJjFO3bkPiPglgXYkPU0L/H6t6V1fqRQZJqOc4oqiElof8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 26314d1aa76f11f19a56ed5b684f684d-20260903
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:b09a396d-3e08-4346-a70f-dc2feb628c4c,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.19,REQID:b09a396d-3e08-4346-a70f-dc2feb628c4c,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:7db8b62,CLOUDID:ee3e79dd0a867c557cbd0d21772ae162,BulkI
	D:260903161207NA2A594Q,BulkQuantity:0,SF:17|19|66|78|102|127|850|865|898,T
	C:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 26314d1aa76f11f19a56ed5b684f684d-20260903
X-User: wangyan01@kylinos.cn
Received: from localhost.localdomain [(223.104.132.142)] by mailgw.kylinos.cn
	(envelope-from <wangyan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 695768317; Thu, 03 Sep 2026 16:12:04 +0800
From: Wang Yan <wangyan01@kylinos.cn>
To: chunkeey@googlemail.com
Cc: johannes.berg@intel.com,
	zilin@seu.edu.cn,
	wangyan01@kylinos.cn,
	linville@tuxdriver.com,
	Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: p54: fix incorrect frame length check in p54_find_ie()
Date: Thu,  3 Sep 2026 16:12:00 +0800
Message-Id: <20260903081200.267514-1-wangyan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In p54_find_ie(), mgmt is a pointer to struct ieee80211_mgmt, so
sizeof(mgmt) evaluates to the size of the pointer rather than the size
of the management frame header.

Use sizeof(*mgmt) instead so that the skb length is compared against
the actual size of the management frame header.

Fixes: 0ac0d6cedf61 ("p54: Move mac80211 glue code")
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
---
 drivers/net/wireless/intersil/p54/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index 57a62108cbc3..d3e1776174f9 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -76,7 +76,7 @@ u8 *p54_find_ie(struct sk_buff *skb, u8 ie)
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
 	u8 *pos, *end;
 
-	if (skb->len <= sizeof(mgmt))
+	if (skb->len <= sizeof(*mgmt))
 		return NULL;
 
 	pos = (u8 *)mgmt->u.beacon.variable;
-- 
2.25.1

