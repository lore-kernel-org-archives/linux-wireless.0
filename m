Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56203 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121Ab2DXTut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 15:50:49 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: check for sband existence when creating scan cmd
Date: Tue, 24 Apr 2012 12:50:41 -0700
Message-ID: <1335297041-4328-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120424_215052_981273_FF2F6F6F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "ath6kl: support fw reporting phy capabilities" gave the
firmware the ability to disable certain wiphy supported bands. Check if
this is the case in ath6kl_wmi_beginscan_cmd to avoid dereferencing a
NULL pointer.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 2eb771a..9186f8e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1851,6 +1851,8 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		struct ieee80211_supported_band *sband =
 		    ar->wiphy->bands[band];
+		if (!sband)
+			continue;
 		u32 ratemask = rates[band];
 		u8 *supp_rates = sc->supp_rates[band].rates;
 		num_rates = 0;
-- 
1.7.4.1

