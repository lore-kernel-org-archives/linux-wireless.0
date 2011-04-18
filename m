Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab1DRNfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:35:47 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833789fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:35:46 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/23] rt2x00: Use correct TBTT_SYNC config in AP mode
Date: Mon, 18 Apr 2011 15:28:04 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181527.06956.IvDoorn@gmail.com> <201104181527.44542.IvDoorn@gmail.com>
In-Reply-To: <201104181527.44542.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181528.05047.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

This seems to fix problems with some powersaving clients since a
positive value in TBTT_SYNC_CFG_TBTT_ADJUST introduces beacon skew,
which is not wanted in AP mode.

Also update the rest of the TBTT_SYNC config according to the
legacy drivers in AP mode.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c6f5584..e0fa559 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1245,6 +1245,25 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, conf->sync);
 		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+		if (conf->sync == TSF_SYNC_AP_NONE) {
+			/*
+			 * Tune beacon queue transmit parameters for AP mode
+			 */
+			rt2800_register_read(rt2x00dev, TBTT_SYNC_CFG, &reg);
+			rt2x00_set_field32(&reg, TBTT_SYNC_CFG_BCN_CWMIN, 0);
+			rt2x00_set_field32(&reg, TBTT_SYNC_CFG_BCN_AIFSN, 1);
+			rt2x00_set_field32(&reg, TBTT_SYNC_CFG_BCN_EXP_WIN, 32);
+			rt2x00_set_field32(&reg, TBTT_SYNC_CFG_TBTT_ADJUST, 0);
+			rt2800_register_write(rt2x00dev, TBTT_SYNC_CFG, reg);
+		} else {
+			rt2800_register_read(rt2x00dev, TBTT_SYNC_CFG, &reg);
+			rt2x00_set_field32(&reg, TBTT_SYNC_CFG_BCN_CWMIN, 4);
+			rt2x00_set_field32(&reg, TBTT_SYNC_CFG_BCN_AIFSN, 2);
+			rt2x00_set_field32(&reg, TBTT_SYNC_CFG_BCN_EXP_WIN, 32);
+			rt2x00_set_field32(&reg, TBTT_SYNC_CFG_TBTT_ADJUST, 16);
+			rt2800_register_write(rt2x00dev, TBTT_SYNC_CFG, reg);
+		}
 	}
 
 	if (flags & CONFIG_UPDATE_MAC) {
-- 
1.7.2.3

