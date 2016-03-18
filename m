Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36090 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbcCRC2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:28:41 -0400
Received: by mail-pf0-f169.google.com with SMTP id u190so146281712pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:28:41 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Sara Sharon <sarasharon1@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH MOREWORK 17/19] iwl4965: Fix a memory leak in error handling code of __il4965_up
Date: Fri, 18 Mar 2016 13:28:33 +1100
Message-Id: <3aaac3629455d27b0e9c56ef1615b89873b1b8cf.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032848_304792_F40B1805)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jia-Ju Bai <baijiaju1990@163.com>

When il4965_hw_nic_init in __il4965_up fails, the memory allocated by
iwl4965_sta_alloc_lq in iwl4965_alloc_bcast_station is not freed.

This patches adds il_dealloc_bcast_stations in the error handling code of
__il4965_up to fix this problem.

This patch has been tested in real device, and it actually fixes the bug.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index b75f4ef..30d9dd3 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -5577,6 +5577,7 @@ __il4965_up(struct il_priv *il)
 	ret = il4965_hw_nic_init(il);
 	if (ret) {
 		IL_ERR("Unable to init nic\n");
+		il_dealloc_bcast_stations(il);
 		return ret;
 	}
 
-- 
2.7.0

