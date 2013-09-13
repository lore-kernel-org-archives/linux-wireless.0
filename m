Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab3IMKiN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 06:38:13 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 5/5] iwlwifi: quiesce mac80211 before fw restart
Date: Fri, 13 Sep 2013 12:36:08 +0200
Message-Id: <1379068568-27552-6-git-send-email-sgruszka@redhat.com> (sfid-20130913_123824_651068_C34AF372)
In-Reply-To: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
References: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 1 +
 drivers/net/wireless/iwlwifi/dvm/main.c     | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index cae4d31..e819e5b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -393,6 +393,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 
  error:
 	priv->wowlan = false;
+	ieee80211_quiesce(priv->hw);
 	iwlagn_prepare_restart(priv);
 	ieee80211_restart_hw(priv->hw);
  out:
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 7aad766..2e0fbea 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -975,10 +975,12 @@ static void iwl_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
+		iwl_cancel_deferred_work(priv);
+		if (priv->mac80211_registered)
+			ieee80211_quiesce(priv->hw);
 		mutex_lock(&priv->mutex);
 		iwlagn_prepare_restart(priv);
 		mutex_unlock(&priv->mutex);
-		iwl_cancel_deferred_work(priv);
 		if (priv->mac80211_registered)
 			ieee80211_restart_hw(priv->hw);
 		else
-- 
1.8.3.1

