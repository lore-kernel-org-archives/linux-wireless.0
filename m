Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:33389 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331Ab2GHHXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 03:23:49 -0400
Received: by lbgc1 with SMTP id c1so3896794lbg.29
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 00:23:46 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 6/8] wlcore: check ssid length against the correct element
Date: Sun,  8 Jul 2012 10:23:29 +0300
Message-Id: <1341732211-25871-7-git-send-email-coelho@ti.com> (sfid-20120708_092404_643667_5F007B36)
In-Reply-To: <1341732211-25871-1-git-send-email-coelho@ti.com>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

commit 587cc28 ("wlcore: compare ssid_len before comparing
ssids") introduced a new bug - the ssid length from the
request struct was compared against the ssid length of
another request, instead the one of the cmd.

This might cause the sched scan request to fail
(with -EINVAL) in many cases.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index b03eb9a..dbeca1b 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -633,7 +633,7 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 
 				for (j = 0; j < cmd->n_ssids; j++)
 					if ((req->ssids[i].ssid_len ==
-					     req->ssids[j].ssid_len) &&
+					     cmd->ssids[j].len) &&
 					    !memcmp(req->ssids[i].ssid,
 						   cmd->ssids[j].ssid,
 						   req->ssids[i].ssid_len)) {
-- 
1.7.10

