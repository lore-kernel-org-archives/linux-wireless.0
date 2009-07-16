Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24578 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbZGPJdO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:33:14 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/10] cfg80211: remove WARN_ON in __cfg80211_sme_scan_done
Date: Thu, 16 Jul 2009 17:34:14 +0800
Message-Id: <1247736854-6760-10-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1247736854-6760-9-git-send-email-yi.zhu@intel.com>
References: <1247736854-6760-1-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-2-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-3-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-4-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-5-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-6-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-7-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-8-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_sme_scan_done() can be called (by fullmac cards) with
wdev->conn == NULL when CFG80211_SME_CONNECTING. We quit silently
instead of WARN_ON in this case.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/wireless/sme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 10ed366..e7a8851 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -227,7 +227,7 @@ static void __cfg80211_sme_scan_done(struct net_device *dev)
 	if (wdev->sme_state != CFG80211_SME_CONNECTING)
 		return;
 
-	if (WARN_ON(!wdev->conn))
+	if (!wdev->conn)
 		return;
 
 	if (wdev->conn->state != CFG80211_CONN_SCANNING &&
-- 
1.6.0.4

