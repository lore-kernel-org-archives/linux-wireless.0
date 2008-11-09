Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21446 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbYKIAv1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 19:51:27 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: stable@kernel.org, rjw@sisk.pl, linville@tuxdriver.com,
	reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/2] iwlwifi: fix suspend to RAM in iwlwifi
Date: Sun,  9 Nov 2008 02:51:07 +0200
Message-Id: <1226191867-22324-3-git-send-email-tomas.winkler@intel.com> (sfid-20081109_015130_725473_372D028C)
In-Reply-To: <1226191867-22324-2-git-send-email-tomas.winkler@intel.com>
References: <1226191867-22324-1-git-send-email-tomas.winkler@intel.com>
 <1226191867-22324-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes suspend to RAM after by moving
notify_mac out of iwlwifi mutex

http://bugzilla.kernel.org/show_bug.cgi?id=11845

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Tested-by: Carlos R. Mafra <crmafra2@gmail.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e01f048..edab202 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2090,7 +2090,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		iwl4965_error_recovery(priv);
 
 	iwl_power_update_mode(priv, 1);
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 
 	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
 		iwl4965_set_mode(priv, priv->iw_mode);
@@ -2342,6 +2341,7 @@ static void iwl_bg_alive_start(struct work_struct *data)
 	mutex_lock(&priv->mutex);
 	iwl_alive_start(priv);
 	mutex_unlock(&priv->mutex);
+	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 static void iwl4965_bg_rf_kill(struct work_struct *work)
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

