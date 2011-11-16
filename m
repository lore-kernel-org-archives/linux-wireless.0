Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31978 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab1KPHwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 02:52:44 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Fix AP mode operation after interface down/up
Date: Wed, 16 Nov 2011 13:21:34 +0530
Message-ID: <1321429894-10845-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111116_085246_832949_D93A9641)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating AP interface is brough down the mode is reset to
STA. This STA will be reconfigured into AP mode when the interface
is brought up again. This sequence will be successful only when
change_virtual_intf() returns with no error, but there is a
check in this callback which does the type change only when
that interface is active. This callback does nothing more
than saving the new interface type to vif and wdev, so the
sanity check for interface state and wmi state is not necessary.
This makes the AP interface functional again after interface down/up.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 08708bd..733cff0 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1353,9 +1353,6 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type %u\n", __func__, type);
 
-	if (!ath6kl_cfg80211_ready(vif))
-		return -EIO;
-
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
 		vif->next_mode = INFRA_NETWORK;
-- 
1.7.0.4

