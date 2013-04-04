Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62340 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762451Ab3DDVBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 17:01:36 -0400
Received: from mailout-de.gmx.net ([10.1.76.4]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MKwSE-1UNrHq3NVw-0006P1 for
 <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2013 23:01:34 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: bzhao@marvell.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	daniel@zonque.org,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 1/4] mwifiex: bug: wrong list in list_empty check.
Date: Thu,  4 Apr 2013 23:01:22 +0200
Message-Id: <1365109286-5075-1-git-send-email-andreas.fenkart@streamunlimited.com> (sfid-20130404_230139_443367_BD4B0111)
In-Reply-To: <20130404205706.GA29851@blumentopf>
References: <20130404205706.GA29851@blumentopf>
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
index 32adc87..b132c42 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -933,8 +933,7 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
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

