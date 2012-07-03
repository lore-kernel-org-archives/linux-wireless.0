Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43124 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2GCNoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 09:44:03 -0400
Received: by wgbds11 with SMTP id ds11so3791320wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 06:44:02 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wlcore: check ssid length against the correct element
Date: Tue,  3 Jul 2012 16:44:01 +0300
Message-Id: <1341323041-8946-1-git-send-email-eliad@wizery.com> (sfid-20120703_154408_516294_FEE19D44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 587cc28 ("wlcore: compare ssid_len before comparing
ssids") introduced a new bug - the ssid length from the
request struct was compared against the ssid length of
another request, instead the one of the cmd.

This might cause the sched scan request to fail
(with -EINVAL) in many cases.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 524afe0..467e244 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -658,7 +658,7 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 
 				for (j = 0; j < cmd->n_ssids; j++)
 					if ((req->ssids[i].ssid_len ==
-					     req->ssids[j].ssid_len) &&
+					     cmd->ssids[j].len) &&
 					    !memcmp(req->ssids[i].ssid,
 						   cmd->ssids[j].ssid,
 						   req->ssids[i].ssid_len)) {
-- 
1.7.6.401.g6a319

