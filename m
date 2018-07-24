Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:25495 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388424AbeGXIuD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:50:03 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 11/19] wil6210: allow scan on AP interface
Date: Tue, 24 Jul 2018 10:44:32 +0300
Message-Id: <1532418280-5849-12-git-send-email-merez@codeaurora.org> (sfid-20180724_094514_799446_44E16EFA)
In-Reply-To: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
References: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ahmad Masri <amasri@codeaurora.org>

Scan is allowed only on client interfaces (STA/P2P).
Allow scan on AP interface so that the AP can discover rouge
or unauthorized neighbor APs.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index dfe64b0..80975c4 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -689,11 +689,12 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 
 	wil_dbg_misc(wil, "scan: wdev=0x%p iftype=%d\n", wdev, wdev->iftype);
 
-	/* check we are client side */
+	/* scan is supported on client interfaces and on AP interface */
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_AP:
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
1.9.1
