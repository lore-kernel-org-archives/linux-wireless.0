Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39422 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3KAUFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 16:05:38 -0400
Received: by mail-ee0-f54.google.com with SMTP id c50so207eek.13
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 13:05:37 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath9k: dfs_debug fix possible NULL dereference
Date: Fri,  1 Nov 2013 21:05:28 +0100
Message-Id: <1383336328-16267-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131101_210546_329924_071AAAEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix possible NULL (sc->dfs_detector) pointer dereference.

Detected by Smatch:
drivers/net/wireless/ath/ath9k/dfs_debug.c:67 read_file_dfs()
error: we previously assumed 'sc->dfs_detector' could be null (see line 47)

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/dfs_debug.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.c b/drivers/net/wireless/ath/ath9k/dfs_debug.c
index 36cd82f..df00061 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.c
@@ -44,14 +44,20 @@ static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 	if (buf == NULL)
 		return -ENOMEM;
 
-	if (sc->dfs_detector)
-		dfs_pool_stats = sc->dfs_detector->get_stats(sc->dfs_detector);
-
 	len += snprintf(buf + len, size - len, "DFS support for "
 			 "macVersion = 0x%x, macRev = 0x%x: %s\n",
 			 hw_ver->macVersion, hw_ver->macRev,
 			 (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_DFS) ?
 					"enabled" : "disabled");
+
+	if (!sc->dfs_detector) {
+		len += snprintf(buf + len, size - len,
+				"DFS detector not enabled\n");
+		goto exit;
+	}
+
+	dfs_pool_stats = sc->dfs_detector->get_stats(sc->dfs_detector);
+
 	len += snprintf(buf + len, size - len, "Pulse detector statistics:\n");
 	ATH9K_DFS_STAT("pulse events reported   ", pulses_total);
 	ATH9K_DFS_STAT("invalid pulse events    ", pulses_no_dfs);
@@ -75,6 +81,7 @@ static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 	ATH9K_DFS_POOL_STAT("Seqs. alloc error       ", pseq_alloc_error);
 	ATH9K_DFS_POOL_STAT("Seqs. in use            ", pseq_used);
 
+exit:
 	if (len > size)
 		len = size;
 
-- 
1.7.9.5

