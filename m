Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CCF258EFF;
	Tue, 11 Aug 2026 02:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786413938; cv=none; b=YxHpmQ7snluXQUzG6NbG+G5opBkj3KXMuENkSsnAU2mqiyP9LQoEAljAVWchow7WYdsfYhP6Lr6Lo8A9pvND/Bjtq3KOOTHJaP1hhEUBoAJeQ7drrn7j1j1oLLrIykDQqYk9lzx/eTG0t6RUpU/dHpmDG1jtoJLC6Ypt70J6AIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786413938; c=relaxed/simple;
	bh=ofXuaBzBmwGzeurlSJmb9u1jCzaL+HocsTJqzYVgmqs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=C7A8hGA8c2qKLcdRkmmuZ4lIYXldVTsE+pE6xLjLs+0fKFQUj0IfYvssy1tXKlCPs1GhjinV3NJ5BQVO/uurSPbLYY0T1/TchplaPeuZ9L0HtvzoJ1MnjDXKUX6llclswJrdCfnZM73PRYIDSgcBBhPdu/CUdF+v2FLbC35uebE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1f68cba0952911f1aa26b74ffac11d73-20260811
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:7995a7f5-d21c-4e51-b97a-4df6af6f24c2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:ada4e8981b36a3b7121364e59c9c4544,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:-3|-100,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1f68cba0952911f1aa26b74ffac11d73-20260811
X-User: gonglinkai@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <gonglinkai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1834017646; Tue, 11 Aug 2026 10:05:27 +0800
From: Linkai Gong <gonglinkai@kylinos.cn>
To: jjohnson@kernel.org
Cc: vasanthakumar.thiagarajan@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com,
	baochen.qiang@oss.qualcomm.com,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Linkai Gong <gonglinkai@kylinos.cn>
Subject: [PATCH v2] wifi: ath12k: clear dangling channel pointers on error paths
Date: Tue, 11 Aug 2026 10:05:23 +0800
Message-Id: <20260811020523.387433-1-gonglinkai@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On failure, ath12k_mac_setup_channels_rates() frees band channel
arrays but leaves the pointers set, or clears the wrong band after a
copy-paste typo (6 GHz free paired with a 2 GHz NULL). Clear the
matching sbands[].channels pointer after each kfree().

Compile tested only.

Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
---
v2:
- reword commit message (dangling pointers + typo, not double-free)
- drop Fixes tag
- note compile tested only

v1: https://lore.kernel.org/all/20260731093816.1771338-1-gonglinkai@kylinos.cn/

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

