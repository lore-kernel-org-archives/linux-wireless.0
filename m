Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9733368AE;
	Wed, 22 Jul 2026 07:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704725; cv=none; b=Sr1Bq/XzPJaTeAAmrrElZW373juvHdYIJ24uXISG0eDFFTcXL/XdR/g4c+VHgoXh8CgeyJ9JxriLRrDGqtoWTD76mcnXE6GgZMyVbzv9X1BjeMvFgggMSjRss75p+Tpz91HASSWh7cf2q88+Zgnyh/lO+BkLRYitN6zR7T7Xj4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704725; c=relaxed/simple;
	bh=fLSGtZsON7nL7yf+kt0WVXI954fLzcEkoyWGDGIy5X8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BUwX3g3rcTTwuvgSmvFHZ8FR03vHVU1F2dzovS6zn+8bOcN1/ibxrQbOTUUzYUSGAXCQlMH++VrmgcpBXDycnXm4EMde4rZY0NtVgh/D1Y5yKOVxSffn9mYnQkHNNWmmCGY25p10d4gBrC+1E1lBxRgDXEM5U6aluOHankoXE1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8a6b84d8859d11f1aa26b74ffac11d73-20260722
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:edd9b56d-f9ce-4147-aad8-f905ddc6fe9c,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:fb1b893a5a2079ee1cbd47c7a68e7599,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|865|898,TC:nil,Content:0|15|50,EDM:5
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8a6b84d8859d11f1aa26b74ffac11d73-20260722
X-User: liujiajia@kylinos.cn
Received: from nature.lan [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liujiajia@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2046461325; Wed, 22 Jul 2026 15:18:30 +0800
From: Jiajia Liu <liujiajia@kylinos.cn>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jiajia Liu <liujiajia@kylinos.cn>
Subject: [PATCH] wifi: cfg80211: reg: add a newline in DFS debug message
Date: Wed, 22 Jul 2026 15:18:19 +0800
Message-ID: <20260722071819.22465-1-liujiajia@kylinos.cn>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a missing newline in the debug message in print_regdomain.

Signed-off-by: Jiajia Liu <liujiajia@kylinos.cn>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1e8214d6b6d8..75b46f22adf7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3792,7 +3792,7 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 		}
 	}
 
-	pr_debug(" DFS Master region: %s", reg_dfs_region_str(rd->dfs_region));
+	pr_debug(" DFS Master region: %s\n", reg_dfs_region_str(rd->dfs_region));
 	print_rd_rules(rd);
 }
 
-- 
2.53.0

