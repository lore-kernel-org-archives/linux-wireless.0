Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38850 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1ARTmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 14:42:12 -0500
Received: by wyb28 with SMTP id 28so6495367wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 11:42:11 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] wl12xx: Add channel 14 to list of supported 2ghz channels
Date: Tue, 18 Jan 2011 21:39:52 +0200
Message-Id: <1295379592-6223-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel 14 is only supported in Japan (JP country code in).
The FW limits tranmissions to CCK only on this channel.

Tested in both STA and AP modes to work correctly.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9076555..59582ab 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2771,6 +2771,7 @@ static struct ieee80211_channel wl1271_channels[] = {
 	{ .hw_value = 11, .center_freq = 2462, .max_power = 25 },
 	{ .hw_value = 12, .center_freq = 2467, .max_power = 25 },
 	{ .hw_value = 13, .center_freq = 2472, .max_power = 25 },
+	{ .hw_value = 14, .center_freq = 2484, .max_power = 25 },
 };
 
 /* mapping to indexes for wl1271_rates */
-- 
1.7.1

