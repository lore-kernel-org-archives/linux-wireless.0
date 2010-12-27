Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38767 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab0L0OIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 09:08:24 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so8482816wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 06:08:24 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/10] rt2x00: Remove unused interface spinlock
Date: Mon, 27 Dec 2010 15:07:16 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012271504.30848.IvDoorn@gmail.com> <201012271506.37080.IvDoorn@gmail.com> <201012271506.58485.IvDoorn@gmail.com>
In-Reply-To: <201012271506.58485.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012271507.17065.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Since the last user of intf->lock is gone we can safely remove it.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    6 ------
 drivers/net/wireless/rt2x00/rt2x00mac.c |    1 -
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index b3f77d4..84aaf39 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -358,12 +358,6 @@ enum rt2x00_delayed_flags {
  */
 struct rt2x00_intf {
 	/*
-	 * All fields within the rt2x00_intf structure
-	 * must be protected with a spinlock.
-	 */
-	spinlock_t lock;
-
-	/*
 	 * beacon->skb must be protected with the mutex.
 	 */
 	struct mutex beacon_skb_mutex;
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 297d972..b5dad04 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -268,7 +268,6 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	else
 		rt2x00dev->intf_sta_count++;
 
-	spin_lock_init(&intf->lock);
 	spin_lock_init(&intf->seqlock);
 	mutex_init(&intf->beacon_skb_mutex);
 	intf->beacon = entry;
-- 
1.7.2.3

