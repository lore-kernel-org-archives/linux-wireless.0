Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53964 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1GWOWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 10:22:38 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 04/11] ath6kl: Remove bssid from struct wmi
Date: Sat, 23 Jul 2011 19:43:10 +0530
Message-ID: <1311430397-4960-4-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110723_162241_684833_A579ECB2)
In-Reply-To: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is nothing but bssid of struct ath6kl.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    7 ++-----
 drivers/net/wireless/ath/ath6kl/wmi.h |    1 -
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ea123c9..ff71b7f 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -498,8 +498,6 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len)
 	ath6kl_dbg(ATH6KL_DBG_WMI, "%s: freq %d bssid %pM\n",
 		   __func__, ev->ch, ev->bssid);
 
-	memcpy(wmi->bssid, ev->bssid, ETH_ALEN);
-
 	/* Start of assoc rsp IEs */
 	pie = ev->assoc_info + ev->beacon_ie_len +
 	      ev->assoc_req_len + (sizeof(u16) * 3); /* capinfo, status, aid */
@@ -546,7 +544,6 @@ static int ath6kl_wmi_disconnect_event_rx(struct wmi *wmi, u8 *datap, int len)
 		return -EINVAL;
 
 	ev = (struct wmi_disconnect_event *) datap;
-	memset(wmi->bssid, 0, sizeof(wmi->bssid));
 
 	wmi->is_wmm_enabled = false;
 	wmi->pair_crypto_type = NONE_CRYPT;
@@ -772,7 +769,7 @@ static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 		 * instance value of scan result. It also sync up RSSI info
 		 * in GUI between scan result and RSSI signal icon.
 		 */
-		if (memcmp(wmi->bssid, bih->bssid, ETH_ALEN) == 0) {
+		if (memcmp(wmi->parent_dev->bssid, bih->bssid, ETH_ALEN) == 0) {
 			bih->rssi = a_cpu_to_sle16(bss->ni_rssi);
 			bih->snr = bss->ni_snr;
 		}
@@ -2253,7 +2250,7 @@ int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi)
 void ath6kl_wmi_get_current_bssid(struct wmi *wmi, u8 *bssid)
 {
 	if (bssid)
-		memcpy(bssid, wmi->bssid, ETH_ALEN);
+		memcpy(bssid, wmi->parent_dev->bssid, ETH_ALEN);
 }
 
 int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 status, u8 preamble_policy)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 1ef779d..1646a92 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -116,7 +116,6 @@ struct wmi {
 	u8 fat_pipe_exist;
 	struct ath6kl *parent_dev;
 	struct wmi_stats stat;
-	u8 bssid[ETH_ALEN];
 	u8 pwr_mode;
 	u8 phy_mode;
 	u8 keep_alive_intvl;
-- 
1.7.0.4

