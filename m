Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4015 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab0A2TyM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 11/12] iwlwifi: fix typo in IWL_CCK_RATES_MASK
Date: Fri, 29 Jan 2010 11:54:01 -0800
Message-Id: <1264794842-8046-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
References: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to a typo, the variable contains OFDM
rates as well. The only user doesn't care,
so this change doesn't really do anything
but fix up my confusion.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 2f0094a..e719239 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -191,7 +191,7 @@ enum {
 	IWL_RATE_2M_MASK)
 
 #define IWL_CCK_RATES_MASK          \
-       (IWL_BASIC_RATES_MASK      | \
+       (IWL_CCK_BASIC_RATES_MASK  | \
 	IWL_RATE_5M_MASK          | \
 	IWL_RATE_11M_MASK)
 
-- 
1.6.3.3

