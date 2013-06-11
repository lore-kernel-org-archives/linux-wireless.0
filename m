Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:33609 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903Ab3FKP6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 11:58:21 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name,
	johannes@sipsolutions.net, chunkeey@googlemail.com
Subject: [PATCH] carl9170: make use of the new rate control API
Date: Tue, 11 Jun 2013 17:57:17 +0200
Message-Id: <1370966237-27716-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130611_175824_823018_A9EA2EE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enabels carl9170 to use the new rate table to lookup each
mrr rate and retry information per packet.

Signed-off-by: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 +
 drivers/net/wireless/ath/carl9170/tx.c       |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 9dce106..ddaa149 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -322,6 +322,7 @@ struct ar9170 {
 
 	/* MAC */
 	enum carl9170_erp_modes erp_mode;
+	struct ieee80211_tx_rate rates[4];
 
 	/* PHY */
 	struct ieee80211_channel *channel;
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index c61cafa..d21c81d 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -266,6 +266,7 @@ static void carl9170_tx_release(struct kref *ref)
 	struct carl9170_tx_info *arinfo;
 	struct ieee80211_tx_info *txinfo;
 	struct sk_buff *skb;
+	int size;
 
 	arinfo = container_of(ref, struct carl9170_tx_info, ref);
 	txinfo = container_of((void *) arinfo, struct ieee80211_tx_info,
@@ -324,6 +325,9 @@ static void carl9170_tx_release(struct kref *ref)
 		}
 	}
 
+	size = min_t(int, sizeof(txinfo->status.rates), sizeof(ar->rates));
+	memcpy(txinfo->status.rates, ar->rates, size);
+
 	skb_pull(skb, sizeof(struct _carl9170_tx_superframe));
 	ieee80211_tx_status_irqsafe(ar->hw, skb);
 }
@@ -982,6 +986,8 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 			txc->s.ampdu_settings, factor);
 	}
 
+	ieee80211_get_tx_rates(info->control.vif, sta, skb, ar->rates, ARRAY_SIZE(ar->rates));
+
 	/*
 	 * NOTE: For the first rate, the ERP & AMPDU flags are directly
 	 * taken from mac_control. For all fallback rate, the firmware
@@ -989,7 +995,7 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 	 */
 	for (i = 0; i < CARL9170_TX_MAX_RATES; i++) {
 		__le32 phy_set;
-		txrate = &info->control.rates[i];
+		txrate = &ar->rates[i];
 		if (txrate->idx < 0)
 			break;
 
-- 
1.7.9.5

