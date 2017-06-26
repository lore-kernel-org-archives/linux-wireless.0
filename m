Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34366 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdFZLrI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 07:47:08 -0400
Received: by mail-qk0-f196.google.com with SMTP id 91so8181294qkq.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jun 2017 04:47:08 -0700 (PDT)
From: "Guillermo O. Freschi" <kedrot@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        linux-wireless@vger.kernel.org
Cc: "Guillermo O. Freschi" <kedrot@gmail.com>
Subject: [PATCH v2] drivers: staging: wilc1000/host_interface.c Fix sparse warning: right shift by bigger than source value
Date: Mon, 26 Jun 2017 08:47:01 -0300
Message-Id: <20170626114701.9769-1-kedrot@gmail.com> (sfid-20170626_134714_146808_C75E5363)
In-Reply-To: <20170625144051.28873-1-kedrot@gmail.com>
References: <20170625144051.28873-1-kedrot@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shifting by equal to or bigger than the width of a type results in
undefined behavior. By using a wide enough temporary variable the issue
can be avoided.

Signed-off-by: Guillermo O. Freschi <kedrot@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f7c22d7b28d1..4591b1452df4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2407,6 +2407,7 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	u32 enabled;
 
 	wid.id = (u16)WID_SETUP_MULTICAST_FILTER;
 	wid.type = WID_BIN;
@@ -2416,10 +2417,12 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 		goto ERRORHANDLER;
 
 	pu8CurrByte = wid.val;
-	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
+
+	enabled = strHostIfSetMulti->enabled;
+	*pu8CurrByte++ = (enabled & 0xFF);
+	*pu8CurrByte++ = ((enabled >> 8) & 0xFF);
+	*pu8CurrByte++ = ((enabled >> 16) & 0xFF);
+	*pu8CurrByte++ = ((enabled >> 24) & 0xFF);
 
 	*pu8CurrByte++ = (strHostIfSetMulti->cnt & 0xFF);
 	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 8) & 0xFF);
-- 
2.11.0
