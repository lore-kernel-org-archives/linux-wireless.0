Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:51944 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbYEKMYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2008 08:24:10 -0400
Received: by ug-out-1314.google.com with SMTP id h2so506220ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 11 May 2008 05:24:09 -0700 (PDT)
To: linville@tuxdriver.com
Subject: mac80211: Set IEEE80211_TXPD_REQ_TX_STATUS for all TX frames
Date: Sun, 11 May 2008 14:34:18 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805111434.19071.IvDoorn@gmail.com> (sfid-20080511_142416_543362_AFDF8EE8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All interfaces should set the IEEE80211_TXPD_REQ_TX_STATUS flag for all TX frames
which will force the master interface to set the IEEE80211_TX_CTL_REQ_TX_STATUS
flag. This in turn will allow drivers to check for that flag before reporting
the TX status to mac80211.

This is very usefull when frames (like beacons, RTS and CTS-to-self) should not
be reported back to mac80211. Later we could add more extensive checks to
exclude more frames from being reported, or let mac80211 decide if it wants
the frame for status reporting or not.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f35eaea..0024892 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1617,6 +1617,9 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	if (ethertype == ETH_P_PAE)
 		pkt_data->flags |= IEEE80211_TXPD_EAPOL_FRAME;
 
+	/* Interfaces should always request a status report */
+	pkt_data->flags |= IEEE80211_TXPD_REQ_TX_STATUS;
+
 	skb->dev = local->mdev;
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
