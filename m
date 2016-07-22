Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34503 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbcGVOI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 10:08:28 -0400
Received: by mail-pf0-f196.google.com with SMTP id g202so7384855pfb.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2016 07:08:28 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, "Andrew F. Davis" <afd@ti.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Igor Grinberg <grinberg@compulab.co.il>,
	Uri Mashiach <uri.mashiach@compulab.co.il>,
	Rob Herring <robh@kernel.org>, "Reizer, Eyal" <eyalr@ti.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux-wireless@vger.kernel.org
Subject: [PATCH -next] wlcore: spi: fix non static symbol warning
Date: Fri, 22 Jul 2016 14:08:08 +0000
Message-Id: <1469196488-21050-1-git-send-email-weiyj.lk@gmail.com> (sfid-20160722_160832_217954_4BE2B40B)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the following sparse warning:

drivers/net/wireless/ti/wlcore/spi.c:87:34: warning:
 symbol 'wilink_data' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
 drivers/net/wireless/ti/wlcore/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 6d24040..0ed526e 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -84,7 +84,7 @@ struct wilink_familiy_data {
 	char name[8];
 };
 
-const struct wilink_familiy_data *wilink_data;
+static const struct wilink_familiy_data *wilink_data;
 
 static const struct wilink_familiy_data wl18xx_data = {
 	.name = "wl18xx",

