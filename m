Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:54129 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZGYVp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 17:45:57 -0400
Received: by ewy26 with SMTP id 26so2440131ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 14:45:57 -0700 (PDT)
Message-ID: <4A6B7DB0.7090902@gmail.com>
Date: Sat, 25 Jul 2009 23:48:32 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ipw2x00: Write outside array bounds
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

channel_index loops up to IPW_SCAN_CHANNELS, but is used after being
incremented. This might be able to access 1 past the end of the array

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 44c29b3..d1c9d6d 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -6249,7 +6249,10 @@ static void ipw_add_scan_channels(struct ipw_priv *priv,
 
 				channels[channel - 1] = 1;
 				priv->speed_scan_pos++;
-				channel_index++;
+
+				if (++channel_index >= IPW_SCAN_CHANNELS)
+					break;
+
 				scan->channels_list[channel_index] = channel;
 				index =
 				    ieee80211_channel_to_index(priv->ieee, channel);
