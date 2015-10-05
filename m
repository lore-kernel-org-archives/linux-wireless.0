Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-138.163.com ([123.125.50.138]:37009 "EHLO m50-138.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbbJEMqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 08:46:33 -0400
From: Geliang Tang <geliangtang@163.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ath6kl: drop unlikely behind WARN_ON()
Date: Mon,  5 Oct 2015 20:46:12 +0800
Message-Id: <61de1b17c432479ccded41edfb553e2d20ebf8ae.1444048783.git.geliangtang@163.com> (sfid-20151005_144653_996554_B200F9D1)
In-Reply-To: <87si5p4l09.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARN_ON() already contain an unlikely compiler flag. Drop it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
Changes in v2:
 - change subject prefix to ath6kl.
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a511ef3..fe38fc4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2217,7 +2217,7 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 
 	/* enter / leave wow suspend on first vif always */
 	first_vif = ath6kl_vif_first(ar);
-	if (WARN_ON(unlikely(!first_vif)) ||
+	if (WARN_ON(!first_vif) ||
 	    !ath6kl_cfg80211_ready(first_vif))
 		return -EIO;
 
@@ -2297,7 +2297,7 @@ static int ath6kl_wow_resume(struct ath6kl *ar)
 	int ret;
 
 	vif = ath6kl_vif_first(ar);
-	if (WARN_ON(unlikely(!vif)) ||
+	if (WARN_ON(!vif) ||
 	    !ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
-- 
2.5.0


