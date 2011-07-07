Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:36212 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708Ab1GGMSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 08:18:48 -0400
Received: by mail-bw0-f47.google.com with SMTP id 20so945675bwf.6
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jul 2011 05:18:47 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH 3.0] mac80211: fix ie memory allocation for scheduled scans
Date: Thu,  7 Jul 2011 15:18:27 +0300
Message-Id: <1310041107-7053-1-git-send-email-coelho@ti.com> (sfid-20110707_141858_840510_293D8304)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were not allocating memory for the IEs passed in the scheduled_scan
request and this was causing memory corruption (buffer overflow).

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/mac80211/scan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index e5a6ea4..08a45ac 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -884,7 +884,8 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		local->sched_scan_ies.ie[i] = kzalloc(2 +
 						      IEEE80211_MAX_SSID_LEN +
-						      local->scan_ies_len,
+						      local->scan_ies_len +
+						      req->ie_len,
 						      GFP_KERNEL);
 		if (!local->sched_scan_ies.ie[i]) {
 			ret = -ENOMEM;
-- 
1.7.1

