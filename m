Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61902 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1JJPQ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/34] iwlagn: check rf kill in queue stuck
Date: Mon, 10 Oct 2011 07:26:50 -0700
Message-Id: <1318256839-31837-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171634_151886_39D6BE8E)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

check the RF KILL flag in queue stuck watch dog function

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 59d1968..9cb6c75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1781,6 +1781,9 @@ void iwl_bg_watchdog(unsigned long data)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
+	if (iwl_is_rfkill(priv->shrd))
+		return;
+
 	timeout = priv->cfg->base_params->wd_timeout;
 	if (timeout == 0)
 		return;
-- 
1.7.0.4

