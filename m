Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50875 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932256AbcI1MuM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 08:50:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8SCnXd3022335
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:50:11 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 25r7vna8ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:50:11 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 7/8] mwifiex: fix command timeout problem seen in stress tests
Date: Wed, 28 Sep 2016 18:18:27 +0530
Message-ID: <1475066908-11771-7-git-send-email-akarwar@marvell.com> (sfid-20160928_145015_275784_92DBD441)
In-Reply-To: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
References: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

It is observed that if single tid 6 packet comes among with massive tid 0
packets, tid 6 packet may stay in it's queue and will never be
transmited. This is because wmm.highest_queued_prio will be set to 2
during transmission of tid 0 packets As a result, main work thread
keeps on looping without serving that packet. In this case, if command
has downloaded to firmware, driver doesn't process it's response causing
command timeout.

This patch will reset highest_queued_prio if packets exist in data
queue, and try to find a ra_list for current private.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.h |  1 +
 drivers/net/wireless/marvell/mwifiex/wmm.c  | 13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 26df28f..d61fe3a 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -315,6 +315,7 @@ struct mwifiex_tid_tbl {
 #define WMM_HIGHEST_PRIORITY		7
 #define HIGH_PRIO_TID				7
 #define LOW_PRIO_TID				0
+#define NO_PKT_PRIO_TID				-1
 #define MWIFIEX_WMM_DRV_DELAY_MAX 510
 
 struct mwifiex_wmm_desc {
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index 1ff3a87..28c2f6f 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -1105,6 +1105,7 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				    &adapter->bss_prio_tbl[j].bss_prio_head,
 				    list) {
 
+try_again:
 			priv_tmp = adapter->bss_prio_tbl[j].bss_prio_cur->priv;
 
 			if (((priv_tmp->bss_mode != NL80211_IFTYPE_ADHOC) &&
@@ -1140,8 +1141,18 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 						       ra_list_spinlock,
 						       flags_ra);
 			}
-		}
 
+			if (atomic_read(&priv_tmp->wmm.tx_pkts_queued) != 0) {
+				atomic_set(&priv_tmp->wmm.highest_queued_prio,
+					   HIGH_PRIO_TID);
+				/* Iterate current private once more, since
+				 * there still exist packets in data queue
+				 */
+				goto try_again;
+			} else
+				atomic_set(&priv_tmp->wmm.highest_queued_prio,
+					   NO_PKT_PRIO_TID);
+		}
 	}
 
 	return NULL;
-- 
1.9.1
