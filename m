Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:34993 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759368AbcAUNpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:45:40 -0500
Received: by mail-lf0-f44.google.com with SMTP id c192so26816973lfe.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 05:45:39 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 02/13] ath10k: unify txpath decision
Date: Thu, 21 Jan 2016 14:46:35 +0100
Message-Id: <1453384006-31907-3-git-send-email-michal.kazior@tieto.com> (sfid-20160121_144543_225322_5FD83D1C)
In-Reply-To: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some future changes will need to determine final
tx method early on. Prepare the code.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 58 +++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a684718f6389..9abb52924432 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2997,6 +2997,13 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
 /* TX handlers */
 /***************/
 
+enum ath10k_mac_tx_path {
+	ATH10K_MAC_TX_HTT,
+	ATH10K_MAC_TX_HTT_MGMT,
+	ATH10K_MAC_TX_WMI_MGMT,
+	ATH10K_MAC_TX_UNKNOWN,
+};
+
 void ath10k_mac_tx_lock(struct ath10k *ar, int reason)
 {
 	lockdep_assert_held(&ar->htt.tx_lock);
@@ -3330,27 +3337,52 @@ unlock:
 	return ret;
 }
 
+static enum ath10k_mac_tx_path
+ath10k_mac_tx_h_get_txpath(struct ath10k *ar,
+			   struct sk_buff *skb,
+			   enum ath10k_hw_txrx_mode txmode)
+{
+	switch (txmode) {
+	case ATH10K_HW_TXRX_RAW:
+	case ATH10K_HW_TXRX_NATIVE_WIFI:
+	case ATH10K_HW_TXRX_ETHERNET:
+		return ATH10K_MAC_TX_HTT;
+	case ATH10K_HW_TXRX_MGMT:
+		if (test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
+			     ar->fw_features))
+			return ATH10K_MAC_TX_WMI_MGMT;
+		else if (ar->htt.target_version_major >= 3)
+			return ATH10K_MAC_TX_HTT;
+		else
+			return ATH10K_MAC_TX_HTT_MGMT;
+	}
+
+	return ATH10K_MAC_TX_UNKNOWN;
+}
+
 static int ath10k_mac_tx_submit(struct ath10k *ar,
 				enum ath10k_hw_txrx_mode txmode,
 				struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
-	int ret = 0;
+	enum ath10k_mac_tx_path txpath;
+	int ret;
 
-	switch (txmode) {
-	case ATH10K_HW_TXRX_RAW:
-	case ATH10K_HW_TXRX_NATIVE_WIFI:
-	case ATH10K_HW_TXRX_ETHERNET:
+	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
+
+	switch (txpath) {
+	case ATH10K_MAC_TX_HTT:
 		ret = ath10k_htt_tx(htt, txmode, skb);
 		break;
-	case ATH10K_HW_TXRX_MGMT:
-		if (test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
-			     ar->fw_features))
-			ret = ath10k_mac_tx_wmi_mgmt(ar, skb);
-		else if (ar->htt.target_version_major >= 3)
-			ret = ath10k_htt_tx(htt, txmode, skb);
-		else
-			ret = ath10k_htt_mgmt_tx(htt, skb);
+	case ATH10K_MAC_TX_HTT_MGMT:
+		ret = ath10k_htt_mgmt_tx(htt, skb);
+		break;
+	case ATH10K_MAC_TX_WMI_MGMT:
+		ret = ath10k_mac_tx_wmi_mgmt(ar, skb);
+		break;
+	case ATH10K_MAC_TX_UNKNOWN:
+		WARN_ON_ONCE(1);
+		ret = -EINVAL;
 		break;
 	}
 
-- 
2.1.4

