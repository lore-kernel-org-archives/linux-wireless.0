Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab0IINxM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 09:53:12 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 16/16] iwlwifi: clear is_internal_short_scan when fail to initiate scan
Date: Thu,  9 Sep 2010 15:52:34 +0200
Message-Id: <1284040354-31703-17-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case we fail to request scan we need to clear
priv->is_internal_short_scan. Otherwise we pretend we perform internal
short scan. Next external scan request will be differed, but never
performed nor canceled because STATUS_SCANNING bit is cleared.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index b841016..c3f2957 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -381,14 +381,15 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 			internal ? "internal short " : "");
 
 	set_bit(STATUS_SCANNING, &priv->status);
-
 	priv->is_internal_short_scan = internal;
+
 	priv->scan_start = jiffies;
 	priv->scan_band = band;
 
 	ret = priv->cfg->ops->utils->request_scan(priv, vif);
 	if (ret) {
 		clear_bit(STATUS_SCANNING, &priv->status);
+		priv->is_internal_short_scan = false;
 		return ret;
 	}
 
-- 
1.7.1

