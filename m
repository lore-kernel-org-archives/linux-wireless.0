Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35429 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbcCRC2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:28:20 -0400
Received: by mail-pf0-f175.google.com with SMTP id n5so146081395pfn.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:28:20 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Byeoungwook Kim <quddnr145@gmail.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Sara Sharon <sarasharon1@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luis Felipe Dominguez Vega <lfdominguez@nauta.cu>,
	linux-wireless@vger.kernel.org
Subject: [PATCH MOREWORK 16/19] rtlwifi: Implement 'rtl_addr_delay()' with a switch statement
Date: Fri, 18 Mar 2016 13:28:11 +1100
Message-Id: <bc393706a087bf9746d7e91963e11819a854c4f7.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032823_798851_C4EF745D)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Byeoungwook Kim <quddnr145@gmail.com>

Doing it this way improves readability.

Signed-off-by: Byeoungwook Kim <quddnr145@gmail.com>
[Rewrote commit message]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

---

... or does it.

Honesltly, this is only in this list as Byeoungwook asked about it and I
can see _some_ sort of reason why it exists.

Larry, if you don't like this, please NACK it and we'll never speak of it
again.

Thanks,

Julian Calaby
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 0f48048..1cf367f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -53,18 +53,26 @@ EXPORT_SYMBOL(channel5g_80m);
 
 void rtl_addr_delay(u32 addr)
 {
-	if (addr == 0xfe)
+	switch (addr) {
+	case 0xfe:
 		msleep(50);
-	else if (addr == 0xfd)
+		break;
+	case 0xfd:
 		msleep(5);
-	else if (addr == 0xfc)
+		break;
+	case 0xfc:
 		msleep(1);
-	else if (addr == 0xfb)
+		break;
+	case 0xfb:
 		usleep_range(50, 100);
-	else if (addr == 0xfa)
+		break;
+	case 0xfa:
 		usleep_range(5, 10);
-	else if (addr == 0xf9)
+		break;
+	case 0xf9:
 		usleep_range(1, 2);
+		break;
+	}
 }
 EXPORT_SYMBOL(rtl_addr_delay);
 
-- 
2.7.0

