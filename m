Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58245 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab0BDGyU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 01:54:20 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2010 22:54:20 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Vivek Natarajan <vnatarajan@atheros.com>
Subject: [RFC PATCH 2/2] mac80211: Reset dynamic ps timer in Rx path.
Date: Thu, 4 Feb 2010 12:24:02 +0530
Message-ID: <1265266442-6273-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
References: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If there is a continuous Rx UDP traffic with power save enabled,
there is some loss of packets with ath9k as Atheros chipsets
need to be awake to do Rx, unlike other vendor chipsets.
The current mac80211 implementation enables power save if there
is no Tx traffic for a specific timeout. This adversely affects
ath9k when there is a continuous Rx UDP traffic going on since it
depends only on the tim bit in the next beacon to awake.
Fix this by restarting the dynamic ps timer on receiving every
data packet.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/rx.c      |   10 ++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 74ccf30..6ecc065 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -958,6 +958,10 @@ enum ieee80211_tkip_key_type {
  *	Hardware supports Unscheduled Automatic Power Save Delivery
  *	(U-APSD) in managed mode. The mode is configured with
  *	conf_tx() operation.
+ *
+ * @IEEE80211_HW_NEEDS_RX_PS_RESET:
+ *	Hardware requires the stack to reset the dynamic PS timer
+ *	on receiving a data frame.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -978,6 +982,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
+	IEEE80211_HW_NEEDS_RX_PS_RESET			= 1<<18,
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5709307..0bb6169 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1719,6 +1719,7 @@ static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct ieee80211_local *local = rx->local;
 	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	__le16 fc = hdr->frame_control;
@@ -1750,6 +1751,15 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	dev->stats.rx_packets++;
 	dev->stats.rx_bytes += rx->skb->len;
 
+	if ((local->hw.flags & IEEE80211_HW_NEEDS_RX_PS_RESET) &&
+	    ieee80211_is_data(hdr->frame_control) &&
+	    !is_multicast_ether_addr(hdr->addr1)) {
+		if (local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+		}
+	}
+
 	ieee80211_deliver_skb(rx);
 
 	return RX_QUEUED;
-- 
1.6.6.1

