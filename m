Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lucky1.263xmail.com ([211.157.147.133]:48191 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760863AbdEZBnj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 21:43:39 -0400
From: Shawn Lin <shawn.lin@rock-chips.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Xinming Hu <huxm@marvell.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH] mwifiex: simplify the code around ra_list
Date: Fri, 26 May 2017 09:41:49 +0800
Message-Id: <1495762909-46795-1-git-send-email-shawn.lin@rock-chips.com> (sfid-20170526_034450_436838_B460ED03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't need to check if the list is empty separately
as we could use list_first_entry_or_null to cover it.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/net/wireless/marvell/mwifiex/tdls.c | 7 ++-----
 drivers/net/wireless/marvell/mwifiex/wmm.c  | 8 ++------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index 7d0d3ff..d76ce87 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -55,11 +55,8 @@ static void mwifiex_restore_tdls_packets(struct mwifiex_private *priv,
 			tx_info->flags |= MWIFIEX_BUF_FLAG_TDLS_PKT;
 		} else {
 			tid_list = &priv->wmm.tid_tbl_ptr[tid_down].ra_list;
-			if (!list_empty(tid_list))
-				ra_list = list_first_entry(tid_list,
-					      struct mwifiex_ra_list_tbl, list);
-			else
-				ra_list = NULL;
+			ra_list = list_first_entry_or_null(tid_list,
+					struct mwifiex_ra_list_tbl, list);
 			tx_info->flags &= ~MWIFIEX_BUF_FLAG_TDLS_PKT;
 		}
 
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index e4ff3b9..744b014 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -868,12 +868,8 @@ struct mwifiex_ra_list_tbl *
 			return;
 		default:
 			list_head = priv->wmm.tid_tbl_ptr[tid_down].ra_list;
-			if (!list_empty(&list_head))
-				ra_list = list_first_entry(
-					&list_head, struct mwifiex_ra_list_tbl,
-					list);
-			else
-				ra_list = NULL;
+			ra_list = list_first_entry_or_null(&list_head,
+					struct mwifiex_ra_list_tbl, list);
 			break;
 		}
 	} else {
-- 
1.9.1
