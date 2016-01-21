Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36646 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbcAUD6v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 22:58:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	littlesmartguy@gmail.com, gabe@codehaus.org,
	Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8821ae: Fix 5G failure when EEPROM is incorrectly encoded
Date: Wed, 20 Jan 2016 21:58:39 -0600
Message-Id: <1453348719-5546-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160121_045856_231577_149B5E63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently, it has been reported that D-Link DWA-582 cards, which use an
RTL8812AE chip are not able to scan for 5G networks. The problems started
with kernel 4.2, which is the first version that had commit d10101a60372
("rtlwifi: rtl8821ae: Fix problem with regulatory information"). With this
patch, the driver went from setting a default channel plan to using
the value derived from EEPROM.

Bug reports at https://bugzilla.kernel.org/show_bug.cgi?id=111031 and
https://bugzilla.redhat.com/show_bug.cgi?id=1279653 are examples of this
problem.

The problem was solved once I learned that the internal country code was
resulting in a regulatory set with only 2.4 GHz channels. With the RTL8821AE
chips available to me, the country code was such that both 2.4 and 5 GHz
channels are allowed. The fix is to allow both bands even when the EEPROM
is incorrectly encoded.

Fixes: d10101a60372 ("rtlwifi: rtl8821ae: Fix problem with regulatory information")
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: littlesmartguy@gmail.com
Cc: gabe@codehaus.org
Cc: Stable <stable@vger.kernel.org> [v4.2+]
---
 drivers/net/wireless/realtek/rtlwifi/regd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index a62bf0a..5be3411 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -351,7 +351,6 @@ static const struct ieee80211_regdomain *_rtl_regdomain_select(
 	case COUNTRY_CODE_SPAIN:
 	case COUNTRY_CODE_FRANCE:
 	case COUNTRY_CODE_ISRAEL:
-	case COUNTRY_CODE_WORLD_WIDE_13:
 		return &rtl_regdom_12_13;
 	case COUNTRY_CODE_MKK:
 	case COUNTRY_CODE_MKK1:
@@ -360,6 +359,7 @@ static const struct ieee80211_regdomain *_rtl_regdomain_select(
 		return &rtl_regdom_14_60_64;
 	case COUNTRY_CODE_GLOBAL_DOMAIN:
 		return &rtl_regdom_14;
+	case COUNTRY_CODE_WORLD_WIDE_13:
 	case COUNTRY_CODE_WORLD_WIDE_13_5G_ALL:
 		return &rtl_regdom_12_13_5g_all;
 	default:
-- 
2.1.4

