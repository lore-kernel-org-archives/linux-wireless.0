Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54758 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbYJ1XDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 19:03:16 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	reinette.chatre@intel.com
Cc: linux-stable@vger.kernel.org, rjw@sisk.pl,
	linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: fix suspend to RAM in iwlwifi
Date: Wed, 29 Oct 2008 01:03:01 +0200
Message-Id: <1225234981-9048-1-git-send-email-tomas.winkler@intel.com> (sfid-20081029_000322_743921_BD53FD21)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes suspend to RAM after by moving
notify_mac out of iwlwifi mutex

http://bugzilla.kernel.org/show_bug.cgi?id=11845

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reported-by: Carlos R. Mafra <crmafra2@gmail.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---

This is just a resent. It wasn't delivered to all destination because
I've screwed up my scripts
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 89450e3..bbfaef0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2085,7 +2085,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		iwl4965_error_recovery(priv);
 
 	iwl_power_update_mode(priv, 1);
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 
 	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
 		iwl4965_set_mode(priv, priv->iw_mode);
@@ -2337,6 +2336,7 @@ static void iwl_bg_alive_start(struct work_struct *data)
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

