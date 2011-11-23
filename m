Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:52863 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1KWSWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 13:22:00 -0500
Subject: [PATCH] ath6kl: remove unused sc_params from struct ath6kl
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 23 Nov 2011 20:21:54 +0200
Message-ID: <20111123182154.25200.78078.stgit@localhost6.localdomain6> (sfid-20111123_192204_405929_0B6DE36B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was only initialised but not used anywhere. Also remove two defines
which ended up unused after this change.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 ---
 drivers/net/wireless/ath/ath6kl/core.h     |    1 -
 drivers/net/wireless/ath/ath6kl/wmi.h      |   10 ----------
 3 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 08708bd..ae336ea 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2488,9 +2488,6 @@ struct ath6kl *ath6kl_core_alloc(struct device *dev)
 	ar->tx_pwr = 0;
 
 	ar->intra_bss = 1;
-	memset(&ar->sc_params, 0, sizeof(ar->sc_params));
-	ar->sc_params.short_scan_ratio = WMI_SHORTSCANRATIO_DEFAULT;
-	ar->sc_params.scan_ctrl_flags = DEFAULT_SCAN_CTRL_FLAGS;
 	ar->lrssi_roam_threshold = DEF_LRSSI_ROAM_THRESHOLD;
 
 	ar->state = ATH6KL_STATE_OFF;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 03e378d..7709d95 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -533,7 +533,6 @@ struct ath6kl {
 	struct list_head amsdu_rx_buffer_queue;
 	u8 rx_meta_ver;
 	enum wlan_low_pwr_state wlan_pwr_state;
-	struct wmi_scan_params_cmd sc_params;
 	u8 mac_addr[ETH_ALEN];
 #define AR_MCAST_FILTER_MAC_ADDR_SIZE  4
 	struct {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 76342d5..69db947 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -748,9 +748,6 @@ struct wmi_start_scan_cmd {
 	__le16 ch_list[1];
 } __packed;
 
-/* WMI_SET_SCAN_PARAMS_CMDID */
-#define WMI_SHORTSCANRATIO_DEFAULT      3
-
 /*
  *  Warning: scan control flag value of 0xFF is used to disable
  *  all flags in WMI_SCAN_PARAMS_CMD. Do not add any more
@@ -783,13 +780,6 @@ enum wmi_scan_ctrl_flags_bits {
 	ENABLE_SCAN_ABORT_EVENT = 0x40
 };
 
-#define DEFAULT_SCAN_CTRL_FLAGS			\
-	(CONNECT_SCAN_CTRL_FLAGS |		\
-	 SCAN_CONNECTED_CTRL_FLAGS |		\
-	 ACTIVE_SCAN_CTRL_FLAGS |		\
-	 ROAM_SCAN_CTRL_FLAGS |			\
-	 ENABLE_AUTO_CTRL_FLAGS)
-
 struct wmi_scan_params_cmd {
 	  /* sec */
 	__le16 fg_start_period;

