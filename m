Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:54282 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3LQUpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:36 -0500
Received: by mail-ee0-f47.google.com with SMTP id e51so2653077eek.34
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:36 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/36] iwlwifi: mvm: rs: fix variable shadowing
Date: Tue, 17 Dec 2013 22:44:39 +0200
Message-Id: <1387313079-28123-36-git-send-email-egrumbach@gmail.com> (sfid-20131217_214546_130563_F9BE1B80)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: EyalX Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 1f06450..d6d28d7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2718,12 +2718,10 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			lq_sta->lq.initial_rate_index[3]);
 
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
-		u32 rate = le32_to_cpu(lq_sta->lq.rs_table[i]);
-		desc += sprintf(buff+desc,
-				" rate[%d] 0x%X ",
-				i, rate);
+		u32 r = le32_to_cpu(lq_sta->lq.rs_table[i]);
 
-		desc += rs_pretty_print_rate(buff+desc, rate);
+		desc += sprintf(buff+desc, " rate[%d] 0x%X ", i, r);
+		desc += rs_pretty_print_rate(buff+desc, r);
 	}
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
-- 
1.7.9.5

