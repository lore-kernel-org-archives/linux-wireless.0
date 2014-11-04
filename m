Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43844 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaKDXYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 18:24:02 -0500
From: greearb@candelatech.com
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org, rmanohar@qti.qualcomm.com,
	nbd@openwrt.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath9k:  fix regression in bssidmask calculation
Date: Tue,  4 Nov 2014 15:22:50 -0800
Message-Id: <1415143370-15173-2-git-send-email-greearb@candelatech.com> (sfid-20141105_002408_545863_3603EAAC)
In-Reply-To: <1415143370-15173-1-git-send-email-greearb@candelatech.com>
References: <1415143370-15173-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The commit that went into 3.17:

    ath9k: Summarize hw state per channel context

    Group and set hw state (opmode, primary_sta, beacon conf) per
    channel context instead of whole list of vifs. This would allow
    each channel context to run in different mode (STA/AP).

    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

broke multi-vif configuration due to not properly calculating
the bssid mask.

The test case that caught this was:

 create wlan0 and sta0-4 (6 total), not sure how much that matters.
 associate all 6 (works fine)
 disconnect 5 of them, leaving sta0 up
 Start trying to bring up the other 5 one at a time.  It will
 fail, with iw events looking like this (in these logs, several
 sta are trying to come up, but symptom is the same with just one)

The patch causing the regression made quite a few changes, but
the part I think caused this particular problem was not
recalculating the bssid mask when adding and removing interfaces.

Re-adding those calls fixes my test case.  Fix bad comment
as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This needs to be reviewed by ath9k driver folks that added
the original patch, at least.

And, should be considered for 3.17 stable if fix is accepted upstream.

 drivers/net/wireless/ath/ath9k/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index fbf23ac..d2ad9e95 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -947,9 +947,8 @@ void ath9k_calculate_iter_data(struct ath_softc *sc,
 	struct ath_vif *avp;
 
 	/*
-	 * Pick the MAC address of the first interface as the new hardware
-	 * MAC address. The hardware will use it together with the BSSID mask
-	 * when matching addresses.
+	 * The hardware will use primary station addr together with the
+	 * BSSID mask when matching addresses.
 	 */
 	memset(iter_data, 0, sizeof(*iter_data));
 	memset(&iter_data->mask, 0xff, ETH_ALEN);
@@ -1169,6 +1168,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		list_add_tail(&avp->list, &avp->chanctx->vifs);
 	}
 
+	ath9k_calculate_summary_state(sc, avp->chanctx);
+
 	ath9k_assign_hw_queues(hw, vif);
 
 	an->sc = sc;
@@ -1238,6 +1239,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	ath_tx_node_cleanup(sc, &avp->mcast_node);
 
+	ath9k_calculate_summary_state(sc, avp->chanctx);
+
 	mutex_unlock(&sc->mutex);
 }
 
-- 
1.9.3

