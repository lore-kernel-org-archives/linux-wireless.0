Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbYE0DbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 23:31:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2.6.26 2/3] iwlwifi: fix exit from stay_in_table state
Date: Tue, 27 May 2008 11:29:34 +0800
Message-Id: <1211858975-21424-2-git-send-email-yi.zhu@intel.com> (sfid-20080527_053116_278424_31328279)
In-Reply-To: <1211858975-21424-1-git-send-email-yi.zhu@intel.com>
References: <1211858975-21424-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

When exiting from stay in table state (e.g. timer expiration),
all the statistics are reset and the RS flow should not continue
but only after enough statistics are collected again.

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index fa41ed1..838db19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1980,7 +1980,7 @@ lq_update:
 	 * 2)  Not just finishing up a search
 	 * 3)  Allowing a new search
 	 */
-	if (!update_lq && !done_search && !lq_sta->stay_in_tbl) {
+	if (!update_lq && !done_search && !lq_sta->stay_in_tbl && window->counter) {
 		/* Save current throughput to compare with "search" throughput*/
 		lq_sta->last_tpt = current_tpt;
 
-- 
1.5.3.6

