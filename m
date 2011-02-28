Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48485 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1B1QsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 11:48:17 -0500
Received: by fxm17 with SMTP id 17so3915244fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 08:48:16 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/9] [{mac|nl}80211] Add 2 new radar channel flags
Date: Mon, 28 Feb 2011 17:47:06 +0100
Cc: lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
In-Reply-To: <201102281740.37036.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201102281747.06564.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DFS introduces 2 new flags a channel requiring radar detection
might take. The interference flag indicates that interference was
detected either during CAC or in-service monitoring and the
channel is not to be used for the NOP period. The clear flag
indicates that during a full CAC no interference was detected and
it is allowed to open a BSS on that channel. The case were both
flags are set is used to indicate that interference has been
detected and we are in progress of closing on that channel.

Signed-off-by: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
---
 include/linux/nl80211.h |    6 ++++++
 include/net/cfg80211.h  |   18 ++++++++++++------
 net/mac80211/cfg.c      |    6 ++++++
 net/mac80211/tx.c       |    6 ++++--
 net/wireless/nl80211.c  |    4 ++++
 5 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e3c9ec7..2282f56 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1371,6 +1371,10 @@ enum nl80211_band_attr {
  *	(100 * dBm).
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
+ * @NL80211_FREQUENCY_ATTR_RADAR_CLEAR: during a full CAC no interference has
+ *	been detected.
+ * @NL80211_FREQUENCY_ATTR_RADAR_INTERFERENCE: either during a CAC or
+ *	in-service monitoring radar interference was detected.
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_frequency_attr {
@@ -1381,6 +1385,8 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_IBSS,
 	NL80211_FREQUENCY_ATTR_RADAR,
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
+	NL80211_FREQUENCY_ATTR_RADAR_CLEAR,
+	NL80211_FREQUENCY_ATTR_RADAR_INTERFERENCE,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8300699..5636c0a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -98,14 +98,20 @@ enum ieee80211_band {
  * 	is not permitted.
  * @IEEE80211_CHAN_NO_HT40MINUS: extension channel below this channel
  * 	is not permitted.
+ * @IEEE80211_CHAN_RADAR_CLEAR: during a full CAC no interference has
+ *	been detected.
+ * @IEEE80211_CHAN_RADAR_INTERFERENCE: either during a CAC or in-service
+ *	monitoring radar interference was detected.
  */
 enum ieee80211_channel_flags {
-	IEEE80211_CHAN_DISABLED		= 1<<0,
-	IEEE80211_CHAN_PASSIVE_SCAN	= 1<<1,
-	IEEE80211_CHAN_NO_IBSS		= 1<<2,
-	IEEE80211_CHAN_RADAR		= 1<<3,
-	IEEE80211_CHAN_NO_HT40PLUS	= 1<<4,
-	IEEE80211_CHAN_NO_HT40MINUS	= 1<<5,
+	IEEE80211_CHAN_DISABLED			= 1<<0,
+	IEEE80211_CHAN_PASSIVE_SCAN		= 1<<1,
+	IEEE80211_CHAN_NO_IBSS			= 1<<2,
+	IEEE80211_CHAN_RADAR			= 1<<3,
+	IEEE80211_CHAN_NO_HT40PLUS		= 1<<4,
+	IEEE80211_CHAN_NO_HT40MINUS		= 1<<5,
+	IEEE80211_CHAN_RADAR_CLEAR		= 1<<6,
+	IEEE80211_CHAN_RADAR_INTERFERENCE	= 1<<7,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2a05b31..4a07e67 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -436,11 +436,17 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 {
 	struct beacon_data *new, *old;
 	int new_head_len, new_tail_len;
+	u32 flags;
 	int size;
 	int err = -EINVAL;
 
 	old = sdata->u.ap.beacon;
 
+	flags = sdata->local->hw.conf.channel->flags;
+	if ((flags & IEEE80211_CHAN_RADAR) &&
+	    !(flags & IEEE80211_CHAN_RADAR_CLEAR))
+		return -EINVAL;
+
 	/* head must not be zero-length */
 	if (params->head && !params->head_len)
 		return -EINVAL;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 081dcaf..c8b5e05 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1629,8 +1629,10 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * radar detection by itself. We can do that later by adding a
 	 * monitor flag interfaces used for AP support.
 	 */
-	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
-	     IEEE80211_CHAN_PASSIVE_SCAN)))
+	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS |
+	    IEEE80211_CHAN_PASSIVE_SCAN)) ||
+	    ((chan->flags & IEEE80211_CHAN_RADAR) &&
+	    !(chan->flags & IEEE80211_CHAN_RADAR_CLEAR)))
 		goto fail;
 
 	/* check for not even having the fixed radiotap header part */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f4facba..52b76e7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -307,6 +307,10 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
 	if (chan->flags & IEEE80211_CHAN_RADAR)
 		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR);
+	if (chan->flags & IEEE80211_CHAN_RADAR_CLEAR)
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR_CLEAR);
+	if (chan->flags & IEEE80211_CHAN_RADAR_INTERFERENCE)
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR_INTERFERENCE);
 
 	NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 		    DBM_TO_MBM(chan->max_power));
-- 
1.7.2.3
