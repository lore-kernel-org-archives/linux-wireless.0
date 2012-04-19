Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49133 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab2DSX35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 19:29:57 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: disallow WoW with multiple vifs
Date: Thu, 19 Apr 2012 16:29:19 -0700
Message-ID: <1334878159-7713-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120420_013003_634244_8F84F526)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath6kl fw does not have enough memory to support the WoW filters of
more than one vif. Disallow WoW suspend if this is the case.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a8a7570..7ad03ed 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2059,6 +2059,10 @@ static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	u8 index = 0;
 	__be32 ips[MAX_IP_ADDRS];
 
+	/* The FW currently can't support multi-vif WoW properly. */
+	if (ar->num_vif > 1)
+		return -EIO;
+
 	vif = ath6kl_vif_first(ar);
 	if (!vif)
 		return -EIO;
@@ -3125,6 +3129,10 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 	if (vif->sme_state != SME_DISCONNECTED)
 		return -EBUSY;
 
+	/* The FW currently can't support multi-vif WoW properly. */
+	if (ar->num_vif > 1)
+		return -EIO;
+
 	ath6kl_cfg80211_scan_complete_event(vif, true);
 
 	ret = ath6kl_set_probed_ssids(ar, vif, request->ssids,
-- 
1.7.4.1

