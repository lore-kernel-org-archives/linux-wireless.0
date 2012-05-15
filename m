Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36064 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965251Ab2EOPb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 11:31:56 -0400
Received: by wgbdr13 with SMTP id dr13so5936852wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 08:31:55 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wlcore: compare ssid_len before comparing ssids
Date: Tue, 15 May 2012 18:31:58 +0300
Message-Id: <1337095918-8903-1-git-send-email-eliad@wizery.com> (sfid-20120515_173200_412067_6BADB37A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When comparing 2 ssids the ssid_len must be taken
into account. Otherwise, a substring will be treated
as equal.

This bug might cause ssids to get scanned as
public ssids (rather than hidden), resulting in
broadcast probe request (instead of ssid-specific
ones)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/scan.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index ade21a0..267a3a3 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -603,7 +603,9 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 					continue;
 
 				for (j = 0; j < cmd->n_ssids; j++)
-					if (!memcmp(req->ssids[i].ssid,
+					if ((req->ssids[i].ssid_len ==
+					     req->ssids[j].ssid_len) &&
+					    !memcmp(req->ssids[i].ssid,
 						   cmd->ssids[j].ssid,
 						   req->ssids[i].ssid_len)) {
 						cmd->ssids[j].type =
-- 
1.7.6.401.g6a319

