Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49661 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0HXOYL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 10:24:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-next-2.6] iwlwifi: fix compile error without debugging support
Date: Tue, 24 Aug 2010 07:27:56 -0700
Message-Id: <1282660076-9004-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Encounter compiler error when iwlwifi debugging support is
disabled, fix it.

This compiler error was introduced by the previous WiFi/BT coexist patchset.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index c8f7a34..7727f09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -206,7 +206,6 @@ static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
 static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 				       struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 
@@ -214,7 +213,6 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		       scan_notif->scanned_channels,
 		       scan_notif->tsf_low,
 		       scan_notif->tsf_high, scan_notif->status);
-#endif
 
 	/* The HW is no longer scanning */
 	clear_bit(STATUS_SCAN_HW, &priv->status);
-- 
1.7.0.4

