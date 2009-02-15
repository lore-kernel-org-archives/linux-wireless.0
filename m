Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:54086 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZBOQn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 11:43:26 -0500
Received: by ey-out-2122.google.com with SMTP id 25so255664eya.37
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 08:43:24 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/3] rt2x00: uncomment get_tsf
Date: Sun, 15 Feb 2009 17:42:30 +0100
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200902151742.01372.IvDoorn@gmail.com>
In-Reply-To: <200902151742.01372.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200902151742.30220.IvDoorn@gmail.com> (sfid-20090215_174329_983050_F7182063)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The atomic requirement for get_tsf() has been removed
by mac80211. This means the USB drivers can add support
for the callback function again.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt73usb.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 6521dac..8f52234 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2241,13 +2241,6 @@ static int rt73usb_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	return 0;
 }
 
-#if 0
-/*
- * Mac80211 demands get_tsf must be atomic.
- * This is not possible for rt73usb since all register access
- * functions require sleeping. Untill mac80211 no longer needs
- * get_tsf to be atomic, this function should be disabled.
- */
 static u64 rt73usb_get_tsf(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -2261,9 +2254,6 @@ static u64 rt73usb_get_tsf(struct ieee80211_hw *hw)
 
 	return tsf;
 }
-#else
-#define rt73usb_get_tsf	NULL
-#endif
 
 static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
-- 
1.5.6.1

