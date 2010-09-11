Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42166 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab0IKQGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:06:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/10] iwlwifi: fix PAN parameters while scanning
Date: Sat, 11 Sep 2010 09:08:31 -0700
Message-Id: <1284221318-28281-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When only the PAN side was active, we gave no
time to the WLAN context, which is OK unless
we are scanning, which always happens on the
WLAN context. Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 6fb52ab..d03ba6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -331,6 +331,11 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 		slot1 = max_t(int, 1, ctx_pan->vif->bss_conf.dtim_period) *
 					ctx_pan->vif->bss_conf.beacon_int;
 		slot1 = max_t(int, 100, slot1);
+
+		if (test_bit(STATUS_SCAN_HW, &priv->status)) {
+			slot0 = slot1 * 3 - 20;
+			slot1 = 20;
+		}
 	}
 
 	cmd.slots[0].width = cpu_to_le16(slot0);
-- 
1.7.0.4

