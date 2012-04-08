Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab2DHTNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 15:13:11 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so5092406iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2012 12:13:11 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Forest Bond <forest.bond@rapidrollout.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/2 V3] rtl8192de: Recognize 92D E-CUT version.
Date: Sun,  8 Apr 2012 14:12:34 -0500
Message-Id: <1333912354-16983-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120408_211340_712180_823B2AD2)
In-Reply-To: <1333912354-16983-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1333912354-16983-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Forest Bond <forest.bond@rapidrollout.com>

The chip version constant (0xCC33) was taken from version 0001.0105.2011
of the GPL vendor driver.  Note that this driver version also ships a
firmware update, but I am unsure if it is required for E-CUT chips to
function properly.

A nearby spelling error was also corrected.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 drivers/net/wireless/rtlwifi/rtl8192de/hw.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index 7d87712..2655448 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1743,9 +1743,13 @@ static void _rtl92de_efuse_update_chip_version(struct ieee80211_hw *hw)
 		chipver |= CHIP_92D_D_CUT;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "D-CUT!!!\n");
 		break;
+	case 0xCC33:
+		chipver |= CHIP_92D_E_CUT;
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "E-CUT!!!\n");
+		break;
 	default:
 		chipver |= CHIP_92D_D_CUT;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Unkown CUT!\n");
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Unknown CUT!\n");
 		break;
 	}
 	rtlpriv->rtlhal.version = chipver;
-- 
1.7.10

