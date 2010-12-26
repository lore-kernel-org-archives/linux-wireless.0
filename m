Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26963 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab0LZS1v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 13:27:51 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/3] iwlagn: fix FH error
Date: Sun, 26 Dec 2010 10:17:57 -0800
Message-Id: <1293387478-3297-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1293387478-3297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1293387478-3297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

# iw wlan0 interface add moni0 type monitor flags control
# ip link set moni0 up

causes a continuous spew of FH_ERROR from the
device. Fix this by not setting the CTL2HOST
filter by itself -- CTL + promisc works fine.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d407547..b54d74d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3634,7 +3634,8 @@ void iwlagn_configure_filter(struct ieee80211_hw *hw,
 			changed_flags, *total_flags);
 
 	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
-	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK);
+	/* Setting _just_ RXON_FILTER_CTL2HOST_MSK causes FH errors */
+	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_PROMISC_MSK);
 	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
 
 #undef CHK
-- 
1.7.0.4

