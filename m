Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35002 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583Ab1JYOG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:06:59 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 23/31] ath6kl: Store hw mac address in struct ath6kl
Date: Tue, 25 Oct 2011 19:34:18 +0530
Message-ID: <1319551466-29070-24-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160704_253828_0CEF6397)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WMI ready event gives the mac address, cache this
mac address in struct ath6kl so that it can be used to
compute the mac address for other vif in case of multi vif.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |   12 ++++++++++--
 drivers/net/wireless/ath/ath6kl/main.c |    5 ++---
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 466f6e1..747e5a7 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -492,6 +492,7 @@ struct ath6kl {
 	struct wireless_dev *wdev;
 	enum wlan_low_pwr_state wlan_pwr_state;
 	struct wmi_scan_params_cmd sc_params;
+	u8 mac_addr[ETH_ALEN];
 #define AR_MCAST_FILTER_MAC_ADDR_SIZE  4
 	struct {
 		void *rx_report;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index c5170c3..bafb30d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1503,8 +1503,16 @@ static int ath6kl_init(struct ath6kl *ar)
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 
 	status = ath6kl_target_config_wlan_params(ar);
-	if (!status)
-		goto ath6kl_init_done;
+	if (status)
+		goto err_htc_stop;
+
+	/*
+	 * Set mac address which is received in ready event
+	 * FIXME: Move to ath6kl_interface_add()
+	 */
+	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
+
+	return status;
 
 err_htc_stop:
 	ath6kl_htc_stop(ar->htc_target);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index cc3e3c8..6bf9402 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -923,11 +923,10 @@ static const char *get_hw_id_string(u32 id)
 void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 {
 	struct ath6kl *ar = devt;
-	struct net_device *dev = ar->vif->ndev;
 
-	memcpy(dev->dev_addr, datap, ETH_ALEN);
+	memcpy(ar->mac_addr, datap, ETH_ALEN);
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: mac addr = %pM\n",
-		   __func__, dev->dev_addr);
+		   __func__, ar->mac_addr);
 
 	ar->version.wlan_ver = sw_ver;
 	ar->version.abi_ver = abi_ver;
-- 
1.7.0.4

