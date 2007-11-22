Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:2658 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313AbXKVWDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 17:03:46 -0500
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ieee80211: fix unaligned access in ieee80211_copy_snap
Message-Id: <20071122220342.3DA729D4A13@zog.reactivated.net> (sfid-20071122_220352_966309_7BAAF1FD)
Date: Thu, 22 Nov 2007 22:03:42 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no guarantee that data+SNAP_SIZE will reside on an even numbered
address, so doing a 16 bit read will cause an unaligned access in some
situations. Based on a patch from Jun Sun.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

diff --git a/net/ieee80211/ieee80211_tx.c b/net/ieee80211/ieee80211_tx.c
index a4c3c51..6d06f13 100644
--- a/net/ieee80211/ieee80211_tx.c
+++ b/net/ieee80211/ieee80211_tx.c
@@ -144,7 +144,8 @@ static int ieee80211_copy_snap(u8 * data, u16 h_proto)
 	snap->oui[1] = oui[1];
 	snap->oui[2] = oui[2];
 
-	*(u16 *) (data + SNAP_SIZE) = htons(h_proto);
+	h_proto = htons(h_proto);
+	memcpy(data + SNAP_SIZE, &h_proto, sizeof(u16));
 
 	return SNAP_SIZE + sizeof(u16);
 }
