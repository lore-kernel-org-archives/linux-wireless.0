Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1KNOCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 09:02:53 -0500
Subject: [PATCH] mac80211: remove crypto special case for auth frames
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 15:02:44 +0100
Message-ID: <1321279364.4472.50.camel@jlt3.sipsolutions.net> (sfid-20111114_150256_857143_FE73A2E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The shared key authentication frame that needs to be
encrypted (the third one in the shared key handshake)
is directly encrypted in ieee80211_send_auth and the
IEEE80211_TX_INTFL_DONT_ENCRYPT is set. All others
are not encrypted, so the only way to get to this is
erroneously on no-monitor AP side.

Remove the special case for authentication frames to
fix the AP shared key side when operating without
cooked monitor interfaces -- with cooked monitor the
IEEE80211_TX_INTFL_DONT_ENCRYPT also gets set, so we
never get here -- an AP never encrypts auth frames.

Without this patch, an AP operating in WEP mode with
my no-monitor patches would erroneously encrypt all
authentication frames, instead of none.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/mac80211/tx.c	2011-11-14 11:33:28.000000000 +0100
+++ b/net/mac80211/tx.c	2011-11-14 14:46:29.000000000 +0100
@@ -572,8 +572,6 @@ ieee80211_tx_h_select_key(struct ieee802
 		switch (tx->key->conf.cipher) {
 		case WLAN_CIPHER_SUITE_WEP40:
 		case WLAN_CIPHER_SUITE_WEP104:
-			if (ieee80211_is_auth(hdr->frame_control))
-				break;
 		case WLAN_CIPHER_SUITE_TKIP:
 			if (!ieee80211_is_data_present(hdr->frame_control))
 				tx->key = NULL;


