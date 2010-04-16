Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571Ab0DPNsO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 09:48:14 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	<wey-yi.w.guy@intel.com>, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlwifi: check scan request ie_len
Date: Fri, 16 Apr 2010 15:46:41 +0200
Message-Id: <1271425601-32518-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In mac80211 we always check both scan_req->ie and scan_req->ie_len
against zero before usage, in iwlwifi we should do the same.

Remove not needed "left -= ie_len" while at it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index d817c9c..83e6291 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -644,10 +644,10 @@ u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 	if (WARN_ON(left < ie_len))
 		return len;
 
-	if (ies)
+	if (ies && ie_len) {
 		memcpy(pos, ies, ie_len);
-	len += ie_len;
-	left -= ie_len;
+		len += ie_len;
+	}
 
 	return (u16)len;
 }
-- 
1.6.2.5

