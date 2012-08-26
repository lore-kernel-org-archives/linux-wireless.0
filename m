Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:35062 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2HZINL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 04:13:11 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH 1/2] ath9k_htc: allow coexistence of IBSS with other modes
Date: Sun, 26 Aug 2012 10:12:52 +0200
Message-Id: <1345968773-17166-1-git-send-email-ordex@autistici.org> (sfid-20120826_101324_957952_01A75CFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Practical tests shown that ath9k_htc devices allow an IBSS VIF to coexist with
VIF set up on other modes. This patch removes the check which block the creation
of any other VIF whenever an IBSS one is already present.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c32f6e3..c41d85f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1045,9 +1045,9 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 		return -ENOBUFS;
 	}
 
-	if (priv->num_ibss_vif ||
-	    (priv->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
-		ath_err(common, "IBSS coexistence with other modes is not allowed\n");
+	if (priv->num_ibss_vif && vif->type == NL80211_IFTYPE_ADHOC) {
+		ath_err(common,
+			"IBSS coexistence with another IBSS is not allowed\n");
 		mutex_unlock(&priv->mutex);
 		return -ENOBUFS;
 	}
-- 
1.7.12

