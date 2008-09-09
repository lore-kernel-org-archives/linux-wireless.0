Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10630 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbYIIC7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 22:59:06 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Guy Cohen <guy.cohen@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/3] iwlwifi: fix searching for best rate in new search column
Date: Tue,  9 Sep 2008 10:54:53 +0800
Message-Id: <1220928894-17998-3-git-send-email-yi.zhu@intel.com> (sfid-20080909_045919_051046_39EB956D)
In-Reply-To: <1220928894-17998-2-git-send-email-yi.zhu@intel.com>
References: <1220928894-17998-1-git-send-email-yi.zhu@intel.com>
 <1220928894-17998-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

This patch fixes a bug in Rate Scaling. When moving from SISO to MIMO we
need to choose the lowest higher rate, instead of choosing the highest in MIMO.
No doing this can lead to a high packet loss in the highest rate in MIMO,
leading not to move MIMO although lower in MIMO could give a better TPT.

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 4fc3a0f..de00be1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -436,7 +436,7 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
 		/* Shift bitmap by one frame (throw away oldest history),
 		 * OR in "1", and increment "success" if this
 		 * frame was successful. */
-		window->data <<= 1;;
+		window->data <<= 1;
 		if (successes > 0) {
 			window->success_counter++;
 			window->data |= 0x1;
@@ -1128,6 +1128,7 @@ static s32 rs_get_best_rate(struct iwl_priv *priv,
 
 			/* Higher rate not available, use the original */
 			} else {
+				new_rate = rate;
 				break;
 			}
 		}
-- 
1.5.3.6

