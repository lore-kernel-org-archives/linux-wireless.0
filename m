Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:33741 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab1HWPez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 11:34:55 -0400
Received: by mail-bw0-f41.google.com with SMTP id zt4so199211bkb.28
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 08:34:54 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wl12xx: use SCAN_SSID_TYPE_PUBLIC when using the wildcard in sched_scan
Date: Tue, 23 Aug 2011 18:34:45 +0300
Message-Id: <1314113685-27437-3-git-send-email-coelho@ti.com> (sfid-20110823_173501_964738_73E03285)
In-Reply-To: <1314113685-27437-1-git-send-email-coelho@ti.com>
References: <1314113685-27437-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we are scanning for the wildcard SSID in a scheduled scan, we
should use SCAN_SSID_TYPE_PUBLIC so that we don't filter out the scan
results.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/scan.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index af9d53c..af4ad23 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -490,9 +490,12 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 		return -ENOMEM;
 
 	while ((cmd->n_ssids < req->n_ssids) && ssid) {
-		if (ssid->ssid_len == 0)
+		if (ssid->ssid_len == 0) {
 			wildcard = 1;
-		cmd->ssids[cmd->n_ssids].type = SCAN_SSID_TYPE_HIDDEN;
+			cmd->ssids[cmd->n_ssids].type = SCAN_SSID_TYPE_PUBLIC;
+		} else {
+			cmd->ssids[cmd->n_ssids].type = SCAN_SSID_TYPE_HIDDEN;
+		}
 		cmd->ssids[cmd->n_ssids].len = ssid->ssid_len;
 		memcpy(cmd->ssids[cmd->n_ssids].ssid, ssid->ssid,
 		       ssid->ssid_len);
-- 
1.7.1

