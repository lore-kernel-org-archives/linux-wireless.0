Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38572 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab1IHMja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 08:39:30 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so268175ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 05:39:29 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/7] rt2x00: Add WCID to crypto struct
Date: Thu, 8 Sep 2011 14:36:45 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201109081434.23635.IvDoorn@gmail.com> <201109081436.05113.IvDoorn@gmail.com>
In-Reply-To: <201109081436.05113.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109081436.46401.IvDoorn@gmail.com> (sfid-20110908_143934_243781_F99667A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

When a WCID was already assigned to a STA the key configuration
functions need to use the same WCID for configuring the keys. Hence, add
the WCID to the crypo configuration structure.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 ++
 drivers/net/wireless/rt2x00/rt2x00mac.c |    7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 2093a55..c360ab3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -478,6 +478,8 @@ struct rt2x00lib_crypto {
 	u8 key[16];
 	u8 tx_mic[8];
 	u8 rx_mic[8];
+
+	int wcid;
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 3cd70ff..4d82d53 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -494,6 +494,7 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	struct rt2x00lib_crypto crypto;
 	static const u8 bcast_addr[ETH_ALEN] =
 		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, };
+	struct rt2x00_sta *sta_priv = NULL;
 
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
 		return 0;
@@ -511,9 +512,11 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	crypto.cmd = cmd;
 
-	if (sta)
+	if (sta) {
 		crypto.address = sta->addr;
-	else
+		sta_priv = sta_to_rt2x00_sta(sta);
+		crypto.wcid = sta_priv->wcid;
+	} else
 		crypto.address = bcast_addr;
 
 	if (crypto.cipher == CIPHER_TKIP)
-- 
1.7.3.4
