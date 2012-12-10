Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42224 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2LJVtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:49:01 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH 08/10] iwlwifi: iwlagn_request_scan: Fix check for priv->scan_request
Date: Mon, 10 Dec 2012 22:49:16 +0100
Message-Id: <1355176158-24675-8-git-send-email-johannes@sipsolutions.net> (sfid-20121210_224919_621594_24FC5CBE)
In-Reply-To: <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
References: <1355176087.8083.17.camel@jlt4.sipsolutions.net>
 <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tim Gardner <tim.gardner@canonical.com>

The WARN_ON_ONCE() check for scan_request will not correctly detect
a NULL pointer for scan_type == IWL_SCAN_NORMAL. Make it explicit
that the check only applies to normal scans.

Convert WARN_ON_ONCE to WARN_ON since priv->scan_request really _can't_
be NULL for normal scans. If it is then we should emit frequent warnings.

This smatch warning led to scrutiny of iwlagn_request_scan():

drivers/net/wireless/iwlwifi/dvm/scan.c:894 iwlagn_request_scan() error: we previously assumed 'priv->scan_request' could be null (see line 792)

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/scan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index aad5fa4..610ed22 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -673,8 +673,9 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	const u8 *ssid = NULL;
 	u8 ssid_len = 0;
 
-	if (WARN_ON_ONCE(priv->scan_request &&
-			 priv->scan_request->n_channels > MAX_SCAN_CHANNEL))
+	if (WARN_ON(priv->scan_type == IWL_SCAN_NORMAL &&
+		    (!priv->scan_request ||
+		     priv->scan_request->n_channels > MAX_SCAN_CHANNEL)))
 		return -EINVAL;
 
 	lockdep_assert_held(&priv->mutex);
-- 
1.8.0

