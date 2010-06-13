Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41176 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab0FMSPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 14:15:21 -0400
Received: by wwb18 with SMTP id 18so3032532wwb.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 11:15:20 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] mac80211: Fix bss_info_changed comment regarding sleeping
Date: Sun, 13 Jun 2010 20:15:09 +0200
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006132015.10629.IvDoorn@gmail.com>
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

