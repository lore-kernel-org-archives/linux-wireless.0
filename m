Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44727 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab0HVVsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 17:48:32 -0400
Received: by fxm13 with SMTP id 13so2602581fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 14:48:30 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: cancel restart_work in ieee80211_unregister_hw
Date: Sun, 22 Aug 2010 23:48:25 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008222348.25668.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unlike most other workqueue-tasks, the restart_work is
not scheduled onto mac80211's private per-interface
workqueue, but onto one of the system-wide workqueues.

Therefore the mac80211-stack has to cancel any pending
restarts, before destroying the shared device context
and handing back the memory. Otherwise - under very
unlucky circumstances - there could be a stale work-
item left, because some other kernel component might
have delayed the execution of ieee80211_restart_work
for too long.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Sure, normally a device doesn't simply disappear,
but you know: restarts might take some time (fw upload,
phy/mac/crypto reinit, etc.) to finish and some
impatient user might want to speed  things up by
_simply_ replugging the USB device...

But don't ask me what this "elusive" kernel component
could be, I stumbled upon this theoretical bug, while
reviewing code in order to prevent crashes from a
driver, which relies on a fully functional restart
support.
---
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a53feac..74e3529 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -807,6 +807,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	rtnl_unlock();
 
+	cancel_work_sync(&local->restart_work);
 	cancel_work_sync(&local->reconfig_filter);
 
 	ieee80211_clear_tx_pending(local);
