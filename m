Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44112 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758623AbZASOwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 09:52:18 -0500
Date: Mon, 19 Jan 2009 16:52:00 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix drop-unencrypted for management frames
Message-ID: <20090119145200.GA26865@jm.kir.nu> (sfid-20090119_155229_925205_59D81643)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ADDBA request Action frame was sent out before 4-way handshake was
completed and the initial 802.11w code ended up dropping the frame
even if MFP was not enabled. While the sending of Action frames this
early is not really a good idea (will break with MFP enabled), we
should not break this for the MFP disabled case.

This patch fixes ieee80211_tx_h_select_key() not to drop management
frames if MFP is disabled. If MFP is enabled, Action frames will be
dropped before keys are set per IEEE 802.11w/D7.0. Other robust
management frames (i.e., Deauthentication and Disassociation frames)
are allowed unprotected prior to key configuration.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


---
 net/mac80211/tx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-01-19 16:22:01.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-01-19 16:45:14.000000000 +0200
@@ -432,7 +432,10 @@ ieee80211_tx_h_select_key(struct ieee802
 		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
 		 (tx->skb->protocol != cpu_to_be16(ETH_P_PAE)) &&
-		 !(info->flags & IEEE80211_TX_CTL_INJECTED)) {
+		 !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
+		 (!ieee80211_is_robust_mgmt_frame(hdr) ||
+		  (ieee80211_is_action(hdr->frame_control) &&
+		   tx->sta && test_sta_flags(tx->sta, WLAN_STA_MFP)))) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TX_DROP;
 	} else

-- 
Jouni Malinen                                            PGP id EFC895FA
