Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:59170 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab1EDMBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 08:01:15 -0400
Date: Wed, 4 May 2011 17:22:16 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH] mwl8k: Fix broken WEP
Message-ID: <20110504115209.GA9940@hertz.marvell.com> (sfid-20110504_140118_229957_91D3820B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The WEP key length was being set to 0 erroneously which broke WEP support.
Fix the same by setting the key length appropriately.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3223eea..1e8b8fa 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3997,7 +3997,7 @@ static int mwl8k_cmd_encryption_set_key(struct ieee80211_hw *hw,
 			mwl8k_vif->wep_key_conf[idx].enabled = 1;
 		}
 
-		keymlen = 0;
+		keymlen = key->keylen;
 		action = MWL8K_ENCR_SET_KEY;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-- 
1.5.4.1

