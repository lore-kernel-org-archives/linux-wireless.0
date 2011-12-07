Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40184 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab1LGKhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 05:37:15 -0500
Received: by bkbzv3 with SMTP id zv3so259546bkb.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2011 02:37:14 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: minor fix in sched_scan_ssid_list
Date: Wed,  7 Dec 2011 12:37:04 +0200
Message-Id: <1323254224-8272-1-git-send-email-eyal@wizery.com> (sfid-20111207_113728_926589_F801EF8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The user can pass broadcast SSID (ssid="") in the list of SSIDs for active scan.
In this case the loop was attempting to match SSIDs in the filter
list to this empty entry and marking them as HIDDEN (sending probe
request) by mistake

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/wl12xx/scan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 330d678..8599dab 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -572,6 +572,9 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 			 * so they're used in probe requests.
 			 */
 			for (i = 0; i < req->n_ssids; i++) {
+				if (!req->ssids[i].ssid_len)
+					continue;
+
 				for (j = 0; j < cmd->n_ssids; j++)
 					if (!memcmp(req->ssids[i].ssid,
 						   cmd->ssids[j].ssid,
-- 
1.7.4.1

