Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:32830 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756554Ab2F0Pgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:36:33 -0400
Received: by lbon10 with SMTP id n10so3179013lbo.27
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:36:24 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 5/8] wlcore: avoid debug prints during intended FW recovery
Date: Wed, 27 Jun 2012 18:35:59 +0300
Message-Id: <1340811362-30441-6-git-send-email-coelho@ti.com> (sfid-20120627_173637_183117_88DA4B76)
In-Reply-To: <1340811362-30441-1-git-send-email-coelho@ti.com>
References: <1340811362-30441-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Don't read the FW panic log or print other debug data when recovery is
intended (i.e. FW type switch). This takes valuable time and can be
confusing to the user.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 1d404fa..49990b1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -916,9 +916,10 @@ static void wl1271_recovery_work(struct work_struct *work)
 	if (wl->state != WL1271_STATE_ON || wl->plt)
 		goto out_unlock;
 
-	wl12xx_read_fwlog_panic(wl);
-
-	wlcore_print_recovery(wl);
+	if (!test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags)) {
+		wl12xx_read_fwlog_panic(wl);
+		wlcore_print_recovery(wl);
+	}
 
 	BUG_ON(bug_on_recovery &&
 	       !test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
-- 
1.7.10

