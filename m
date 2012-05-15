Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63435 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959Ab2EONrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 09:47:07 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so5793940wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 06:47:06 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 3/3] wlcore: remove duplicate BUG_ON during recovery
Date: Tue, 15 May 2012 16:46:58 +0300
Message-Id: <1337089618-12450-3-git-send-email-arik@wizery.com> (sfid-20120515_154716_510568_2BB52114)
In-Reply-To: <1337089618-12450-1-git-send-email-arik@wizery.com>
References: <1337089618-12450-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This BUG_ON also ignored the INTENDED_FW_RECOVERY flag. This would
result in a BUG() when using the bug_on_recovery module parameter during
multi-role.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 4e71078..f4b036e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -852,8 +852,6 @@ static void wl1271_recovery_work(struct work_struct *work)
 		goto out_unlock;
 	}
 
-	BUG_ON(bug_on_recovery);
-
 	/*
 	 * Advance security sequence number to overcome potential progress
 	 * in the firmware during recovery. This doens't hurt if the network is
-- 
1.7.9.5

