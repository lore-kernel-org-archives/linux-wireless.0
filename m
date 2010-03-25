Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab0CYUox (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/22] Revert "iwlwifi: fix build error for CONFIG_IWLAGN=n"
Date: Thu, 25 Mar 2010 13:44:29 -0700
Message-Id: <1269549890-19195-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

This reverts commit 76232ebf898c4d5e657f2b663fbf7108bca80ded.

iwl_good_ack_health only applies to aggregation and thus only to iwlagn. We
can thus move the function to iwlagn instead of modifying compile flags.
This is done in following patch.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 2fa30df..b6a64d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -621,7 +621,6 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 #define BA_TIMEOUT_CNT (5)
 #define BA_TIMEOUT_MAX (16)
 
-#if defined(CONFIG_IWLAGN) || defined(CONFIG_IWLAGN_MODULE)
 /**
  * iwl_good_ack_health - checks for ACK count ratios, BA timeout retries.
  *
@@ -671,7 +670,6 @@ bool iwl_good_ack_health(struct iwl_priv *priv,
 	return rc;
 }
 EXPORT_SYMBOL(iwl_good_ack_health);
-#endif
 
 /**
  * iwl_good_plcp_health - checks for plcp error.
-- 
1.6.3.3

