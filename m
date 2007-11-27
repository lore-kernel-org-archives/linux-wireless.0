Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:23631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbXK0Tjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:39:53 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1321058ugc
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:39:53 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/11] rt2x00: Use IEEE80211_IF_TYPE_INVALID directly
Date: Tue, 27 Nov 2007 21:49:50 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272149.50809.IvDoorn@gmail.com> (sfid-20071127_194249_300331_22C91BC1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to use a seperate define INVALID_INTERFACE while
we can use IEEE80211_IF_TYPE_INVALID directly.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 --
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c |    2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index ba874cf..103a122 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -369,10 +369,8 @@ struct interface {
 
 	/*
 	 * Current working type (IEEE80211_IF_TYPE_*).
-	 * When set to INVALID_INTERFACE, no interface is configured.
 	 */
 	int type;
-#define INVALID_INTERFACE	IEEE80211_IF_TYPE_INVALID
 
 	/*
 	 * MAC of the device.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 48e2515..bd7b738 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1170,7 +1170,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Reset current working type.
 	 */
-	rt2x00dev->interface.type = INVALID_INTERFACE;
+	rt2x00dev->interface.type = IEEE80211_IF_TYPE_INVALID;
 
 	/*
 	 * Allocate ring array.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index e216c34..bae4442 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -242,7 +242,7 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 		return;
 
 	intf->id = 0;
-	intf->type = INVALID_INTERFACE;
+	intf->type = IEEE80211_IF_TYPE_INVALID;
 	memset(&intf->bssid, 0x00, ETH_ALEN);
 	memset(&intf->mac, 0x00, ETH_ALEN);
 
-- 
1.5.3.6

