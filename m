Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab1FAGaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 02:30:00 -0400
Subject: [PATCH] bluetooth l2cap: fix locking in l2cap_global_chan_by_psm
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 08:29:54 +0200
Message-ID: <1306909794.3867.3.camel@jlt3.sipsolutions.net> (sfid-20110601_083004_768270_3B5B32CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

read_lock() ... read_unlock_bh() is clearly bogus.
This was broken by

commit 23691d75cdc69c3b285211b4d77746aa20a17d18
Author: Gustavo F. Padovan <padovan@profusion.mobi>
Date:   Wed Apr 27 18:26:32 2011 -0300

    Bluetooth: Remove l2cap_sk_list

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/bluetooth/l2cap_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c	2011-06-01 08:27:44.000000000 +0200
+++ b/net/bluetooth/l2cap_core.c	2011-06-01 08:27:51.000000000 +0200
@@ -906,7 +906,7 @@ static struct l2cap_chan *l2cap_global_c
 		if (c->psm == psm) {
 			/* Exact match. */
 			if (!bacmp(&bt_sk(sk)->src, src)) {
-				read_unlock_bh(&chan_list_lock);
+				read_unlock(&chan_list_lock);
 				return c;
 			}
 


