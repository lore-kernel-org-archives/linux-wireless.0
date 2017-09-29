Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34668 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbdI2TsJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 15:48:09 -0400
Received: by mail-oi0-f66.google.com with SMTP id l81so292690oib.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 Sep 2017 12:48:09 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/10] rtlwifi: Remove redundant semicolon in wifi.h.
Date: Fri, 29 Sep 2017 14:47:52 -0500
Message-Id: <20170929194800.15617-3-Larry.Finger@lwfinger.net> (sfid-20170929_214816_130643_75A56AF4)
In-Reply-To: <20170929194800.15617-1-Larry.Finger@lwfinger.net>
References: <20170929194800.15617-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The semicolon can cause compiler error, if it exists in if...else
statement.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 1ab1024330fb..90e875beff66 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2857,19 +2857,19 @@ value to host byte ordering.*/
 	cpu_to_le32( \
 		LE_BITS_CLEARED_TO_4BYTE(__pstart, __bitoffset, __bitlen) | \
 		((((u32)__val) & BIT_LEN_MASK_32(__bitlen)) << (__bitoffset)) \
-	);
+	)
 #define SET_BITS_TO_LE_2BYTE(__pstart, __bitoffset, __bitlen, __val) \
 	*((__le16 *)(__pstart)) = \
 	cpu_to_le16( \
 		LE_BITS_CLEARED_TO_2BYTE(__pstart, __bitoffset, __bitlen) | \
 		((((u16)__val) & BIT_LEN_MASK_16(__bitlen)) << (__bitoffset)) \
-	);
+	)
 #define SET_BITS_TO_LE_1BYTE(__pstart, __bitoffset, __bitlen, __val) \
 	*((u8 *)(__pstart)) = EF1BYTE \
 	( \
 		LE_BITS_CLEARED_TO_1BYTE(__pstart, __bitoffset, __bitlen) | \
 		((((u8)__val) & BIT_LEN_MASK_8(__bitlen)) << (__bitoffset)) \
-	);
+	)
 
 #define	N_BYTE_ALIGMENT(__value, __aligment) ((__aligment == 1) ? \
 	(__value) : (((__value + __aligment - 1) / __aligment) * __aligment))
-- 
2.13.5
