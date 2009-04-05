Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1612 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbZDECLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2009 22:11:07 -0400
From: Bob Copeland <me@bobcopeland.com>
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 5/6] wl12xx: update config callback parameters
Date: Sat,  4 Apr 2009 22:10:27 -0400
Message-Id: <1238897428-19639-6-git-send-email-me@bobcopeland.com> (sfid-20090405_041120_783411_3DEF26C2)
In-Reply-To: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update wl12xx to use new parameters for ops->config.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dd3c277..76b1efc 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -681,10 +681,10 @@ out:
 	return ret;
 }
 
-static int wl12xx_op_config(struct ieee80211_hw *hw,
-			    struct ieee80211_conf *conf)
+static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct wl12xx *wl = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
 	int channel, ret = 0;
 
 	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
-- 
1.6.0.6


