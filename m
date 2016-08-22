Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34742 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756645AbcHVT2M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 15:28:12 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH V2] rtlwifi: Fix missing country code for Great Britain
Date: Mon, 22 Aug 2016 14:27:59 -0500
Message-Id: <1471894079-14330-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160822_212835_200472_079424B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some RTL8821AE devices sold in Great Britain have the country code of
0x25 encoded in their EEPROM. This value is not tested in the routine
that establishes the regulatory info for the chip. The fix is to set
this code to have the same capabilities as the EU countries. In addition,
the channels allowed for COUNTRY_CODE_ETSI were more properly suited
for China and Israel, not the EU. This problem has also been fixed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

V2 - Explain why channels for ETSI have been modified.
---
 drivers/net/wireless/realtek/rtlwifi/regd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index 3524441..6ee6bf8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -345,9 +345,9 @@ static const struct ieee80211_regdomain *_rtl_regdomain_select(
 		return &rtl_regdom_no_midband;
 	case COUNTRY_CODE_IC:
 		return &rtl_regdom_11;
-	case COUNTRY_CODE_ETSI:
 	case COUNTRY_CODE_TELEC_NETGEAR:
 		return &rtl_regdom_60_64;
+	case COUNTRY_CODE_ETSI:
 	case COUNTRY_CODE_SPAIN:
 	case COUNTRY_CODE_FRANCE:
 	case COUNTRY_CODE_ISRAEL:
@@ -406,6 +406,8 @@ static u8 channel_plan_to_country_code(u8 channelplan)
 		return COUNTRY_CODE_WORLD_WIDE_13;
 	case 0x22:
 		return COUNTRY_CODE_IC;
+	case 0x25:
+		return COUNTRY_CODE_ETSI;
 	case 0x32:
 		return COUNTRY_CODE_TELEC_NETGEAR;
 	case 0x41:
-- 
2.6.6
