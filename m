Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60256 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab1CVIHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 04:07:53 -0400
Received: by bwz15 with SMTP id 15so5635514bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 01:07:51 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: configure channel/band while FW is off
Date: Tue, 22 Mar 2011 10:07:47 +0200
Message-Id: <1300781267-4047-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize the channel and band from mac80211 conf even when the FW is
not yet loaded. This mitigates a bug in AP-mode where the channel was
never changed from its initial setting after FW boot and was therefore
never configured to FW.

Reported-by: Alexander Boukaty <alexanderb@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85cb4da..c262e60 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1707,7 +1707,12 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state == WL1271_STATE_OFF)) {
-		ret = -EAGAIN;
+		/* we support configuring the channel and band while off */
+		if ((changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
+			wl->band = conf->channel->band;
+			wl->channel = channel;
+		}
+
 		goto out;
 	}
 
-- 
1.7.1

