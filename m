Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:64563 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab2CTOzU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:55:20 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Mar 2012 11:13:25 +0100
Subject: [RFC 06/12] mac80211: move offchannel flag
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <46154b97-95a4-4160-a80f-88df4385bd3a@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_155526_585572_6F95AEBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Offchannel belongs to channel state.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 ++--
 drivers/net/wireless/ath/ath9k/main.c         |    4 ++--
 drivers/net/wireless/rt2x00/rt2800lib.c       |    2 +-
 include/net/mac80211.h                        |    5 ++---
 net/mac80211/main.c                           |    8 ++++----
 5 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index d66ae61..241def0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -253,7 +253,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	if (priv->op_flags & OP_INVALID)
 		return -EIO;
 
-	fastcc = !!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL);
+	fastcc = hw->conf.chan_conf->offchannel;
 
 	ath9k_htc_ps_wakeup(priv);
 
@@ -305,7 +305,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	htc_start(priv->htc);
 
 	if (!(priv->op_flags & OP_SCANNING) &&
-	    !(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
+	    !(hw->conf.chan_conf->offchannel))
 		ath9k_htc_vif_reconfig(priv);
 
 	mod_timer(&priv->tx.cleanup_timer,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4a324b7..48185be 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1595,7 +1595,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		if (ah->curchan)
 			old_pos = ah->curchan - &ah->channels[0];
 
-		if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
+		if (hw->conf.chan_conf->offchannel)
 			sc->sc_flags |= SC_OP_OFFCHANNEL;
 		else
 			sc->sc_flags &= ~SC_OP_OFFCHANNEL;
@@ -1624,7 +1624,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		 * Reset the survey data for the new channel, unless we're switching
 		 * back to the operating channel from an off-channel operation.
 		 */
-		if (!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL) &&
+		if (!(hw->conf.chan_conf->offchannel) &&
 		    sc->cur_survey != &sc->survey[pos]) {
 
 			if (sc->cur_survey)
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e5bcf18..59cd5d7 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4861,7 +4861,7 @@ int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 		survey->channel_time_ext_busy = busy_ext / 1000;
 	}
 
-	if (!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
+	if (!hw->conf.chan_conf->offchannel)
 		survey->filled |= SURVEY_INFO_IN_USE;
 
 	return 0;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index fa71c97..9527a48 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -144,10 +144,12 @@ struct ieee80211_low_level_stats {
  *
  * @channel: the channel to tune to
  * @channel_type: the channel (HT) type
+ * @offchannel: The device is currently not on its main operating channel.
  */
 struct ieee80211_channel_conf {
 	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type;
+	bool offchannel;
 };
 
 /**
@@ -740,14 +742,11 @@ struct ieee80211_rx_status {
  *	may turn the device off as much as possible. Typically, this flag will
  *	be set when an interface is set UP but not associated or scanning, but
  *	it can also be unset in that case when monitor interfaces are active.
- * @IEEE80211_CONF_OFFCHANNEL: The device is currently not on its main
- *	operating channel.
  */
 enum ieee80211_conf_flags {
 	IEEE80211_CONF_MONITOR		= (1<<0),
 	IEEE80211_CONF_PS		= (1<<1),
 	IEEE80211_CONF_IDLE		= (1<<2),
-	IEEE80211_CONF_OFFCHANNEL	= (1<<3),
 };
 
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f5ca305..584f4d9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -106,7 +106,7 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 	/* If this off-channel logic ever changes,  ieee80211_on_oper_channel
 	 * may need to change as well.
 	 */
-	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
+	offchannel_flag = chan_state->conf.offchannel;
 	if (local->scan_channel) {
 		chan = local->scan_channel;
 		/* If scanning on oper channel, use whatever channel-type
@@ -126,11 +126,11 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 
 	if (chan != chan_state->oper_channel ||
 	    channel_type != chan_state->_oper_channel_type)
-		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
+		chan_state->conf.offchannel = true;
 	else
-		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
+		chan_state->conf.offchannel = false;
 
-	offchannel_flag ^= local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
+	offchannel_flag ^= chan_state->conf.offchannel;
 
 	if (offchannel_flag || chan != chan_state->conf.channel ||
 	    channel_type != chan_state->conf.channel_type) {
-- 
1.7.0.4

