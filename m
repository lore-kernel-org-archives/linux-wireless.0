Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42584 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1KHNy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 08:54:57 -0500
Received: by mail-fx0-f46.google.com with SMTP id n17so524450faa.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 05:54:56 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: fix wl12xx_scan_sched_scan_ssid_list() check that all given ssids are in filters
Date: Tue,  8 Nov 2011 15:54:46 +0200
Message-Id: <1320760486-19700-1-git-send-email-eyal@wizery.com> (sfid-20111108_145520_175553_FAE345B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A minor fix for the check that verifies that all given SSIDs (in req) exist
in the filters (the match sets)

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/wl12xx/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 128ccb7..fc29c67 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -559,7 +559,7 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 						break;
 					}
 				/* Fail if SSID isn't present in the filters */
-				if (j == req->n_ssids) {
+				if (j == cmd->n_ssids) {
 					ret = -EINVAL;
 					goto out_free;
 				}
-- 
1.7.4.1

