Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f43.google.com ([209.85.215.43]:39794 "EHLO
	mail-ew0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab1IOKFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 06:05:23 -0400
Received: by ewy20 with SMTP id 20so1654444ewy.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 03:05:22 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: send all pending packets on channel change
Date: Thu, 15 Sep 2011 13:00:01 +0300
Message-Id: <1316080801-20803-1-git-send-email-eliad@wizery.com> (sfid-20110915_120526_916505_F9F75C28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a race condition between wl1271_tx_work() and the
channel switch, so make sure all the pending packets are
being sent before switching channel.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 680f558..bf655c4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2355,6 +2355,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
 	    ((wl->band != conf->channel->band) ||
 	     (wl->channel != channel))) {
+		/* send all pending packets */
+		wl1271_tx_work_locked(wl);
 		wl->band = conf->channel->band;
 		wl->channel = channel;
 
-- 
1.7.6.401.g6a319

