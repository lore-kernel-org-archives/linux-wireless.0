Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:9884 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYLKM3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 07:29:07 -0500
Received: by wf-out-1314.google.com with SMTP id 27so717817wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 04:29:06 -0800 (PST)
Message-ID: <eb3ff54b0812110429y7d18e8cfx28a6da6637da23cf@mail.gmail.com> (sfid-20081211_132917_873951_2EF4E705)
Date: Thu, 11 Dec 2008 14:29:06 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH ] iwlwifi: fix build warning (iwl-rx.c)
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following build warning when CONFIG_IWLWIFI_DEBUG
is not set.

/work/src/wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c:758:
warning: 'iwl_dbg_report_frame' defined but not used


(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c
b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 0965232..71a2a51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -751,12 +751,6 @@ static void iwl_dbg_report_frame(struct iwl_priv *priv,
 	if (print_dump)
 		iwl_print_hex_dump(priv, IWL_DL_RX, header, length);
 }
-#else
-static void iwl_dbg_report_frame(struct iwl_priv *priv,
-		      struct iwl_rx_phy_res *phy_res, u16 length,
-		      struct ieee80211_hdr *header, int group100)
-{
-}
 #endif

 static void iwl_update_rx_stats(struct iwl_priv *priv, u16 fc, u16 len)
