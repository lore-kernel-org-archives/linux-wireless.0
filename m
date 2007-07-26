Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:63264 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbXGZPti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 11:49:38 -0400
Date: Thu, 26 Jul 2007 10:49:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH]mac80211: Remove overly sticky averaging filters for rssi, signal, noise
Message-ID: <46a8c26d.vEDrkPz7/e+Oa7zN%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current version of wireless statistics contains a bug in the averaging
that makes the numbers be too sticky and not react to small changes. This
patch removes all averaging.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/net/mac80211/ieee80211.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211.c
+++ wireless-dev/net/mac80211/ieee80211.c
@@ -3860,12 +3860,9 @@ ieee80211_rx_h_sta_process(struct ieee80
 
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
-	sta->last_rssi = (sta->last_rssi * 15 +
-			  rx->u.rx.status->ssi) / 16;
-	sta->last_signal = (sta->last_signal * 15 +
-			    rx->u.rx.status->signal) / 16;
-	sta->last_noise = (sta->last_noise * 15 +
-			   rx->u.rx.status->noise) / 16;
+	sta->last_rssi = rx->u.rx.status->ssi;
+	sta->last_signal = rx->u.rx.status->signal;
+	sta->last_noise = rx->u.rx.status->noise;
 
 	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
 		/* Change STA power saving mode only in the end of a frame
