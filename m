Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37512 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751938AbeDYJig (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 05:38:36 -0400
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH 2/3] mwifiex: always configure firmware mac address during changing virtual interface
Date: Wed, 25 Apr 2018 17:38:13 +0800
Message-ID: <1524649094-20069-2-git-send-email-huxm@marvell.com> (sfid-20180425_113839_885403_FDAE5663)
In-Reply-To: <1524649094-20069-1-git-send-email-huxm@marvell.com>
References: <1524649094-20069-1-git-send-email-huxm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When interface type changed, firmware using a new connction pointer.
We need Re-configure the mac address.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 2d9cb7d..b5f99a1 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -965,9 +965,6 @@ int mwifiex_set_mac_address(struct mwifiex_private *priv,
 			mac_addr ^= BIT_ULL(priv->bss_type + 8);
 			mac_addr += priv->bss_num;
 		}
-
-		if (mac_addr == old_mac_addr)
-			goto done;
 	}
 
 	u64_to_ether_addr(mac_addr, priv->curr_addr);
@@ -983,7 +980,6 @@ int mwifiex_set_mac_address(struct mwifiex_private *priv,
 		return ret;
 	}
 
-done:
 	ether_addr_copy(dev->dev_addr, priv->curr_addr);
 	return 0;
 }
-- 
1.9.1
