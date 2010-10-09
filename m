Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56863 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab0JIXwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 19:52:01 -0400
Received: by fxm14 with SMTP id 14so1077589fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 16:52:00 -0700 (PDT)
Message-Id: <75b38fb7faac45360bf016016144b15752af07ce.1286667826.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 9 Oct 2010 21:37:11 +0200
Subject: [PATCH 1/3] carl9170: common error path for bad frames
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces several identical frame drop
paths with a single shared rx frame error handler.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/rx.c |   48 +++++++++++++------------------
 1 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 671dbc4..31287e0 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -598,18 +598,14 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	if (!IS_STARTED(ar))
 		return;
 
-	if (unlikely(len < sizeof(*mac))) {
-		ar->rx_dropped++;
-		return;
-	}
+	if (unlikely(len < sizeof(*mac)))
+		goto drop;
 
 	mpdu_len = len - sizeof(*mac);
 
 	mac = (void *)(buf + mpdu_len);
-	if (unlikely(mac->error & AR9170_RX_ERROR_FATAL)) {
-		ar->rx_dropped++;
-		return;
-	}
+	if (unlikely(mac->error & AR9170_RX_ERROR_FATAL))
+		goto drop;
 
 	switch (mac->status & AR9170_RX_STATUS_MPDU) {
 	case AR9170_RX_STATUS_MPDU_FIRST:
@@ -638,8 +634,7 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 					"is clipped.\n");
 			}
 
-			ar->rx_dropped++;
-			return;
+			goto drop;
 		}
 		break;
 
@@ -659,8 +654,7 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 					"is clipped.\n");
 			}
 
-			ar->rx_dropped++;
-			return;
+			goto drop;
 		}
 
 	case AR9170_RX_STATUS_MPDU_MIDDLE:
@@ -672,8 +666,7 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 			wiphy_err(ar->hw->wiphy, "rx stream does not start "
 					"with a first_mpdu frame tag.\n");
 
-			ar->rx_dropped++;
-			return;
+			goto drop;
 		}
 
 		head = &ar->rx_plcp;
@@ -696,16 +689,12 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	}
 
 	/* FC + DU + RA + FCS */
-	if (unlikely(mpdu_len < (2 + 2 + 6 + FCS_LEN))) {
-		ar->rx_dropped++;
-		return;
-	}
+	if (unlikely(mpdu_len < (2 + 2 + ETH_ALEN + FCS_LEN)))
+		goto drop;
 
 	memset(&status, 0, sizeof(status));
-	if (unlikely(carl9170_rx_mac_status(ar, head, mac, &status))) {
-		ar->rx_dropped++;
-		return;
-	}
+	if (unlikely(carl9170_rx_mac_status(ar, head, mac, &status)))
+		goto drop;
 
 	if (phy)
 		carl9170_rx_phy_status(ar, phy, &status);
@@ -713,12 +702,15 @@ static void carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	carl9170_ps_beacon(ar, buf, mpdu_len);
 
 	skb = carl9170_rx_copy_data(buf, mpdu_len);
-	if (likely(skb)) {
-		memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
-		ieee80211_rx(ar->hw, skb);
-	} else {
-		ar->rx_dropped++;
-	}
+	if (!skb)
+		goto drop;
+
+	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+	ieee80211_rx(ar->hw, skb);
+	return;
+
+drop:
+	ar->rx_dropped++;
 }
 
 static void carl9170_rx_untie_cmds(struct ar9170 *ar, const u8 *respbuf,
-- 
1.7.1

