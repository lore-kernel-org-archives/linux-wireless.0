Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f211.google.com ([209.85.220.211]:63956 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0BGPCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 10:02:00 -0500
Received: by fxm3 with SMTP id 3so6377516fxm.39
        for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2010 07:01:57 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath: fix WARN_ON with Polish (Poland) Contry code
Date: Sun, 7 Feb 2010 16:01:55 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201002071601.55787.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a WARN_ON which is triggered
by Poland's country code.

ath: EEPROM regdomain: 0x8268       
ath: EEPROM indicates we should expect a country code
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x37
ath: Country alpha2 being used: PL
ath: Regpair used: 0x37
  -----------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/regd.c:155 ath_regd_init+0x30b
Pid: 12661, comm: firmware/carl91 2.6.33-rc5-wl #18
Call Trace:
 [<>] ? warn_slowpath_common+0x76/0x8c
 [<>] ? ar9170_reg_notifier+0x0/0x2d [carl9170usb]
 [<>] ? ath_regd_init+0x30b/0x377 [ath]
 [<>] ? ar9170_register+0x3b3/0x3ca [carl9170usb]
[...]
---[ end trace ]---

Note: Poland is just an example. But it is very likely
that more country codes are affected.

Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 039ac49..04abd1f 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -110,8 +110,9 @@ static const struct ieee80211_regdomain ath_world_regdom_67_68_6A = {
 
 static inline bool is_wwr_sku(u16 regd)
 {
-	return ((regd & WORLD_SKU_MASK) == WORLD_SKU_PREFIX) ||
-		(regd == WORLD);
+	return ((regd & COUNTRY_ERD_FLAG) != COUNTRY_ERD_FLAG) &&
+		(((regd & WORLD_SKU_MASK) == WORLD_SKU_PREFIX) ||
+		(regd == WORLD));
 }
 
 static u16 ath_regd_get_eepromRD(struct ath_regulatory *reg)

