Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35732 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751414AbdFZL3R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 07:29:17 -0400
Received: by mail-qt0-f194.google.com with SMTP id w12so12867629qta.2
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jun 2017 04:29:17 -0700 (PDT)
From: "Guillermo O. Freschi" <kedrot@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        linux-wireless@vger.kernel.org
Cc: "Guillermo O. Freschi" <kedrot@gmail.com>
Subject: [PATCH v2] drivers: staging: wilc1000/host_interface.c Fix sparse warning: right shift by bigger than source value
Date: Mon, 26 Jun 2017 08:29:01 -0300
Message-Id: <20170626112901.2885-1-kedrot@gmail.com> (sfid-20170626_133127_577860_A992ACA4)
In-Reply-To: <20170625144051.28873-1-kedrot@gmail.com>
References: <20170625144051.28873-1-kedrot@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shifting by equal to or bigger than the width of a type results in
undefined behavior. By using a wide enough temporary variable the issue
can be avoided.

Signed-off-by: Guillermo O. Freschi <kedrot@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f7c22d7b28d1..ed614698c22c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2416,10 +2416,12 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 		goto ERRORHANDLER;
 
 	pu8CurrByte = wid.val;
-	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
+
+	u32 enabled = strHostIfSetMulti->enabled;
+	*pu8CurrByte++ = (enabled & 0xFF);
+	*pu8CurrByte++ = ((enabled >> 8) & 0xFF);
+	*pu8CurrByte++ = ((enabled >> 16) & 0xFF);
+	*pu8CurrByte++ = ((enabled >> 24) & 0xFF);
 
 	*pu8CurrByte++ = (strHostIfSetMulti->cnt & 0xFF);
 	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 8) & 0xFF);
-- 
2.11.0
