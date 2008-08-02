Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:39097 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbYHBOYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 10:24:07 -0400
Received: by nf-out-0910.google.com with SMTP id d3so552092nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 07:24:05 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix OOPS on failed creation of rt2x00lib workqueue
Date: Sat, 2 Aug 2008 16:46:48 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808021646.49158.IvDoorn@gmail.com> (sfid-20080802_162415_275712_BD26464A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From a0e6b7826159f3e0eb86a8de74a2bb873b40039c Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Fri, 1 Aug 2008 09:07:21 +0100
Subject: [PATCH] rt2x00: Fix OOPS on failed creation of rt2x00lib workqueue

This fixes a corner case when the rt2x00lib workqueue fails to be created
and rt2x00lib_remove_dev() tries to delete the non-existant workqueue and
causes an OOPS.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
This patch is intended for 2.6.26-stable only, the code in question was introduced
in 2.6.26 and removed for 2.6.27. The bug which is triggered is rare in normal cases,
but guarenteed when using the wrong driver for the wrong hardware (which can
happen when the same USB ID is used in both drivers).

 drivers/net/wireless/rt2x00/rt2x00dev.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c997d4f..dde6078 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1198,8 +1198,10 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	 * Stop all queued work. Note that most tasks will already be halted
 	 * during rt2x00lib_disable_radio() and rt2x00lib_uninitialize().
 	 */
-	flush_workqueue(rt2x00dev->workqueue);
-	destroy_workqueue(rt2x00dev->workqueue);
+	if (rt2x00dev->workqueue) {
+		flush_workqueue(rt2x00dev->workqueue);
+		destroy_workqueue(rt2x00dev->workqueue);
+	}
 
 	/*
 	 * Free ieee80211_hw memory.
-- 
1.5.4.3

