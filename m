Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:63824 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761878AbYAZQJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 11:09:57 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1041023fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2008 08:09:56 -0800 (PST)
Date: Sat, 26 Jan 2008 19:09:36 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Tuttle <linux-kernel@ttuttle.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Wu <flamingice@sourmilk.net>,
	LWML <linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless: iwlwifi3945/4965 - fix incorrect counting of
	memory
Message-ID: <20080126160936.GB6738@cvg> (sfid-20080126_161022_758651_47675B1C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch does fix incorrect counting of memory allocated by kmalloc.
It seems that could lead to allocated memory overrun and corrupt
nearlaid memory area.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

 iwl3945-base.c |    2 +-
 iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.git/drivers/net/wireless/iwlwifi/iwl3945-base.c
===================================================================
--- linux-2.6.git.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-01-24 18:26:11.000000000 +0300
+++ linux-2.6.git/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-01-26 18:45:03.000000000 +0300
@@ -6631,7 +6631,7 @@ static void iwl_bg_request_scan(struct w
 	 * that based on the direct_mask added to each channel entry */
 	scan->tx_cmd.len = cpu_to_le16(
 		iwl_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
-			IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
+			IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;

Index: linux-2.6.git/drivers/net/wireless/iwlwifi/iwl4965-base.c
===================================================================
--- linux-2.6.git.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-01-26 18:45:38.000000000 +0300
+++ linux-2.6.git/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-01-26 18:46:06.000000000 +0300
@@ -6992,7 +6992,7 @@ static void iwl_bg_request_scan(struct w
 	 * that based on the direct_mask added to each channel entry */
 	scan->tx_cmd.len = cpu_to_le16(
 		iwl_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
-			IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
+			IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
