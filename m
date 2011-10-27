Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:43721 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1J0Pr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 11:47:56 -0400
Subject: [PATCH 01/10] ath6kl: don't use cfg80211_scan_request after
	cfg80211_scan_done()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Oct 2011 18:47:46 +0300
Message-ID: <20111027154746.23519.39680.stgit@localhost6.localdomain6> (sfid-20111027_174800_195025_4B13DBA1)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use of cfg80211_scan_request is not valid after calling cfg80211_scan_done()
but ath6kl_cfg80211_scan_complete_event() was doing exactly that. Change
the function to call cfg80211_scan_done() last.

This was found during code review, I didn't see any visible problems
due to this bug.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0b044aa..f5f4a1d 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -874,6 +874,7 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, int status)
 {
 	struct ath6kl *ar = vif->ar;
+	bool aborted;
 	int i;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: status %d\n", __func__, status);
@@ -882,11 +883,11 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, int status)
 		return;
 
 	if ((status == -ECANCELED) || (status == -EBUSY)) {
-		cfg80211_scan_done(vif->scan_req, true);
+		aborted = true;
 		goto out;
 	}
 
-	cfg80211_scan_done(vif->scan_req, false);
+	aborted = false;
 
 	if (vif->scan_req->n_ssids && vif->scan_req->ssids[0].ssid_len) {
 		for (i = 0; i < vif->scan_req->n_ssids; i++) {
@@ -897,6 +898,7 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, int status)
 	}
 
 out:
+	cfg80211_scan_done(vif->scan_req, aborted);
 	vif->scan_req = NULL;
 }
 

