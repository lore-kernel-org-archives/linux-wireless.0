Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33957 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab0GTRaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 13:30:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: correct sparse identified endian bug in ath_paprd_calibrate
Date: Tue, 20 Jul 2010 13:16:43 -0400
Message-Id: <1279646203-23792-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath9k/main.c:282:26: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath9k/main.c:282:26:    expected restricted __le16 [usertype] duration_id
drivers/net/wireless/ath/ath9k/main.c:282:26:    got int

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d45cf0b..6cf0410 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -279,7 +279,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 	hdr = (struct ieee80211_hdr *)skb->data;
 	ftype = IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC;
 	hdr->frame_control = cpu_to_le16(ftype);
-	hdr->duration_id = 10;
+	hdr->duration_id = cpu_to_le16(10);
 	memcpy(hdr->addr1, hw->wiphy->perm_addr, ETH_ALEN);
 	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
 	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
-- 
1.7.1.1

