Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61132 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758759Ab3DBAJH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 20:09:07 -0400
Received: from mailout-de.gmx.net ([10.1.76.24]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LaIM4-1V3HbQ17q2-00m354 for
 <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2013 02:09:06 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: bzhao@marvell.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	daniel@zonque.org,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 2/6] mwifiex: bug: wrong list in list_empty check.
Date: Tue,  2 Apr 2013 02:08:41 +0200
Message-Id: <1364861325-30844-2-git-send-email-andreas.fenkart@streamunlimited.com> (sfid-20130402_020926_448017_4ACC370C)
In-Reply-To: <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
References: <20130402000511.GA31921@blumentopf>
 <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adapter->bss_prio_tbl list has already been checked in outer loop. The
inner loop works with priv_tmp->wmm.tid_tbl_ptr list. Also the lock taken,
gives hint that this is likely a copy-paste error.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 drivers/net/wireless/mwifiex/wmm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 91dee27..5b454d6 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -937,8 +937,7 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				spin_lock_irqsave(&tid_ptr->tid_tbl_lock,
 						  flags);
 				is_list_empty =
-					list_empty(&adapter->bss_prio_tbl[j]
-						   .bss_prio_head);
+					list_empty(&tid_ptr->ra_list);
 				spin_unlock_irqrestore(&tid_ptr->tid_tbl_lock,
 						       flags);
 				if (is_list_empty)
-- 
1.7.10.4

