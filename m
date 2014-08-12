Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:64785 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaHLGwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 02:52:42 -0400
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <dsd@gentoo.org>, <kune@deine-taler.de>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Sanjeev Sharma <sanjeev_sharma@mentor.com>,
	Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()
Date: Tue, 12 Aug 2014 12:35:33 +0530
Message-ID: <1407827133-29493-1-git-send-email-sanjeev_sharma@mentor.com> (sfid-20140812_085325_305254_E642EA42)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

on some architecture spin_is_locked() always return false in
uniprocessor configuration and therefore it would be advise
to replace with lockdep_assert_held().

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/net/wireless/zd1211rw/zd_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index e7af261..72c0bc2 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -235,7 +235,7 @@ void zd_mac_clear(struct zd_mac *mac)
 {
 	flush_workqueue(zd_workqueue);
 	zd_chip_clear(&mac->chip);
-	ZD_ASSERT(!spin_is_locked(&mac->lock));
+	lockdep_assert_held(!spin_is_locked(&mac->lock));
 	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
 }
 
-- 
1.7.11.7

