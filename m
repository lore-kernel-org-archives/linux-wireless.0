Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.243]:17530 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750917AbYBCO4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:56:45 -0500
Received: by hs-out-2122.google.com with SMTP id 54so1608907hsz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:56:43 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/19] rt2x00: Use ieee80211_channel_to_frequency()
Date: Sun, 3 Feb 2008 15:52:45 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031552.45489.IvDoorn@gmail.com> (sfid-20080203_145652_827276_7118EF3D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to perform the calculation ourselves when
wireless provides a helper function for it.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 21d8514..9a6ede0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -824,10 +824,7 @@ static void rt2x00lib_channel(struct ieee80211_channel *entry,
 			      const int channel, const int tx_power,
 			      const int value)
 {
-	if (channel <= 14)
-		entry->center_freq = 2407 + (5 * channel);
-	else
-		entry->center_freq = 5000 + (5 * channel);
+	entry->center_freq = ieee80211_channel_to_frequency(channel);
 	entry->hw_value = value;
 	entry->max_power = tx_power;
 	entry->max_antenna_gain = 0xff;
-- 
1.5.3.8

