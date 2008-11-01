Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:14543 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYKAXiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 19:38:23 -0400
Received: by ey-out-2122.google.com with SMTP id 6so664662eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 16:38:22 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/4] rt2x00: Block set_key() during suspend/shutdown
Date: Sun, 2 Nov 2008 00:37:25 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <200811020036.40746.IvDoorn@gmail.com> <200811020037.09726.IvDoorn@gmail.com>
In-Reply-To: <200811020037.09726.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811020037.25439.IvDoorn@gmail.com> (sfid-20081102_003835_911852_B282A762)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 will call set_key() when the device is
shutting down. When the device is unplugged the
keys will be lost automatically due to the power
loss. When the device is not plugged but the module
is only unloaded the keys can remain in the device
hardware, when the module is loaded the keys will
be cleaned up during initialization.

This should prevent the problem reported by Johannes Berg,
where unplugging the device while suspended resulted in
a NULL pointer error during set_key() which was
caused because of the CSR base address being freed.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 8fc2315..188f891 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -486,7 +486,9 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			struct ieee80211_key_conf *key);
 	struct rt2x00lib_crypto crypto;
 
-	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags))
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		return 0;
+	else if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags))
 		return -EOPNOTSUPP;
 	else if (key->keylen > 32)
 		return -ENOSPC;
-- 
1.5.6.1

