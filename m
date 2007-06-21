Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbXFVIlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:41:47 -0400
Message-Id: <20070621221757.067028000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 04/14] mac80211: split ieee80211_rx_h_check handler
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ieee80211_rx_h_check handler really does two things, it's
a lot easier to understand if it's split into ieee80211_rx_h_check
and ieee80211_rx_h_load_key, and it may be possible in the future
to optimise the key loading to not do it for each interface.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-06-21 20:48:50.578638003 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-06-21 20:50:38.678638003 +0200
@@ -248,7 +248,6 @@ static ieee80211_txrx_result
 ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
-	int always_sta_key;
 	hdr = (struct ieee80211_hdr *) rx->skb->data;
 
 	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
@@ -316,6 +315,16 @@ ieee80211_rx_h_check(struct ieee80211_tx
 		return TXRX_QUEUED;
 	}
 
+	return TXRX_CONTINUE;
+}
+
+
+static ieee80211_txrx_result
+ieee80211_rx_h_load_key(struct ieee80211_txrx_data *rx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
+	int always_sta_key;
+
 	if (rx->sdata->type == IEEE80211_IF_TYPE_STA)
 		always_sta_key = 0;
 	else
@@ -1373,6 +1382,7 @@ ieee80211_rx_handler ieee80211_rx_handle
 	ieee80211_rx_h_monitor,
 	ieee80211_rx_h_passive_scan,
 	ieee80211_rx_h_check,
+	ieee80211_rx_h_load_key,
 	ieee80211_rx_h_sta_process,
 	ieee80211_rx_h_ccmp_decrypt,
 	ieee80211_rx_h_tkip_decrypt,

-- 

