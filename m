Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61044 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbYCKXSM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 19:18:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 6/6] iwlwifi: change rate number to a constant
Date: Tue, 11 Mar 2008 16:17:20 -0700
Message-Id: <1205277440-14323-7-git-send-email-reinette.chatre@intel.com> (sfid-20080311_231821_623174_2C4F4D22)
In-Reply-To: <1205277440-14323-6-git-send-email-reinette.chatre@intel.com>
References: <1205277440-14323-1-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-2-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-3-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-4-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-5-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves a number to an understandable define

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7dd1548..0b73351 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5450,8 +5450,9 @@ static void iwl4965_init_hw_rates(struct iwl4965_priv *priv,
 			/*
 			 * If CCK != 1M then set short preamble rate flag.
 			 */
-			rates[i].flags |= (iwl4965_rates[i].plcp == 10) ?
-				0 : IEEE80211_RATE_SHORT_PREAMBLE;
+			rates[i].flags |=
+				(iwl4965_rates[i].plcp == IWL_RATE_1M_PLCP) ?
+					0 : IEEE80211_RATE_SHORT_PREAMBLE;
 		}
 	}
 }
-- 
1.5.3.4

