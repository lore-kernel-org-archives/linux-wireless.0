Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40863 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaHVPJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 11:09:43 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 1/8] ath9k: Add a debug level for channel context
Date: Fri, 22 Aug 2014 20:39:24 +0530
Message-Id: <1408720171-9765-2-git-send-email-sujith@msujith.org> (sfid-20140822_170945_448234_EC8AA905)
In-Reply-To: <1408720171-9765-1-git-send-email-sujith@msujith.org>
References: <1408720171-9765-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h        | 1 +
 drivers/net/wireless/ath/ath9k/init.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index fd9e530..c1a4ade 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -261,6 +261,7 @@ enum ATH_DEBUG {
 	ATH_DBG_MCI		= 0x00008000,
 	ATH_DBG_DFS		= 0x00010000,
 	ATH_DBG_WOW		= 0x00020000,
+	ATH_DBG_CHAN_CTX	= 0x00040000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 39419ea..76771f3 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -778,6 +778,8 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			hw->chanctx_data_size = sizeof(void *);
 			hw->extra_beacon_tailroom =
 				sizeof(struct ieee80211_p2p_noa_attr) + 9;
+
+			ath_dbg(common, CHAN_CTX, "Use channel contexts\n");
 		}
 	}
 
-- 
2.0.4

