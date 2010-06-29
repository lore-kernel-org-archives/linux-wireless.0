Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38421 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab0F2Tuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:50:50 -0400
Received: by wyb38 with SMTP id 38so2999627wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:50:49 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/21] rt2x00: Write the BSSID to register when interface is added
Date: Tue, 29 Jun 2010 21:38:55 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com>
In-Reply-To: <201006292138.13509.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292138.56463.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <ivdoorn@gmail.com>

For the Master mode case, we initialized the BSSID as the MAC
address, but never wrote it into the registers. This causes
Hardware crypto to break in Master mode when receiving frames
which require the BSSID to be filled in.

This is safe for STA mode since the BSSID will be initialized
to 00:00:00:00:00 at this point, but will be set to the correct
value later when the device associates.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index abbd857..2071cf3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -282,7 +282,8 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	 * has been initialized. Otherwise the device can reset
 	 * the MAC registers.
 	 */
-	rt2x00lib_config_intf(rt2x00dev, intf, vif->type, intf->mac, NULL);
+	rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
+			      intf->mac, intf->bssid);
 
 	/*
 	 * Some filters depend on the current working mode. We can force
-- 
1.6.6.1

