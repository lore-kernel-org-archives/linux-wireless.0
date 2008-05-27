Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbYE0DbN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 23:31:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2.6.26 3/3] iwlwifi: fix rate scale TLC column selection bug
Date: Tue, 27 May 2008 11:29:35 +0800
Message-Id: <1211858975-21424-3-git-send-email-yi.zhu@intel.com> (sfid-20080527_053116_434399_3EE9BCEB)
In-Reply-To: <1211858975-21424-2-git-send-email-yi.zhu@intel.com>
References: <1211858975-21424-1-git-send-email-yi.zhu@intel.com>
 <1211858975-21424-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

This patch fixes a case that a wrong maximal rate is selected when
searching for better configurations.

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 838db19..d0ae0cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1148,7 +1148,6 @@ static s32 rs_get_best_rate(struct iwl_priv *priv,
 
 			/* Higher rate not available, use the original */
 			} else {
-				new_rate = rate;
 				break;
 			}
 		}
-- 
1.5.3.6

