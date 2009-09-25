Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1107 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbZIYVY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 17:24:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/8] iwlwifi: fix a typo
Date: Fri, 25 Sep 2009 14:24:24 -0700
Message-Id: <1253913868-8400-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
References: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

We never have four chains, but let's fix the typo
while we noticed it. You count 0, 1, 2, 3, not
0, 1, 2, 4 :)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2908bff..5ff0f66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -984,7 +984,7 @@ static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
 	res = (chain_bitmap & BIT(0)) >> 0;
 	res += (chain_bitmap & BIT(1)) >> 1;
 	res += (chain_bitmap & BIT(2)) >> 2;
-	res += (chain_bitmap & BIT(4)) >> 4;
+	res += (chain_bitmap & BIT(3)) >> 3;
 	return res;
 }
 
-- 
1.5.6.3

