Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35882 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750978AbdJaJqJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 05:46:09 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>,
        Karthik Ananthapadmanabha <karthida@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 1/3] mwifiex: cleanup rx_pkt_lock usage in 11n_rxreorder.c
Date: Tue, 31 Oct 2017 15:12:45 +0530
Message-ID: <1509442967-14149-2-git-send-email-gbhat@marvell.com> (sfid-20171031_104613_624972_14DC6088)
In-Reply-To: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
References: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik Ananthapadmanabha <karthida@marvell.com>

Fix the incorrect usage of rx_pkt_lock spinlock. Realsing the
spinlock while the element is still in process is unsafe. The
lock must be released only after the element processing is
complete.

Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index 1edcdda..0149c4a 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -124,9 +124,10 @@ static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 			rx_tmp_ptr = tbl->rx_reorder_ptr[i];
 			tbl->rx_reorder_ptr[i] = NULL;
 		}
-		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 		if (rx_tmp_ptr)
 			mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
+
+		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -167,8 +168,8 @@ static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 		}
 		rx_tmp_ptr = tbl->rx_reorder_ptr[i];
 		tbl->rx_reorder_ptr[i] = NULL;
-		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 		mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
+		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
-- 
1.9.1
