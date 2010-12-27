Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38767 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab0L0OIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 09:08:12 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so8482816wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 06:08:12 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/10] rt2x00: Remove intf->bssid field.
Date: Mon, 27 Dec 2010 15:05:14 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012271504.30848.IvDoorn@gmail.com> <201012271504.55450.IvDoorn@gmail.com>
In-Reply-To: <201012271504.55450.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012271505.15849.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

The bssid field in struct rt2x00_intf is only written to once, and is
never read from.

Remove this field, as it appears to not be needed.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    5 -----
 drivers/net/wireless/rt2x00/rt2x00mac.c |   11 -----------
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index af1d3ef..5f7f52f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -365,11 +365,6 @@ struct rt2x00_intf {
 	u8 mac[ETH_ALEN];
 
 	/*
-	 * BBSID of the AP to associate with.
-	 */
-	u8 bssid[ETH_ALEN];
-
-	/*
 	 * beacon->skb must be protected with the mutex.
 	 */
 	struct mutex beacon_skb_mutex;
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 4cac7ad..23250a5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -614,17 +614,6 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
 		return;
 
-	spin_lock(&intf->lock);
-
-	/*
-	 * conf->bssid can be NULL if coming from the internal
-	 * beacon update routine.
-	 */
-	if (changes & BSS_CHANGED_BSSID)
-		memcpy(&intf->bssid, bss_conf->bssid, ETH_ALEN);
-
-	spin_unlock(&intf->lock);
-
 	/*
 	 * Call rt2x00_config_intf() outside of the spinlock context since
 	 * the call will sleep for USB drivers. By using the ieee80211_if_conf
-- 
1.7.2.3

