Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:45204 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYFKTHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 15:07:13 -0400
Received: by yx-out-2324.google.com with SMTP id 31so375138yxl.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 12:07:12 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: RT2X00_LIB_RFKILL should depend on INPUT
Date: Wed, 11 Jun 2008 21:19:27 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806112119.27586.IvDoorn@gmail.com> (sfid-20080611_210721_066576_93A9FF36)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00 requires the input-polldev driver for reporting rfkill events,
selecting INPUT_POLLDEV is not correct since that option depends
on the INPUT config option.
Since RT2X00_LIB_RFKILL requires the input layer as well, we should
make it depend on INPUT directly.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---
John, this is for 2.6.26

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 0ace761..c4d1f67 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -36,6 +36,7 @@ config RT2X00_LIB_FIRMWARE
 config RT2X00_LIB_RFKILL
 	boolean
 	depends on RT2X00_LIB
+	depends on INPUT
 	select RFKILL
 	select INPUT_POLLDEV
 
