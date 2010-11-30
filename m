Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:49382 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab0K3NCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 08:02:35 -0500
From: luciano.coelho@nokia.com
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com, j.de.gram@gmail.com
Subject: [PATCH] wl12xx: fix illegal memset if debugfs is not enabled
Date: Tue, 30 Nov 2010 15:03:13 +0200
Message-Id: <1291122193-3409-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

If we try to reset the debugfs statistics when debugfs is not configured in
the kernel, we're memset an illegal pointer, because it has never been
allocated.  So check whether we have debugfs enabled by looking into the
wl->rootdir before trying to reset the fw_stats struct.

Reported-by: Joerie de Gram <j.de.gram@gmail.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 2ac289e..8106a6c 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -414,6 +414,9 @@ err:
 
 void wl1271_debugfs_reset(struct wl1271 *wl)
 {
+	if (!wl->rootdir)
+		return;
+
 	memset(wl->stats.fw_stats, 0, sizeof(*wl->stats.fw_stats));
 	wl->stats.retry_count = 0;
 	wl->stats.excessive_retries = 0;
-- 
1.7.0.4

