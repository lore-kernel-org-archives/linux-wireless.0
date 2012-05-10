Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646Ab2EJQJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 12:09:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 3/3] iwlwifi: Move IWL_MASK macro to transport.
Date: Thu, 10 May 2012 18:09:08 +0200
Message-Id: <1336666148-24471-4-git-send-email-johannes@sipsolutions.net> (sfid-20120510_180919_651588_D79D1806)
In-Reply-To: <1336666148-24471-1-git-send-email-johannes@sipsolutions.net>
References: <1336666148-24471-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This macro is needed by other transports besides PCIe, thus
moving to a common location.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-trans.h      |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 2f8c84e..14aa504 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -78,8 +78,6 @@
 /* FIXME: need to abstract out TX command (once we know what it looks like) */
 #include "iwl-commands.h"
 
-#define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
-
 #define SCD_QUEUECHAIN_SEL_ALL(trans, trans_pcie)	\
 	(((1<<trans->cfg->base_params->num_of_queues) - 1) &\
 	(~(1<<(trans_pcie)->cmd_queue)))
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 79a1e7a..78b89f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -280,6 +280,8 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
 
 #define MAX_NO_RECLAIM_CMDS	6
 
+#define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
+
 /*
  * Maximum number of HW queues the transport layer
  * currently supports
-- 
1.7.10

