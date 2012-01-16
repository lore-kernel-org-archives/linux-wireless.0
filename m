Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46193 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2APCrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jan 2012 21:47:25 -0500
Received: by ggdk6 with SMTP id k6so2394972ggd.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jan 2012 18:47:24 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] wireless: iwlwifi: iwl-scan.c: Fix build warning
Date: Mon, 16 Jan 2012 00:47:12 -0200
Message-Id: <1326682032-3060-1-git-send-email-festevam@gmail.com> (sfid-20120116_034742_712098_9E657DFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following build warning:

drivers/net/wireless/iwlwifi/iwl-scan.c: In function ‘iwlagn_request_scan’:
drivers/net/wireless/iwlwifi/iwl-scan.c:572: warning: ‘cmd_len’ may be used uninitialized in this function

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 084aa2c..a645472 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -569,7 +569,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	struct iwl_scan_cmd *scan;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	u32 rate_flags = 0;
-	u16 cmd_len;
+	u16 cmd_len = 0;
 	u16 rx_chain = 0;
 	enum ieee80211_band band;
 	u8 n_probes = 0;
-- 
1.7.1

