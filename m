Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:10788 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab0FGNUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 09:20:50 -0400
Received: by ey-out-2122.google.com with SMTP id 25so200356eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jun 2010 06:20:49 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Fix bss_info_changed comment regarding sleeping
Date: Mon, 7 Jun 2010 15:20:44 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006071520.45664.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bss_info_changed callback function is allowed to sleep,
however when operating in Mesh mode, it can be used in
atomic context. Fixing it would seem to require major
locking changes in the mesh implementation.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 include/net/mac80211.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index de22cbf..73cf3ad 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1533,7 +1533,8 @@ enum ieee80211_ampdu_mlme_action {
  *	This function should not be used if no BSS has been set, unless
  *	for association indication. The @changed parameter indicates which
  *	of the bss parameters has changed when a call is made. The callback
- *	can sleep.
+ *	can sleep except when operating in Mesh mode where the callback
+ *	must be atomic.
  *
  * @prepare_multicast: Prepare for multicast filter configuration.
  *	This callback is optional, and its return value is passed
-- 
1.6.6.1

