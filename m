Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37705 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220Ab0CaWFa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 18:05:30 -0400
Subject: [PATCH 1/3] ath9k: rename symbols in enum ath9k_internal_frame_type
 to avoid confusion
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 31 Mar 2010 18:05:25 -0400
Message-ID: <20100331220525.2920.14907.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Symbols starting with "ATH9K_INT" are also used for interrupt mask.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/rc.h      |    6 +++---
 drivers/net/wireless/ath/ath9k/virtual.c |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c    |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 36083dd..3d8d40c 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -176,9 +176,9 @@ struct ath_rate_priv {
 #define ATH_TX_INFO_UNDERRUN		(1 << 4)
 
 enum ath9k_internal_frame_type {
-	ATH9K_NOT_INTERNAL,
-	ATH9K_INT_PAUSE,
-	ATH9K_INT_UNPAUSE
+	ATH9K_IFT_NOT_INTERNAL,
+	ATH9K_IFT_PAUSE,
+	ATH9K_IFT_UNPAUSE
 };
 
 int ath_rate_control_register(void);
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index a43fbf8..e95aaa3 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -218,7 +218,7 @@ static int ath9k_send_nullfunc(struct ath_wiphy *aphy,
 
 	memset(&txctl, 0, sizeof(struct ath_tx_control));
 	txctl.txq = &sc->tx.txq[sc->tx.hwq_map[ATH9K_WME_AC_VO]];
-	txctl.frame_type = ps ? ATH9K_INT_PAUSE : ATH9K_INT_UNPAUSE;
+	txctl.frame_type = ps ? ATH9K_IFT_PAUSE : ATH9K_IFT_UNPAUSE;
 
 	if (ath_tx_start(aphy->hw, skb, &txctl) != 0)
 		goto exit;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f378838..02df4cb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1574,12 +1574,12 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 
 	tx_info->pad[0] = 0;
 	switch (txctl->frame_type) {
-	case ATH9K_NOT_INTERNAL:
+	case ATH9K_IFT_NOT_INTERNAL:
 		break;
-	case ATH9K_INT_PAUSE:
+	case ATH9K_IFT_PAUSE:
 		tx_info->pad[0] |= ATH_TX_INFO_FRAME_TYPE_PAUSE;
 		/* fall through */
-	case ATH9K_INT_UNPAUSE:
+	case ATH9K_IFT_UNPAUSE:
 		tx_info->pad[0] |= ATH_TX_INFO_FRAME_TYPE_INTERNAL;
 		break;
 	}
