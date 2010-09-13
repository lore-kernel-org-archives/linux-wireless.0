Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab0IMMqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 08:46:40 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 14/14] iwlwifi: apply settings when finishing scan
Date: Mon, 13 Sep 2010 14:46:45 +0200
Message-Id: <1284382005-3246-15-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
References: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even is someone else complete scanning in mac80211, apply rxon and
tx power settings if gets scan complete notification from hardware.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 65b7cb4..599573f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -573,7 +573,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 
 	if (!test_and_clear_bit(STATUS_SCANNING, &priv->status)) {
 		IWL_DEBUG_SCAN(priv, "Scan already completed.\n");
-		goto out;
+		goto out_settings;
 	}
 
 	if (priv->is_internal_short_scan && !aborted) {
@@ -599,6 +599,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 out_complete:
 	iwl_complete_scan(priv, aborted);
 
+out_settings:
 	/* Can we still talk to firmware ? */
 	if (!iwl_is_ready_rf(priv))
 		goto out;
-- 
1.7.1

