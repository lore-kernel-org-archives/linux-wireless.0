Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:20309 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758248AbXGPAK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2007 20:10:56 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] rtl8187: ensure priv->hwaddr is always valid
Date: Sun, 15 Jul 2007 17:09:55 -0700
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Message-Id: <200707151709.55429.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

conf->mac_addr is not guaranteed to be set. This ensures priv->hwaddr is
always set to a valid mac address. Thanks to Johannes Berg
<johannes@sipsolutions.net> for finding this problem.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8187_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index cea8589..e61c6d5 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -466,7 +466,7 @@ static int rtl8187_add_interface(struct ieee80211_hw *dev,
 		return -EOPNOTSUPP;
 	}
 
-	priv->hwaddr = conf->mac_addr;
+	priv->hwaddr = conf->mac_addr ? conf->mac_addr : dev->wiphy->perm_addr;
 
 	return 0;
 }

