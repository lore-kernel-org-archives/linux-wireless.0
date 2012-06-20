Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab2FTHiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/12] iwlwifi: delay ROC if doing internal reset scan
Date: Wed, 20 Jun 2012 09:38:11 +0200
Message-Id: <1340177894-12992-10-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093830_551987_30045018)
In-Reply-To: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
References: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the device is doing an internal radio reset
scan, ROC can be rejected to the supplicant with
busy status which confuses it.

One option would be to queue the ROC and handle
it later, but since the radio reset scan is very
quick we can just wait for it to finish instead.

Also add a warning since we shouldn't run into
the case of having a scan active when requesting
a ROC in any other case since mac80211 will not
scan while ROC or ROC while scanning.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 9d23748..c577263 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1036,8 +1036,18 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 
 	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
-		err = -EBUSY;
-		goto out;
+		/* mac80211 should not scan while ROC or ROC while scanning */
+		if (WARN_ON_ONCE(priv->scan_type != IWL_SCAN_RADIO_RESET)) {
+			err = -EBUSY;
+			goto out;
+		}
+
+		iwl_scan_cancel_timeout(priv, 100);
+
+		if (test_bit(STATUS_SCAN_HW, &priv->status)) {
+			err = -EBUSY;
+			goto out;
+		}
 	}
 
 	priv->hw_roc_channel = channel;
-- 
1.7.10

