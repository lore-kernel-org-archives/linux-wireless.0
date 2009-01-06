Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:63013 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZAFIv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 03:51:27 -0500
Received: by ewy10 with SMTP id 10so8320917ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 00:51:26 -0800 (PST)
Message-ID: <eb3ff54b0901060051x67121996ib7b1471e1e585ccf@mail.gmail.com> (sfid-20090106_095130_702451_BF9290E3)
Date: Tue, 6 Jan 2009 10:51:26 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 5/6] mac80211: remove unused variable in ieee80211_local (dot11WEPUndecryptableCount).
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes and unused declaration of dot11WEPUndecryptableCount (an
snmp counter) in ieee80211_local structure ; this counter is not
incremented/decremented
anywhere.


(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2697a2f..39f00e1 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -136,8 +136,6 @@ DEBUGFS_STATS_FILE(multicast_received_frame_count, 20, "%u",
 		   local->dot11MulticastReceivedFrameCount);
 DEBUGFS_STATS_FILE(transmitted_frame_count, 20, "%u",
 		   local->dot11TransmittedFrameCount);
-DEBUGFS_STATS_FILE(wep_undecryptable_count, 20, "%u",
-		   local->dot11WEPUndecryptableCount);
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 DEBUGFS_STATS_FILE(tx_handlers_drop, 20, "%u",
 		   local->tx_handlers_drop);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 117718b..c45db51 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -650,7 +650,6 @@ struct ieee80211_local {
 	u32 dot11ReceivedFragmentCount;
 	u32 dot11MulticastReceivedFrameCount;
 	u32 dot11TransmittedFrameCount;
-	u32 dot11WEPUndecryptableCount;

 #ifdef CONFIG_MAC80211_LEDS
 	int tx_led_counter, rx_led_counter;
