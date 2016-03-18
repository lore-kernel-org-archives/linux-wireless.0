Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35774 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbcCRCWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:22:31 -0400
Received: by mail-pf0-f175.google.com with SMTP id n5so145890697pfn.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:22:31 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Geliang Tang <geliangtang@163.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Colin Ian King <colin.king@canonical.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 05/19] rtlwifi: use to_delayed_work()
Date: Fri, 18 Mar 2016 13:22:24 +1100
Message-Id: <1d07f186a933c2d1f0bf1780ab1dcb50d3a808aa.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032234_587865_52DD6645)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Geliang Tang <geliangtang@163.com>

Use to_delayed_work() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
[Update commit message]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 554d814..edece53 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2867,7 +2867,7 @@ value to host byte ordering.*/
 	(ppsc->cur_ps_level |= _ps_flg)
 
 #define container_of_dwork_rtl(x, y, z) \
-	container_of(container_of(x, struct delayed_work, work), y, z)
+	container_of(to_delayed_work(x), y, z)
 
 #define FILL_OCTET_STRING(_os, _octet, _len)	\
 		(_os).octet = (u8 *)(_octet);		\
-- 
2.7.0

