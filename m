Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61206 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab0I0VDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 17:03:12 -0400
Received: by fxm3 with SMTP id 3so2212882fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 14:03:10 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: fix hung workqueue
Date: Mon, 27 Sep 2010 23:03:01 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009272303.01535.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211: wait for scan work complete before
restarting hw", broke carl9170's restart path.

Previously it was possible to call ieee80211_restart_hw
from mac80211's internal workqueue. Now though it hangs
because of the flush_workqueue in the procedure.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 84bd38e..d9d3e9c 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -515,7 +515,7 @@ void carl9170_restart(struct ar9170 *ar, const enum carl9170_restart_reasons r)
 		return;
 
 	if (IS_ACCEPTING_CMD(ar) && !ar->needs_full_reset)
-		ieee80211_queue_work(ar->hw, &ar->restart_work);
+		schedule_work(&ar->restart_work);
 	else
 		carl9170_usb_reset(ar);
 
