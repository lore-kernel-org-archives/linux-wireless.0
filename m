Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50707 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZA3RJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 12:09:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 09:09:15 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <Jouni.Malinen@atheros.com>,
	<johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v6] mac80211: do not TX injected frames when not allowed
Date: Fri, 30 Jan 2009 09:08:29 -0800
Message-ID: <1233335309-28099-1-git-send-email-lrodriguez@atheros.com> (sfid-20090130_180917_956750_00C2D40D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Monitor mode is able to TX by using injected frames. We should
not allow injected frames to be sent unless allowed by regulatory
rules. Since AP mode uses a monitor interfaces to transmit
management frames we have to take care to not break AP mode as
well while resolving this. We can deal with this by allowing compliant
APs solutions to inform mac80211 if their monitor interface is
intended to be used for an AP by setting a cfg80211 flag for the
monitor interface. hostapd, for example, currently does its own
checks to ensure AP mode is not used on channels which require radar
detection. Once such solutions are available it can can add this
flag for monitor interfaces.

Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This v6 leaves the AP flag out and removes the unused sdata..

 net/mac80211/tx.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7b013fb..f1c726d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1433,10 +1433,31 @@ int ieee80211_monitor_start_xmit(struct sk_buff *skb,
 				 struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_channel *chan = local->hw.conf.channel;
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
 	u16 len_rthdr;
 
+	/*
+	 * Frame injection is not allowed if beaconing is not allowed
+	 * or if we need radar detection. Beaconing is usually not allowed when
+	 * the mode or operation (Adhoc, AP, Mesh) does not support DFS.
+	 * Passive scan is also used in world regulatory domains where
+	 * your country is not known and as such it should be treated as
+	 * NO TX unless the channel is explicitly allowed in which case
+	 * your current regulatory domain would not have the passive scan
+	 * flag.
+	 *
+	 * Since AP mode uses monitor interfaces to inject/TX management
+	 * frames we can make AP mode the exception to this rule once it
+	 * supports radar detection as its implementation can deal with
+	 * radar detection by itself. We can do that later by adding a
+	 * monitor flag interfaces used for AP support.
+	 */
+	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
+	     IEEE80211_CHAN_PASSIVE_SCAN)))
+		goto fail;
+
 	/* check for not even having the fixed radiotap header part */
 	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
 		goto fail; /* too short to be possibly valid */
-- 
1.6.1.2.253.ga34a

