Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44692 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1CYObi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:31:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/12] iwlwifi: set default aggregation frame limit to 63
Date: Fri, 25 Mar 2011 07:14:12 -0700
Message-Id: <1301062456-17249-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

This gives much better performance at fast 3x3 rates (up to ~160 Mbps).
The scheduler will still make most decisions about batch size based on
available packets and RX parameters.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 2883915..cc21514 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2132,7 +2132,7 @@ struct iwl_link_qual_general_params {
 #define LINK_QUAL_AGG_DISABLE_START_MAX	(255)
 #define LINK_QUAL_AGG_DISABLE_START_MIN	(0)
 
-#define LINK_QUAL_AGG_FRAME_LIMIT_DEF	(31)
+#define LINK_QUAL_AGG_FRAME_LIMIT_DEF	(63)
 #define LINK_QUAL_AGG_FRAME_LIMIT_MAX	(63)
 #define LINK_QUAL_AGG_FRAME_LIMIT_MIN	(0)
 
-- 
1.7.0.4

