Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52969 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab0KCVvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 17:51:06 -0400
Received: by fxm16 with SMTP id 16so938815fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 14:51:05 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Cc: Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/4] mac80211: add fragmentation offload definitions
Date: Wed,  3 Nov 2010 23:50:50 +0200
Message-Id: <1288821053-19013-2-git-send-email-arik@wizery.com>
In-Reply-To: <1288821053-19013-1-git-send-email-arik@wizery.com>
References: <1288821053-19013-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define a flag to indicate hardware TX fragmentation and a callback in
mac80211_ops to update the fragmentation threshold in the driver.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9fdf982..25ced5c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1048,6 +1048,11 @@ enum ieee80211_tkip_key_type {
  *	to decrypt group addressed frames, then IBSS RSN support is still
  *	possible but software crypto will be used. Advertise the wiphy flag
  *	only in that case.
+ *
+ * @IEEE80211_HW_TX_FRAGMENTATION: Packet fragmentation is done in hardware.
+ *	The stack does not fragment packets in this case. The driver must
+ *	update its internal fragmentation threshold by implementing the
+ *	set_frag_threshold callback.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1072,6 +1077,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
 	IEEE80211_HW_SUPPORTS_CQM_RSSI			= 1<<20,
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
+	IEEE80211_HW_TX_FRAGMENTATION			= 1<<22,
 };
 
 /**
@@ -1652,6 +1658,11 @@ enum ieee80211_ampdu_mlme_action {
  *	and IV16) for the given key from hardware.
  *	The callback must be atomic.
  *
+ * @set_frag_threshold: Configuration of fragmentation threshold. Assign this if
+ *	the device does fragmentation by itself; if this method is assigned then
+ *	the stack will not do fragmentation.
+ *	The callback can sleep.
+ *
  * @set_rts_threshold: Configuration of RTS threshold (if device needs it)
  *	The callback can sleep.
  *
@@ -1765,6 +1776,7 @@ struct ieee80211_ops {
 			 struct ieee80211_low_level_stats *stats);
 	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
 			     u32 *iv32, u16 *iv16);
+	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*sta_add)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
-- 
1.7.1

