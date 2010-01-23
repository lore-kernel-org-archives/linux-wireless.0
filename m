Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:46996 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0AWS1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 13:27:19 -0500
Subject: [PATCH] mac80211: fix tx select key null pointer crash with hostapd
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Sat, 23 Jan 2010 20:27:14 +0200
Message-ID: <20100123182714.15374.3093.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin reported a crash in ieee80211_tx_h_select_key():

http://marc.info/?l=linux-wireless&m=126419655108528&w=2

This is a regression from patch "mac80211: move control.hw_key assignment".
Fix it as suggested by Johannes, adding an else statement to make sure
that tx->key is not accessed when it's null.

Compile-tested only.

Reported-by: Pavel Roskin <proski@gnu.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---
 net/mac80211/tx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index fcfa988..d017b35 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -547,9 +547,10 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 			    !ieee80211_use_mfp(hdr->frame_control, tx->sta,
 					       tx->skb))
 				tx->key = NULL;
-			skip_hw = (tx->key->conf.flags &
-						IEEE80211_KEY_FLAG_SW_MGMT) &&
-				   ieee80211_is_mgmt(hdr->frame_control);
+			else
+				skip_hw = (tx->key->conf.flags &
+					   IEEE80211_KEY_FLAG_SW_MGMT) &&
+					ieee80211_is_mgmt(hdr->frame_control);
 			break;
 		case ALG_AES_CMAC:
 			if (!ieee80211_is_mgmt(hdr->frame_control))

