Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57809 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbcGaKtx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2016 06:49:53 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] mwifiex: remove superfluous condition (2)
Date: Sun, 31 Jul 2016 12:49:37 +0200
Message-Id: <1469962177-2432-1-git-send-email-xypron.glpk@gmx.de> (sfid-20160731_125027_926428_5FF87AA6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are using mac as source address in a memcpy.
In the lines below we can assume mac is not NULL.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 128add8..0d4f9fe 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -706,15 +706,10 @@ mwifiex_cmd_802_11_key_material_v2(struct mwifiex_private *priv,
 				    (priv->wep_key_curr_index & KEY_INDEX_MASK))
 					key_info |= KEY_DEFAULT;
 			} else {
-				if (mac) {
-					if (is_broadcast_ether_addr(mac))
-						key_info |= KEY_MCAST;
-					else
-						key_info |= KEY_UNICAST |
-							    KEY_DEFAULT;
-				} else {
+				if (is_broadcast_ether_addr(mac))
 					key_info |= KEY_MCAST;
-				}
+				else
+					key_info |= KEY_UNICAST | KEY_DEFAULT;
 			}
 		}
 		km->key_param_set.key_info = cpu_to_le16(key_info);
-- 
2.8.1

