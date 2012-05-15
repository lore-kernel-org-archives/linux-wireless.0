Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63435 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954Ab2EONrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 09:47:03 -0400
Received: by wgbdr13 with SMTP id dr13so5793940wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 06:47:02 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 1/3] wlcore: flush tx on CHANGE_CHANNEL
Date: Tue, 15 May 2012 16:46:56 +0300
Message-Id: <1337089618-12450-1-git-send-email-arik@wizery.com> (sfid-20120515_154715_344926_B0E7DDEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

On CHANGE_CHANNEL indication, we should flush all the
queued tx frames, so they will be sent on the correct
(current) channel.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v1->2: added SOB tag by eliad

 drivers/net/wireless/ti/wlcore/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ebbedbf..4e71078 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2553,8 +2553,9 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	 * frames, such as the deauth. To make sure those frames reach the air,
 	 * wait here until the TX queue is fully flushed.
 	 */
-	if ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
-	    (conf->flags & IEEE80211_CONF_IDLE))
+	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) ||
+	    ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
+	     (conf->flags & IEEE80211_CONF_IDLE)))
 		wl1271_tx_flush(wl);
 
 	mutex_lock(&wl->mutex);
-- 
1.7.9.5

