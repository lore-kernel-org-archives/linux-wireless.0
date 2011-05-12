Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:38814 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757499Ab1ELOQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:16:00 -0400
Received: by eya28 with SMTP id 28so638521eya.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 07:15:58 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] wl12xx: prevent sched_scan when not idle or not in station mode
Date: Thu, 12 May 2011 17:15:39 +0300
Message-Id: <1305209740-30287-7-git-send-email-coelho@ti.com> (sfid-20110512_161606_231725_A9BBE51E)
In-Reply-To: <1305209740-30287-1-git-send-email-coelho@ti.com>
References: <1305209740-30287-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current firmware only supports scheduled scan in station mode and
when idle.  To prevent the firmware from crashing, return -EOPNOTSUPP
when sched_scan start is called in an invalid state.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/scan.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 668ff46..f37e5a3 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -505,6 +505,12 @@ int wl1271_scan_sched_scan_start(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_CMD, "cmd periodic scan start");
 
+	if (wl->bss_type != BSS_TYPE_STA_BSS)
+		return -EOPNOTSUPP;
+
+	if (!test_bit(WL1271_FLAG_IDLE, &wl->flags))
+		return -EBUSY;
+
 	start = kzalloc(sizeof(*start), GFP_KERNEL);
 	if (!start)
 		return -ENOMEM;
-- 
1.7.1

