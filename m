Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36940 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2DVTup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 15:50:45 -0400
Received: by wejx9 with SMTP id x9so7059357wej.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 12:50:44 -0700 (PDT)
From: Zefir Kurtisi <zefir.kurtisi@gmail.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, achadd@qca.qualcomm.com,
	chunkeey@googlemail.com, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 1/4] ath9k: set detector DFS domain in reg notifyer
Date: Sun, 22 Apr 2012 21:50:20 +0200
Message-Id: <1335124223-15439-2-git-send-email-zefir.kurtisi@gmail.com> (sfid-20120422_215052_737962_8AD043EA)
In-Reply-To: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com>
References: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zefir Kurtisi <zefir.kurtisi@neratec.com>


Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f9130f7..6c4153c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -298,6 +298,7 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_regulatory *reg = ath9k_hw_regulatory(ah);
+	struct dfs_pattern_detector *dfs_detector = sc->dfs_detector;
 	int ret;
 
 	ret = ath_reg_notifier_apply(wiphy, request, reg);
@@ -311,6 +312,9 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 		ath9k_ps_restore(sc);
 	}
 
+	if (dfs_detector != NULL)
+		dfs_detector->set_domain(dfs_detector, request->dfs_region);
+
 	return ret;
 }
 
-- 
1.7.4.1

