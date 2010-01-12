Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:44890 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab0ALInc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 03:43:32 -0500
Subject: [PATCH PATCH v6 4/7] mac80211: check uapsd state for dynamic power
	save
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	a.young.jason@gmail.com
Date: Tue, 12 Jan 2010 10:42:53 +0200
Message-ID: <20100112084253.27492.77518.stgit@tikku>
In-Reply-To: <20100112084059.27492.86738.stgit@tikku>
References: <20100112084059.27492.86738.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

To make U-APSD client mode effective, we must not wake up from dynamic power
save when transmitting frames. So if dynamic power save is enabled, it needs
check the queue the transmitted packet is in and decide if we need to wake
up or not.

In a perfect world, where all packets would have correct QoS tags, U-APSD
enabled queues should not trigger wakeup from power save. But in the real
world, where very few packets have correct QoS tags, this won't work. For
example, if only voip class has U-APSD enabled and we send a packet in voip
class, but the packets we receive are in best effort class, we would receive
the packets with the legacy power save method. And that would increase
latencies too much from a voip application point of view.

The workaround is to enable U-APSD for all qeueus and still use dynamic ps
wakeup for all other queues except voip. That way we can still save power
with a voip application and not sacrifice latency. Normal traffic (in
background, best effort or video class) would still trigger wakeup from
dynamic power save.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/tx.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cf846a3..f2cbf9b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -184,6 +184,7 @@ static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_local *local = tx->local;
+	struct ieee80211_if_managed *ifmgd;
 
 	/* driver doesn't support power save */
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
@@ -208,6 +209,30 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	if (local->quiescing)
 		return TX_CONTINUE;
 
+	/* dynamic ps is supported only in managed mode */
+	if (tx->sdata->vif.type != NL80211_IFTYPE_STATION)
+		return TX_CONTINUE;
+
+	ifmgd = &tx->sdata->u.mgd;
+
+	/*
+	 * Don't wakeup from power save if u-apsd is enabled, voip ac has
+	 * u-apsd enabled and the frame is in voip class. This effectively
+	 * means that even if all access categories have u-apsd enabled, in
+	 * practise u-apsd is only used with the voip ac. This is a
+	 * workaround for the case when received voip class packets do not
+	 * have correct qos tag for some reason, due the network or the
+	 * peer application.
+	 *
+	 * Note: local->uapsd_queues access is racy here. If the value is
+	 * changed via debugfs, user needs to reassociate manually to have
+	 * everything in sync.
+	 */
+	if ((ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED)
+	    && (local->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
+	    && skb_get_queue_mapping(tx->skb) == 0)
+		return TX_CONTINUE;
+
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		ieee80211_stop_queues_by_reason(&local->hw,
 						IEEE80211_QUEUE_STOP_REASON_PS);

