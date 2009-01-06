Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:63614 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZAFNY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 08:24:59 -0500
Received: by ewy10 with SMTP id 10so8425040ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 05:24:57 -0800 (PST)
Message-ID: <eb3ff54b0901060524w2533510fk39c3b76be9b9b148@mail.gmail.com> (sfid-20090106_142503_343378_027141B0)
Date: Tue, 6 Jan 2009 15:24:57 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: [PATCH 5/6] [v2] mac80211: remove unused variable in ieee80211_local (dot11WEPUndecryptableCount).
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1231246945.3503.2.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0901060051x67121996ib7b1471e1e585ccf@mail.gmail.com>
	 <1231246945.3503.2.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes an unused declaration of dot11WEPUndecryptableCount
(an snmp counter) in ieee80211_local structure and its usage in
debugfs.c since this counter is not incremented/decremented anywhere.


(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2697a2f..18541bb 100644
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
@@ -221,7 +219,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_STATS_ADD(received_fragment_count);
 	DEBUGFS_STATS_ADD(multicast_received_frame_count);
 	DEBUGFS_STATS_ADD(transmitted_frame_count);
-	DEBUGFS_STATS_ADD(wep_undecryptable_count);
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	DEBUGFS_STATS_ADD(tx_handlers_drop);
 	DEBUGFS_STATS_ADD(tx_handlers_queued);
@@ -268,7 +265,6 @@ void debugfs_hw_del(struct ieee80211_local *local)
 	DEBUGFS_STATS_DEL(received_fragment_count);
 	DEBUGFS_STATS_DEL(multicast_received_frame_count);
 	DEBUGFS_STATS_DEL(transmitted_frame_count);
-	DEBUGFS_STATS_DEL(wep_undecryptable_count);
 	DEBUGFS_STATS_DEL(num_scans);
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	DEBUGFS_STATS_DEL(tx_handlers_drop);
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

On Tue, Jan 6, 2009 at 3:02 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2009-01-06 at 10:51 +0200, Rami Rosen wrote:
>> This patch removes and unused declaration of dot11WEPUndecryptableCount (an
>> snmp counter) in ieee80211_local structure ; this counter is not
>> incremented/decremented
>> anywhere.
>>
>>
>> (wireless-testing).
>>
>> Signed-off-by: Rami Rosen <ramirose@gmail.com>
>>
>> diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
>> index 2697a2f..39f00e1 100644
>> --- a/net/mac80211/debugfs.c
>> +++ b/net/mac80211/debugfs.c
>> @@ -136,8 +136,6 @@ DEBUGFS_STATS_FILE(multicast_received_frame_count, 20, "%u",
>>                  local->dot11MulticastReceivedFrameCount);
>>  DEBUGFS_STATS_FILE(transmitted_frame_count, 20, "%u",
>>                  local->dot11TransmittedFrameCount);
>> -DEBUGFS_STATS_FILE(wep_undecryptable_count, 20, "%u",
>> -                local->dot11WEPUndecryptableCount);
>
> this won't compile
>
> johannes
>
