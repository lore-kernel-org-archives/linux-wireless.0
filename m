Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:51822 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754788Ab2A0NJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 08:09:20 -0500
Date: Fri, 27 Jan 2012 18:34:39 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH] mwl8k: Configuring correct MAC address in broadcast key
Message-ID: <20120127130434.GA5718@hertz.marvell.com> (sfid-20120127_140943_602739_E464405B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While configuring the broadcast key in the hardware, in
multi-BSS environment, BSSes other than first were
incorrectly configured with the MAC address of first
BSS. Fixing it with correct MAC addresses.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
(resent to include the linux-wireless list)


 drivers/net/wireless/mwl8k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index dd5aeaf..fd12547 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4093,7 +4093,7 @@ static int mwl8k_set_key(struct ieee80211_hw *hw,
 		return -EOPNOTSUPP;
 
 	if (sta == NULL)
-		addr = hw->wiphy->perm_addr;
+		addr = vif->addr;
 	else
 		addr = sta->addr;
 
-- 
1.7.5.4

