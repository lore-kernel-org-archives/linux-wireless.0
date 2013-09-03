Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43112 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3ICOec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:32 -0400
Received: by mail-wg0-f41.google.com with SMTP id a12so1343685wgh.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 07:34:31 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/12] wlcore: fix regulatory domain bit translation
Date: Tue,  3 Sep 2013 17:34:05 +0300
Message-Id: <1378218848-7853-9-git-send-email-eliad@wizery.com> (sfid-20130903_163436_719563_C64D820F)
In-Reply-To: <1378218848-7853-1-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

This is a fix for channels 52,56,60,64 bit translation.

Reported-by: Yaniv Machani <yanivma@ti.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index e3ae425..1cb3296 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1613,8 +1613,10 @@ static int wlcore_get_reg_conf_ch_idx(enum ieee80211_band band, u16 ch)
 	case IEEE80211_BAND_5GHZ:
 		if (ch >= 8 && ch <= 16)
 			idx = ((ch-8)/4 + 18);
-		else if (ch >= 34 && ch <= 64)
+		else if (ch >= 34 && ch <= 48)
 			idx = ((ch-34)/2 + 3 + 18);
+		else if (ch >= 52 && ch <= 64)
+			idx = ((ch-52)/4 + 11 + 18);
 		else if (ch >= 100 && ch <= 140)
 			idx = ((ch-100)/4 + 15 + 18);
 		else if (ch >= 149 && ch <= 165)
-- 
1.8.3.rc1.35.g9b79519

