Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758392Ab1D1Jwr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:47 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 04/10] iwlegacy: remove unneeded disable_hw_scan check
Date: Thu, 28 Apr 2011 11:51:27 +0200
Message-Id: <1303984293-6601-4-git-send-email-sgruszka@redhat.com> (sfid-20110428_115259_096166_C9C5EC82)
In-Reply-To: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
References: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We never set STATUS_SCANNING in softwre scanning mode, disable_hw_scan
check is unneeded. Correct debug message while at it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index daf250e..7211c92 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -2114,10 +2114,9 @@ int iwl_legacy_mac_config(struct ieee80211_hw *hw, u32 changed)
 	IWL_DEBUG_MAC80211(priv, "enter to channel %d changed 0x%X\n",
 					channel->hw_value, changed);
 
-	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
-			test_bit(STATUS_SCANNING, &priv->status))) {
+	if (unlikely(test_bit(STATUS_SCANNING, &priv->status))) {
 		scan_active = 1;
-		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
+		IWL_DEBUG_MAC80211(priv, "scan active\n");
 	}
 
 	if (changed & (IEEE80211_CONF_CHANGE_SMPS |
-- 
1.7.1

