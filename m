Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:30594 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab1GOXG3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 19:06:29 -0400
Subject: [PATCH 1/4] ath: use get_unaligned_le{16,32} in ath_hw_keysetmac()
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 15 Jul 2011 19:06:27 -0400
Message-ID: <20110715230627.4461.85730.stgit@mj.roinet.com> (sfid-20110716_010631_940868_A73F5BD8)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/key.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index a61ef3d6..17b0efd 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -105,11 +105,8 @@ static bool ath_hw_keysetmac(struct ath_common *common,
 		if (mac[0] & 0x01)
 			unicast_flag = 0;
 
-		macHi = (mac[5] << 8) | mac[4];
-		macLo = (mac[3] << 24) |
-			(mac[2] << 16) |
-			(mac[1] << 8) |
-			mac[0];
+		macLo = get_unaligned_le32(mac);
+		macHi = get_unaligned_le16(mac + 4);
 		macLo >>= 1;
 		macLo |= (macHi & 1) << 31;
 		macHi >>= 1;
