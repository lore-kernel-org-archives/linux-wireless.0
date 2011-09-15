Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64568 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934154Ab1IOQV3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 12:21:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.1] iwlagn: workaround bug crashing some APs
Date: Thu, 15 Sep 2011 08:36:22 -0700
Message-Id: <1316100982-1815-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_182136_043374_B52BBA2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

This patch reverts commit 9b7688328422b88a7a15dc0dc123ad9ab1a6e22d which
was introduced in 2.6.38-rc1.  It works around a problem where the iwlagn
driver stimulates a bug crashing (requiring power cycle to recover) some
APs under heavy traffic.

CC: stable@kernel.org #2.6.39, #3.0.0 #3.1.0
Signed-off-by: Don Fry <donald.h.fry@intel.com>
SIgned-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
hese patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8e1942e..f24165d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2440,7 +2440,12 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 		    IEEE80211_HW_SPECTRUM_MGMT |
 		    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
+	/*
+	 * Including the following line will crash some AP's.  This
+	 * workaround removes the stimulus which causes the crash until
+	 * the AP software can be fixed.
 	hw->max_tx_aggregation_subframes = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
+	 */
 
 	hw->flags |= IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
-- 
1.7.0.4

