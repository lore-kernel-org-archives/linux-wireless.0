Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:49728 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbbACO7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2015 09:59:52 -0500
Message-ID: <1420297188.2397.3.camel@tiscali.nl> (sfid-20150103_160018_629686_F0102BF0)
Subject: [PATCH] Revert "ipw2200: select CFG80211_WEXT"
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Jiri Kosina <jkosina@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Sat, 03 Jan 2015 15:59:48 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit dddd60220f41775e634258efd1b54c6fa81ce706.

The raison d'être of commit dddd60220f41 ("ipw2200: select
CFG80211_WEXT") was reverted in commit 2d36e008739e ("Revert "cfg80211:
make WEXT compatibility unselectable""). So revert this commit too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/net/wireless/ipw2x00/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 21de4fe6cf2d..91c0cb3c368e 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -65,8 +65,7 @@ config IPW2100_DEBUG
 
 config IPW2200
 	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
-	depends on PCI && CFG80211
-	select CFG80211_WEXT
+	depends on PCI && CFG80211 && CFG80211_WEXT
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
-- 
2.1.0

