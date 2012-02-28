Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5412 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab2B1OvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 09:51:09 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V3 5/5] ath6kl: Defer wiphy and netdev registration till the end of ath6kl_core_init()
Date: Tue, 28 Feb 2012 20:20:23 +0530
Message-ID: <1330440623-5649-5-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120228_155113_526977_1767C3BD)
In-Reply-To: <1330440623-5649-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1330440623-5649-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the wiphy and initial netdev registration the last step
in dev initialization. Apart from the fact that this looks right,
it can also be used to setup wiphy with the regulatory information
received from firmware after uploading the firmware. Also it fixes
a FIXME in ath6kl_core_init() where mac address is copied into
netdev->dev_addr, ath6kl_interface_add() takes care of this as well.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
V2 - Remove reference to regulatory in commit log, even without
     this patch regulatory information can be initialized.

 drivers/net/wireless/ath/ath6kl/core.c |   76 +++++++++++++------------------
 1 files changed, 32 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index d5c06c0..e66cf43 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -98,38 +98,6 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: got wmi @ 0x%p.\n", __func__, ar->wmi);
 
-	ret = ath6kl_cfg80211_init(ar);
-	if (ret)
-		goto err_node_cleanup;
-
-	ret = ath6kl_debug_init(ar);
-	if (ret) {
-		wiphy_unregister(ar->wiphy);
-		goto err_node_cleanup;
-	}
-
-	for (i = 0; i < ar->vif_max; i++)
-		ar->avail_idx_map |= BIT(i);
-
-	rtnl_lock();
-
-	/* Add an initial station interface */
-	ndev = ath6kl_interface_add(ar, "wlan%d", NL80211_IFTYPE_STATION, 0,
-				    INFRA_NETWORK);
-
-	rtnl_unlock();
-
-	if (!ndev) {
-		ath6kl_err("Failed to instantiate a network device\n");
-		ret = -ENOMEM;
-		wiphy_unregister(ar->wiphy);
-		goto err_debug_init;
-	}
-
-
-	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
-			__func__, ndev->name, ndev, ar);
-
 	/* setup access class priority mappings */
 	ar->ac_stream_pri_map[WMM_AC_BK] = 0; /* lowest  */
 	ar->ac_stream_pri_map[WMM_AC_BE] = 1;
@@ -166,24 +134,44 @@ int ath6kl_core_init(struct ath6kl *ar)
 	ath6kl_rx_refill(ar->htc_target, ar->ctrl_ep);
 	ath6kl_rx_refill(ar->htc_target, ar->ac2ep_map[WMM_AC_BE]);
 
-	/*
-	 * Set mac address which is received in ready event
-	 * FIXME: Move to ath6kl_interface_add()
-	 */
-	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
+	ret = ath6kl_cfg80211_init(ar);
+	if (ret)
+		goto err_rxbuf_cleanup;
 
-	return ret;
+	ret = ath6kl_debug_init(ar);
+	if (ret) {
+		wiphy_unregister(ar->wiphy);
+		goto err_rxbuf_cleanup;
+	}
+
+	for (i = 0; i < ar->vif_max; i++)
+		ar->avail_idx_map |= BIT(i);
 
-err_rxbuf_cleanup:
-	ath6kl_htc_flush_rx_buf(ar->htc_target);
-	ath6kl_cleanup_amsdu_rxbufs(ar);
 	rtnl_lock();
-	ath6kl_cfg80211_vif_cleanup(netdev_priv(ndev));
+
+	/* Add an initial station interface */
+	ndev = ath6kl_interface_add(ar, "wlan%d", NL80211_IFTYPE_STATION, 0,
+				    INFRA_NETWORK);
+
 	rtnl_unlock();
-	wiphy_unregister(ar->wiphy);
+
+	if (!ndev) {
+		ath6kl_err("Failed to instantiate a network device\n");
+		ret = -ENOMEM;
+		wiphy_unregister(ar->wiphy);
+		goto err_debug_init;
+	}
+
+	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
+			__func__, ndev->name, ndev, ar);
+
+	return ret;
+
 err_debug_init:
 	ath6kl_debug_cleanup(ar);
-err_node_cleanup:
+err_rxbuf_cleanup:
+	ath6kl_htc_flush_rx_buf(ar->htc_target);
+	ath6kl_cleanup_amsdu_rxbufs(ar);
 	ath6kl_wmi_shutdown(ar->wmi);
 	clear_bit(WMI_ENABLED, &ar->flag);
 	ar->wmi = NULL;
-- 
1.7.0.4

