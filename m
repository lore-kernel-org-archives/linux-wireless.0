Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab1LWHOa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 02:14:30 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 06/10] iwlegacy: 3945: get rid of hw_{set,get}_rate
Date: Fri, 23 Dec 2011 08:13:46 +0100
Message-Id: <1324624430-3688-6-git-send-email-sgruszka@redhat.com> (sfid-20111223_081433_424492_0BCE8869)
In-Reply-To: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
References: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove these helpers, some are not unused at all, one can be
unrolled in place of use.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c |    3 +--
 drivers/net/wireless/iwlegacy/3945.h |   18 ------------------
 2 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 0b99deb..44a1211 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -2331,8 +2331,7 @@ il3945_init_hw_rate_table(struct il_priv *il)
 	for (i = 0; i < ARRAY_SIZE(il3945_rates); i++) {
 		idx = il3945_rates[i].table_rs_idx;
 
-		table[idx].rate_n_flags =
-		    il3945_hw_set_rate_n_flags(il3945_rates[i].plcp, 0);
+		table[idx].rate_n_flags = cpu_to_le16(il3945_rates[i].plcp);
 		table[idx].try_cnt = il->retry_rate;
 		prev_idx = il3945_get_prev_ieee_rate(i);
 		table[idx].next_rate_idx = il3945_rates[prev_idx].table_rs_idx;
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index 2b2895c..970e5c3 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -476,24 +476,6 @@ struct il3945_shared {
 	__le32 tx_base_ptr[8];
 } __packed;
 
-static inline u8
-il3945_hw_get_rate(__le16 rate_n_flags)
-{
-	return le16_to_cpu(rate_n_flags) & 0xFF;
-}
-
-static inline u16
-il3945_hw_get_rate_n_flags(__le16 rate_n_flags)
-{
-	return le16_to_cpu(rate_n_flags);
-}
-
-static inline __le16
-il3945_hw_set_rate_n_flags(u8 rate, u16 flags)
-{
-	return cpu_to_le16((u16) rate | flags);
-}
-
 /************************************/
 /* iwl3945 Flow Handler Definitions */
 /************************************/
-- 
1.7.4.4

