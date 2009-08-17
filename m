Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:64136 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbZHQQ41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 12:56:27 -0400
Received: by ewy10 with SMTP id 10so3097890ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 09:56:28 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/7] rt2x00: Fix RFKILL polling
Date: Mon, 17 Aug 2009 18:53:24 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908171853.24256.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rfkill_poll callback function in the drivers check a bit
to see if the RFKILL key has been pressed. However when the
bit is set it means the radio is active and the device can be
used.

The wiphy_rfkill_set_hw_state() function expects the inversed,
so '1' must be send when the radio must be disabled.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index cb7b6d4..b27a250 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -704,8 +704,8 @@ EXPORT_SYMBOL_GPL(rt2x00mac_conf_tx);
 void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	bool blocked = !!rt2x00dev->ops->lib->rfkill_poll(rt2x00dev);
+	bool active = !!rt2x00dev->ops->lib->rfkill_poll(rt2x00dev);
 
-	wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
+	wiphy_rfkill_set_hw_state(hw->wiphy, !active);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_rfkill_poll);
-- 
1.6.4

