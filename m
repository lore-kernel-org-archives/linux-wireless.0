Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35779 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeHBFko (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 01:40:44 -0400
Received: by mail-pf1-f193.google.com with SMTP id p12-v6so503063pfh.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2018 20:51:39 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Subject: [PATCH v3 1/2] mac80211: invoke sw_scan if hw_scan returns EPERM
Date: Thu,  2 Aug 2018 09:00:45 +0530
Message-Id: <1533180646-8028-1-git-send-email-sushant2k1513@gmail.com> (sfid-20180802_055141_811857_426FAC5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sanjay Kumar Koduri <sanjay.konduri@redpinesignals.com>

Currently, software scan in mac80211 is used by drivers, which don't
implement hardware scan. However some drivers which have implemented
hardware scan may also sometimes want to use software scan in mac80211.
Such drivers can return '-EPERM' and ask mac80211 to fallback to
software scan with this patch.

Signed-off-by: Sanjay Kumar konduri <sanjay.konduri@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
---
changes in v3: Set SCAN_HW_CANCELLED bit, before SW_SCAN triggered.
changes in v2: Nothing
---
 net/mac80211/scan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 2e917a6..bb1029b 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -412,7 +412,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	/* Set power back to normal operating levels. */
 	ieee80211_hw_config(local, 0);
 
-	if (!hw_scan) {
+	if (!test_bit(SCAN_SW_SCANNING, &local->scanning)) {
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local, scan_sdata);
 		ieee80211_offchannel_return(local);
@@ -686,6 +686,11 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (local->ops->hw_scan) {
 		WARN_ON(!ieee80211_prep_hw_scan(local));
 		rc = drv_hw_scan(local, sdata, local->hw_scan_req);
+		if (rc == -EPERM) {
+			set_bit(SCAN_HW_CANCELLED, &local->scanning);
+			__set_bit(SCAN_SW_SCANNING, &local->scanning);
+			rc = ieee80211_start_sw_scan(local, sdata);
+		}
 	} else {
 		rc = ieee80211_start_sw_scan(local, sdata);
 	}
-- 
2.5.5
