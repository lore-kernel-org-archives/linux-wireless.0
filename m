Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38638 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2E2SM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 14:12:59 -0400
From: Kiran Reddy <c_lreddy@qca.qualcomm.com>
To: <ath6kl-devel@qualcomm.com>, <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3] ath6kl: separate ht cap for each band
Date: Tue, 29 May 2012 11:12:50 -0700
Message-ID: <1338315170-9940-1-git-send-email-c_lreddy@qca.qualcomm.com> (sfid-20120529_201305_328609_F1CFA3B0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In virtual interface structure, for each band separate ht cap
is needed. so that one can disable or enable ht capability band
wise.
This will fix the following issue:

1) Disable 11n from supplicant and start a P2P GO.
2) In beacon frames no HT-CAP IE is seen which is expected.
3) Now remove the P2P GO and kill the supplicant.
4) Beacon stops
5) Now using iw  associate to an external AP in 5 GHZ
6) In 5 GHZ no HT IE going in assoc request but
when  associated in 2.4 GHZ can see HT IES over the air
in assoc request.

In the code for del_beacon in cfg80211.c,set_ht_cap is being
called first for 2.4 GHZ and then for 5 GHZ. When  called
for the first time for 2.4 GHZ the enable flag will be set to true
and so when called for the second time for 5 GHZ it just returns
after checking the flag.

Also using this one can have different HT capabilities
per band (for example one may decide not to use 20/40 in 2.4 GHZ
but use it in 5 GHZ). So maintaining a single context is not ok.
it is true for even the enable/disable flag and other HT
capabilities as well

Signed-off-by: Kiran Reddy <c_lreddy@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    5 +++--
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 7845d33..17f09d1 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2540,7 +2540,7 @@ void ath6kl_check_wow_status(struct ath6kl *ar)
 static int ath6kl_set_htcap(struct ath6kl_vif *vif, enum ieee80211_band band,
 			    bool ht_enable)
 {
-	struct ath6kl_htcap *htcap = &vif->htcap;
+	struct ath6kl_htcap *htcap = &vif->htcap[band];
 
 	if (htcap->ht_enable == ht_enable)
 		return 0;
@@ -3513,7 +3513,8 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	vif->listen_intvl_t = ATH6KL_DEFAULT_LISTEN_INTVAL;
 	vif->bmiss_time_t = ATH6KL_DEFAULT_BMISS_TIME;
 	vif->bg_scan_period = 0;
-	vif->htcap.ht_enable = true;
+	vif->htcap[IEEE80211_BAND_2GHZ].ht_enable = true;
+	vif->htcap[IEEE80211_BAND_5GHZ].ht_enable = true;
 
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
 	if (fw_vif_idx != 0)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 991bd96..c287862 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -556,7 +556,7 @@ struct ath6kl_vif {
 	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
 	struct ath6kl_key keys[WMI_MAX_KEY_INDEX + 1];
 	struct aggr_info *aggr_cntxt;
-	struct ath6kl_htcap htcap;
+	struct ath6kl_htcap htcap[IEEE80211_NUM_BANDS];
 
 	struct timer_list disconnect_timer;
 	struct timer_list sched_scan_timer;
-- 
1.7.8.3

