Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3386 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYJUBWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 21:22:46 -0400
Date: Mon, 20 Oct 2008 21:20:27 -0400
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix a few typos in mac80211 kernel doc
Message-ID: <20081021012027.GA25144@hash.localnet> (sfid-20081021_032256_942152_04F43094)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct a handful of errors found while reading the mac80211 book.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Hi Johannes, I just noticed these while reading the comments.

 include/net/mac80211.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f5f5b1f..e5bc62c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -87,7 +87,7 @@ enum ieee80211_notification_types {
  * This structure describes most essential parameters needed
  * to describe 802.11n HT characteristics in a BSS.
  *
- * @primary_channel: channel number of primery channel
+ * @primary_channel: channel number of primary channel
  * @bss_cap: 802.11n's general BSS capabilities (e.g. channel width)
  * @bss_op_mode: 802.11n's BSS operation modes (e.g. HT protection)
  */
@@ -115,7 +115,7 @@ enum ieee80211_max_queues {
  * The information provided in this structure is required for QoS
  * transmit queue configuration. Cf. IEEE 802.11 7.3.2.29.
  *
- * @aifs: arbitration interface space [0..255]
+ * @aifs: arbitration interframe space [0..255]
  * @cw_min: minimum contention window [a value of the form
  *	2^n-1 in the range 1..32767]
  * @cw_max: maximum contention window [like @cw_min]
@@ -460,7 +460,7 @@ enum ieee80211_conf_flags {
  * @antenna_sel_tx: transmit antenna selection, 0: default/diversity,
  *	1/2: antenna 0/1
  * @antenna_sel_rx: receive antenna selection, like @antenna_sel_tx
- * @ht_conf: describes current self configuration of 802.11n HT capabilies
+ * @ht_conf: describes current self configuration of 802.11n HT capabilities
  * @ht_bss_conf: describes current BSS configuration of 802.11n HT parameters
  * @channel: the channel to tune to
  */
@@ -860,7 +860,7 @@ static inline void SET_IEEE80211_DEV(struct ieee80211_hw *hw, struct device *dev
 }
 
 /**
- * SET_IEEE80211_PERM_ADDR - set the permanenet MAC address for 802.11 hardware
+ * SET_IEEE80211_PERM_ADDR - set the permanent MAC address for 802.11 hardware
  *
  * @hw: the &struct ieee80211_hw to set the MAC address for
  * @addr: the address to set
@@ -953,7 +953,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * This happens everytime the iv16 wraps around (every 65536 packets). The
  * set_key() call will happen only once for each key (unless the AP did
  * rekeying), it will not include a valid phase 1 key. The valid phase 1 key is
- * provided by udpate_tkip_key only. The trigger that makes mac80211 call this
+ * provided by update_tkip_key only. The trigger that makes mac80211 call this
  * handler is software decryption with wrap around of iv16.
  */
 
@@ -1087,7 +1087,7 @@ enum ieee80211_ampdu_mlme_action {
  *	Must be implemented.
  *
  * @add_interface: Called when a netdevice attached to the hardware is
- *	enabled. Because it is not called for monitor mode devices, @open
+ *	enabled. Because it is not called for monitor mode devices, @start
  *	and @stop must be implemented.
  *	The driver should perform any initialization it needs before
  *	the device can be enabled. The initial configuration for the
@@ -1156,7 +1156,7 @@ enum ieee80211_ampdu_mlme_action {
  * @set_retry_limit: Configuration of retry limits (if device needs it)
  *
  * @sta_notify: Notifies low level driver about addition or removal
- *	of assocaited station or AP.
+ *	of associated station or AP.
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
@@ -1459,7 +1459,7 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
  * the next beacon frame from the 802.11 code. The low-level is responsible
  * for calling this function before beacon data is needed (e.g., based on
  * hardware interrupt). Returned skb is used only once and low-level driver
- * is responsible of freeing it.
+ * is responsible for freeing it.
  */
 struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif);
-- 
1.5.4.2.182.gb3092

-- 
Bob Copeland %% www.bobcopeland.com

