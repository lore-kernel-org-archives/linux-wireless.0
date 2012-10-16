Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab2JPSPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:15:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 7/8] iwlwifi: don't print the Intel banner twice
Date: Tue, 16 Oct 2012 20:16:19 +0200
Message-Id: <1350411380-2391-8-git-send-email-johannes@sipsolutions.net> (sfid-20121016_201603_029541_FA07B779)
In-Reply-To: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
References: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Once in bus enumeration is enough, no need to print it
again when the op_mode loads.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 7626299..475df45 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -2151,8 +2151,6 @@ static int __init iwl_init(void)
 {
 
 	int ret;
-	pr_info(DRV_DESCRIPTION ", " DRV_VERSION "\n");
-	pr_info(DRV_COPYRIGHT "\n");
 
 	ret = iwlagn_rate_control_register();
 	if (ret) {
-- 
1.7.10.4

