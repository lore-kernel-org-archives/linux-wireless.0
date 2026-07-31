Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F64D489865;
	Fri, 31 Jul 2026 09:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785490711; cv=none; b=oyDYD4GMtvf3FgrBw+fza4OInqzLD8U4iJA++nEFVwC5RAVfoNg/nI93ZuLsww0xVXbnuASxLzBspM7pz3qb05nFI5Gqav9De9HbQhknbL0RA1vJV0BIsdmkaQXcw50SakeJ7DB/ZifGZ/HBP7ckizqpAHgJnQF86kXN/Y1nHFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785490711; c=relaxed/simple;
	bh=QanNbvs3EGG38UmKc4euVsSTKAvjuobUcMNzdZWvjNw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tS4QeQYrfnIh291iywG0NAYqAPyPN3QCrw3gI01yHvMkl34OgvHSkJkwi0NzHN/kCQfnvMShoyyB3OKDmbiWG6sv42KnNTAH5lze/sG2yawjzllxQoMko8HKZHb+09XopIFYbgVa9F+OpdBANOrJeB8CvMGmeUMci950b1RRAQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 92a7a8fc8cc311f1aa26b74ffac11d73-20260731
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d094bfa7-92a3-4945-9b07-ba45c770eee9,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:3c8b99839c04532afa33c58d0b1856f6,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 92a7a8fc8cc311f1aa26b74ffac11d73-20260731
X-User: gonglinkai@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <gonglinkai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1381001783; Fri, 31 Jul 2026 17:38:23 +0800
From: Linkai Gong <gonglinkai@kylinos.cn>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Linkai Gong <gonglinkai@kylinos.cn>
Subject: [PATCH] wifi: ath12k: fix channel list double-free on error paths
Date: Fri, 31 Jul 2026 17:38:16 +0800
Message-Id: <20260731093816.1771338-1-gonglinkai@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath12k_mac_setup_channels_rates() frees band channel arrays on failure
but either leaves the pointers non-NULL or clears the wrong band. Later
ath12k_mac_cleanup_unregister() frees the same pointers again.

Clear the correct sbands[].channels pointers after kfree(), including
a copy-paste bug that nulled 2 GHz after freeing 6 GHz channels.

Fixes: acc152f9be20 ("wifi: ath12k: combine channel list for split-phy devices in single-wiphy")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
---
 drivers/net/wireless/ath/ath12k/mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index a0928890671a..5468a8d2d5d5 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -14275,6 +14275,7 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
 					   sizeof(ath12k_6ghz_channels), GFP_KERNEL);
 			if (!channels) {
 				kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
+				ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
 				return -ENOMEM;
 			}
 
@@ -14325,7 +14326,9 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
 					   GFP_KERNEL);
 			if (!channels) {
 				kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
+				ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
 				kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
+				ar->mac.sbands[NL80211_BAND_6GHZ].channels = NULL;
 				return -ENOMEM;
 			}
 
@@ -14365,7 +14368,7 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
 					kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
 					ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
 					kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
-					ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
+					ar->mac.sbands[NL80211_BAND_6GHZ].channels = NULL;
 					kfree(channels);
 					band->channels = NULL;
 					return ret;
-- 
2.25.1

