Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s87.loopia.se ([194.9.94.112]:34189 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbaHFEnx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2014 00:43:53 -0400
From: Hans Wennborg <hans@hanshq.net>
To: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 08/15] rtlwifi: rtl8192de: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:43:06 -0700
Message-Id: <1407300186-32673-1-git-send-email-hans@hanshq.net> (sfid-20140806_064629_956368_5F74EC74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
index 2317707..66e1760 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
@@ -234,7 +234,7 @@ static int _rtl92d_fw_init(struct ieee80211_hw *hw)
 			 rtl_read_byte(rtlpriv, FW_MAC1_READY));
 	}
 	RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
-		 "Polling FW ready fail!! REG_MCUFWDL:0x%08ul\n",
+		 "Polling FW ready fail!! REG_MCUFWDL:0x%08lx\n",
 		 rtl_read_dword(rtlpriv, REG_MCUFWDL));
 	return -1;
 }
-- 
2.0.0.526.g5318336

