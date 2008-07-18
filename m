Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:26216 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbYGRGzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 02:55:10 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: davem@davemloft.net
Cc: tomasw@gmail.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH net-next 2/2][v2] iwlwifi: small compile warnings without CONFIG_IWLWIFI_DEBUG
Date: Fri, 18 Jul 2008 10:56:12 +0400
Message-Id: <1216364172-19922-1-git-send-email-den@openvz.org> (sfid-20080718_085516_056516_2D7DC841)
In-Reply-To: <1216286365-11703-1-git-send-email-den@openvz.org>
References: <1216286365-11703-1-git-send-email-den@openvz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CC [M]  drivers/net/wireless/iwlwifi/iwl-scan.o
drivers/net/wireless/iwlwifi/iwl-scan.c: In function 'iwl_rx_scan_complete_notif':
drivers/net/wireless/iwlwifi/iwl-scan.c:274: warning: unused variable 'scan_notif'

Signed-off-by: Denis V. Lunev <den@openvz.org>
Acked-by: Tomas Winkler <tomasw@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index efc750d..5a00ac2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -270,6 +270,7 @@ static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
 static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 				       struct iwl_rx_mem_buffer *rxb)
 {
+#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 
@@ -277,6 +278,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		       scan_notif->scanned_channels,
 		       scan_notif->tsf_low,
 		       scan_notif->tsf_high, scan_notif->status);
+#endif
 
 	/* The HW is no longer scanning */
 	clear_bit(STATUS_SCAN_HW, &priv->status);
-- 
1.5.4.5

