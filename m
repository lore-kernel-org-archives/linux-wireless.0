Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365Ab0HLLOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Aug 2010 07:14:14 -0400
Subject: [PATCH] mac80211: check RX crypto for sta key
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 13:14:02 +0200
Message-ID: <1281611642.3803.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My previous patch removing decrypted && iv-stripped
checks from the crypto algorithms turned out to be
completely wrong since in the common case of using
a per-station key the check wasn't there. Rather
than revert it, add a check to this case so that
the crypto algorithms don't need to be able to deal
with already decrypted and verified frames.

Reported-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Tested-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |    3 +++
 1 file changed, 3 insertions(+)

--- wireless-testing.orig/net/mac80211/rx.c	2010-08-11 14:37:13.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-08-12 13:11:17.000000000 +0200
@@ -873,6 +873,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 
 	if (!is_multicast_ether_addr(hdr->addr1) && stakey) {
 		rx->key = stakey;
+		if ((status->flag & RX_FLAG_DECRYPTED) &&
+		    (status->flag & RX_FLAG_IV_STRIPPED))
+			return RX_CONTINUE;
 		/* Skip decryption if the frame is not protected. */
 		if (!ieee80211_has_protected(fc))
 			return RX_CONTINUE;


