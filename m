Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:3840 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbaF1MUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 08:20:13 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] drivers/net/wireless/ipw2x00/libipw_module.c: remove unnecessary null test before kfree
Date: Sat, 28 Jun 2014 14:18:52 +0200
Message-Id: <1403957932-3709-1-git-send-email-fabf@skynet.be> (sfid-20140628_142035_752533_FCC6B736)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/ipw2x00/libipw_module.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index 3adb240..5f31b72 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -100,8 +100,7 @@ static inline void libipw_networks_free(struct libipw_device *ieee)
 	int i;
 
 	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
-		if (ieee->networks[i]->ibss_dfs)
-			kfree(ieee->networks[i]->ibss_dfs);
+		kfree(ieee->networks[i]->ibss_dfs);
 		kfree(ieee->networks[i]);
 	}
 }
-- 
1.8.4.5

