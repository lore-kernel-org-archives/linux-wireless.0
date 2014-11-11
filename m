Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51446 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaKKWfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 17:35:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k_htc: remove return of value in empty definintion of ath9k_htc_deinit_debug
Date: Tue, 11 Nov 2014 17:23:49 -0500
Message-Id: <1415744629-6946-1-git-send-email-linville@tuxdriver.com> (sfid-20141111_233546_395834_3CCD2223)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/htc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index b34acdeb1f21..9dde265d3f84 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -629,7 +629,9 @@ int ath9k_htc_init_debug(struct ath_hw *ah);
 void ath9k_htc_deinit_debug(struct ath9k_htc_priv *priv);
 #else
 static inline int ath9k_htc_init_debug(struct ath_hw *ah) { return 0; };
-static inline void ath9k_htc_deinit_debug(struct ath9k_htc_priv *priv) { return 0; };
+static inline void ath9k_htc_deinit_debug(struct ath9k_htc_priv *priv)
+{
+}
 #endif /* CONFIG_ATH9K_HTC_DEBUGFS */
 
 #endif /* HTC_H */
-- 
1.9.3

