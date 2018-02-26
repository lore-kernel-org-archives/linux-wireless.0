Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43162 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbeBZGRG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 01:17:06 -0500
From: Karthikeyan Periyasamy <periyasa@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>
Subject: [PATCH] Revert "ath10k: send (re)assoc peer command when NSS changed"
Date: Mon, 26 Feb 2018 11:46:32 +0530
Message-Id: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org> (sfid-20180226_071712_185325_6EB40C42)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 55884c045d31a29cf69db8332d1064a1b61dd159.

When Ath10k is in AP mode and an unassociated STA sends a VHT action frame
(Operating Mode Notification for the NSS change) periodically to AP this causes
ath10k to call ath10k_station_assoc() which sends WMI_PEER_ASSOC_CMDID during
NSS update. Over the time (with a certain client it can happen within 15 mins
when there are over 500 of these VHT action frames) continuous calls of
WMI_PEER_ASSOC_CMDID cause firmware to assert due to resource exhaust.

To my knowledge setting WMI_PEER_NSS peer param itself enough to handle NSS
updates and no need to call ath10k_station_assoc(). So revert the original
commit from 2014 as it's unclear why the change was really needed.
Now the firmware assert doesn't happen anymore.

Issue observed in QCA9984 platform with firmware version:10.4-3.5.3-00053.
This Change tested in QCA9984 with firmware version: 10.4-3.5.3-00053 and
QCA988x platform with firmware version: 10.2.4-1.0-00036.

Signed-off-by: Karthikeyan Periyasamy <periyasa@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ebb3f1b..800a86e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6028,9 +6028,8 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 				    sta->addr, smps, err);
 	}
 
-	if (changed & IEEE80211_RC_SUPP_RATES_CHANGED ||
-	    changed & IEEE80211_RC_NSS_CHANGED) {
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac update sta %pM supp rates/nss\n",
+	if (changed & IEEE80211_RC_SUPP_RATES_CHANGED) {
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac update sta %pM supp rates\n",
 			   sta->addr);
 
 		err = ath10k_station_assoc(ar, arvif->vif, sta, true);
-- 
1.9.1
