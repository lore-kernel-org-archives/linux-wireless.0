Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:62103 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbcFPNwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 09:52:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: netdev@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"David S. Miller" <davem@davemloft.net>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] wireless: ipw2200: fix old-style declaration
Date: Thu, 16 Jun 2016 15:52:10 +0200
Message-Id: <20160616135245.3198419-3-arnd@arndb.de> (sfid-20160616_155219_554423_2AA103E4)
In-Reply-To: <20160616135245.3198419-1-arnd@arndb.de>
References: <20160616135020.3154461-1-arnd@arndb.de>
 <20160616135245.3198419-1-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modern C standards expect the 'inline' keyword to come before the return
type in a declaration, and we get a warning for this with "make W=1":

drivers/net/wireless/intel/ipw2x00/ipw2200.c:4096:1: error: 'inline' is not at beginning of declaration [-Werror=old-style-declaration]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 5adb7cefb2fe..bfd68612a535 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -4093,7 +4093,7 @@ static const char *ipw_get_status_code(u16 status)
 	return "Unknown status value.";
 }
 
-static void inline average_init(struct average *avg)
+static inline void average_init(struct average *avg)
 {
 	memset(avg, 0, sizeof(*avg));
 }
-- 
2.9.0

