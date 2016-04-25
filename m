Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40766 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299AbcDYM6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 08:58:16 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 5/7] wil6210: unmask RX_HTRSH interrupt only when connected
Date: Mon, 25 Apr 2016 15:57:56 +0300
Message-Id: <1461589078-29854-6-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160425_145829_662698_66B97B45)
In-Reply-To: <1461589078-29854-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1461589078-29854-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX_HTRSH interrupt sometimes triggered during device reset
procedure.
To prevent handling this interrupt when not required, unmask
this interrupt only if we are connected and mask it when
disconnected.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c |  6 +++++-
 drivers/net/wireless/ath/wil6210/main.c      | 17 +++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 6897754..22592f3 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -38,6 +38,8 @@
 #define WIL6210_IRQ_DISABLE	(0xFFFFFFFFUL)
 #define WIL6210_IMC_RX		(BIT_DMA_EP_RX_ICR_RX_DONE | \
 				 BIT_DMA_EP_RX_ICR_RX_HTRSH)
+#define WIL6210_IMC_RX_NO_RX_HTRSH (WIL6210_IMC_RX & \
+				    (~(BIT_DMA_EP_RX_ICR_RX_HTRSH)))
 #define WIL6210_IMC_TX		(BIT_DMA_EP_TX_ICR_TX_DONE | \
 				BIT_DMA_EP_TX_ICR_TX_DONE_N(0))
 #define WIL6210_IMC_MISC	(ISR_MISC_FW_READY | \
@@ -109,8 +111,10 @@ void wil6210_unmask_irq_tx(struct wil6210_priv *wil)
 
 void wil6210_unmask_irq_rx(struct wil6210_priv *wil)
 {
+	bool unmask_rx_htrsh = test_bit(wil_status_fwconnected, wil->status);
+
 	wil_w(wil, RGF_DMA_EP_RX_ICR + offsetof(struct RGF_ICR, IMC),
-	      WIL6210_IMC_RX);
+	      unmask_rx_htrsh ? WIL6210_IMC_RX : WIL6210_IMC_RX_NO_RX_HTRSH);
 }
 
 static void wil6210_unmask_irq_misc(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 8d4e884..261bdab 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -194,6 +194,18 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 	memset(&sta->stats, 0, sizeof(sta->stats));
 }
 
+static bool wil_ap_is_connected(struct wil6210_priv *wil)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+		if (wil->sta[i].status == wil_sta_connected)
+			return true;
+	}
+
+	return false;
+}
+
 static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 				u16 reason_code, bool from_event)
 {
@@ -247,6 +259,11 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 		}
 		clear_bit(wil_status_fwconnecting, wil->status);
 		break;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		if (!wil_ap_is_connected(wil))
+			clear_bit(wil_status_fwconnected, wil->status);
+		break;
 	default:
 		break;
 	}
-- 
1.8.5.2

