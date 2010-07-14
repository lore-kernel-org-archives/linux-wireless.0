Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab0GNB10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 21:27:26 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/3] ath9k_htc: make ath9k_htc_tx_aggr_oper() static
Date: Tue, 13 Jul 2010 21:27:25 -0400
Message-Id: <1279070845-29442-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1279070845-29442-1-git-send-email-lrodriguez@atheros.com>
References: <1279070845-29442-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes this sparse complaint:

  CHECK   drivers/net/wireless/ath/ath9k/htc_drv_main.c
drivers/net/wireless/ath/ath9k/htc_drv_main.c:441:5:
	warning: symbol 'ath9k_htc_tx_aggr_oper'
		 was not declared. Should it be static?

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index fc234a7..fe4c185 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -438,10 +438,11 @@ static void ath9k_htc_update_rate(struct ath9k_htc_priv *priv,
 			  bss_conf->bssid, be32_to_cpu(trate.capflags));
 }
 
-int ath9k_htc_tx_aggr_oper(struct ath9k_htc_priv *priv,
-			   struct ieee80211_vif *vif,
-			   struct ieee80211_sta *sta,
-			   enum ieee80211_ampdu_mlme_action action, u16 tid)
+static int ath9k_htc_tx_aggr_oper(struct ath9k_htc_priv *priv,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_sta *sta,
+				  enum ieee80211_ampdu_mlme_action action,
+				  u16 tid)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_htc_target_aggr aggr;
-- 
1.7.0.4

