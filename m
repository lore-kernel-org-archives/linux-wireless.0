Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1739 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZAIC0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 21:26:09 -0500
Date: Thu, 8 Jan 2009 21:23:47 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
Subject: Re: drivers returning wrong results from their _tx op
Message-ID: <20090109022347.GA5077@hash.localnet> (sfid-20090109_032614_512427_0190983E)
References: <1231193264.3697.41.camel@johannes> <b6c5339f0901051424q12d8fc14o8f20b62cfacc4e6e@mail.gmail.com> <1231246859.3503.0.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231246859.3503.0.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 06, 2009 at 02:00:59PM +0100, Johannes Berg wrote:
> I guess it should, want to send a patch?

Some of the return values were already documented in the ops comment, 
and others like set_key() elsewhere.  Here are more, though I guessed 
on a couple of them...

From: Bob Copeland <me@bobcopeland.com>
Date: Thu, 8 Jan 2009 21:00:34 -0500
Subject: [PATCH] mac80211: document return codes from ops callbacks

For any callbacks in ieee80211_ops, specify what values the return
codes represent.  While at it, fix a couple of capitalization and
punctuation differences.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 include/net/mac80211.h |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b7b9014..903dade 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1170,6 +1170,7 @@ enum ieee80211_ampdu_mlme_action {
  *	configuration in the TX control data. This handler should,
  *	preferably, never fail and stop queues appropriately, more
  *	importantly, however, it must never fail for A-MPDU-queues.
+ *	Returns NETDEV_TX_OK, or NETDEV_TX_BUSY if it fails.
  *	Must be implemented and atomic.
  *
  * @start: Called before the first netdevice attached to the hardware
@@ -1210,9 +1211,12 @@ enum ieee80211_ampdu_mlme_action {
  *
  * @config: Handler for configuration requests. IEEE 802.11 code calls this
  *	function to change hardware configuration, e.g., channel.
+ *	This function should never fail but returns a negative error code
+ *	if it does.
  *
  * @config_interface: Handler for configuration requests related to interfaces
  *	(e.g. BSSID changes.)
+ *	Returns a negative error code which will be seen in userspace.
  *
  * @bss_info_changed: Handler for configuration requests related to BSS
  *	parameters that may vary during BSS's lifespan, and may affect low
@@ -1232,6 +1236,7 @@ enum ieee80211_ampdu_mlme_action {
  *	This callback can sleep, and is only called between add_interface
  *	and remove_interface calls, i.e. while the given virtual interface
  *	is enabled.
+ *	Returns a negative error code if the key can't be added.
  *
  * @update_tkip_key: See the section "Hardware crypto acceleration"
  * 	This callback will be called in the context of Rx. Called for drivers
@@ -1243,8 +1248,10 @@ enum ieee80211_ampdu_mlme_action {
  *	bands. When the scan finishes, ieee80211_scan_completed() must be
  *	called; note that it also must be called when the scan cannot finish
  *	because the hardware is turned off! Anything else is a bug!
+ *	Returns a negative error code which will be seen in userspace.
  *
- * @get_stats: return low-level statistics
+ * @get_stats: Return low-level statistics.
+ * 	Returns zero if statistics are available.
  *
  * @get_tkip_seq: If your device implements TKIP encryption in hardware this
  *	callback should be provided to read the TKIP transmit IVs (both IV32
@@ -1258,6 +1265,7 @@ enum ieee80211_ampdu_mlme_action {
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
+ *	Returns a negative error code on failure.
  *
  * @get_tx_stats: Get statistics of the current TX queue status. This is used
  *	to get number of currently queued packets (queue length), maximum queue
@@ -1277,13 +1285,15 @@ enum ieee80211_ampdu_mlme_action {
  * @tx_last_beacon: Determine whether the last IBSS beacon was sent by us.
  *	This is needed only for IBSS mode and the result of this function is
  *	used to determine whether to reply to Probe Requests.
+ *	Returns non-zero if this device sent the last beacon.
  *
  * @ampdu_action: Perform a certain A-MPDU action
  * 	The RA/TID combination determines the destination and TID we want
  * 	the ampdu action to be performed for. The action is defined through
  * 	ieee80211_ampdu_mlme_action. Starting sequence number (@ssn)
- * 	is the first frame we expect to perform the action on. notice
+ * 	is the first frame we expect to perform the action on. Notice
  * 	that TX/RX_STOP can pass NULL for this parameter.
+ *	Returns a negative error code on failure.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
-- 
1.6.0.6

-- 
Bob Copeland %% www.bobcopeland.com

