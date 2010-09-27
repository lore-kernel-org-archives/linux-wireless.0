Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17067 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844Ab0I0IjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:39:15 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8d5dI026506
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:39:14 -0500
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8boh2022566
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:37:58 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 06/25] wl1271: fix forced passive scan
Date: Mon, 27 Sep 2010 11:37:30 +0300
Message-Id: <1285576669-8070-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we get no SSIDs in the scan request, we should force a passive scan in
all channels.  This patch adds code to force the passive scan flag to be set
in that case.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_scan.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c b/drivers/net/wireless/wl12xx/wl1271_scan.c
index 8ceaabe..7f42ca9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_scan.c
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
@@ -100,8 +100,11 @@ static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
 
 	/* We always use high priority scans */
 	scan_options = WL1271_SCAN_OPT_PRIORITY_HIGH;
-	if(passive)
+
+	/* No SSIDs means that we have a forced passive scan */
+	if (passive || wl->scan.req->n_ssids == 0)
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
+
 	cmd->params.scan_options = cpu_to_le16(scan_options);
 
 	cmd->params.n_ch = wl1271_get_scan_channels(wl, wl->scan.req,
-- 
1.6.3.3

