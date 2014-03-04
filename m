Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176AbaCDNQR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 08:16:17 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwl4965: disable 8K A-MSDU by default
Date: Tue,  4 Mar 2014 14:18:42 +0100
Message-Id: <1393939122-20148-1-git-send-email-sgruszka@redhat.com> (sfid-20140304_141625_854733_483CFE68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlegacy version of this iwlwifi patch:

commit aed7d9ac1836defe033b561f4306e39014ac56fd
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Wed Feb 20 11:33:00 2013 +0200

    iwlwifi: disable 8K A-MSDU by default

    Supporting 8K A-MSDU means that we need to allocate order 1
    pages for every Rx packet. Even when there is no traffic.
    This adds stress on the memory manager. The handling of
    compound pages is also less trivial for the memory manager
    and not using them will make the allocation code run faster
    although I didn't really measure.
    Eric also pointed out that having huge buffers with little
    data in them is not very nice towards the TCP stack since
    the truesize of the skb is huge. This doesn't allow TCP
    to have a big Rx window.
    See https://patchwork.kernel.org/patch/2167711/ for details.

    Note that very few vendors will actually send A-MSDU.
    Disable this feature by default.

    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 3 +--
 drivers/net/wireless/iwlegacy/common.h   | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 50673f7..888ad5c 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -92,7 +92,6 @@ il4965_check_abort_status(struct il_priv *il, u8 frame_count, u32 status)
  * EEPROM
  */
 struct il_mod_params il4965_mod_params = {
-	.amsdu_size_8K = 1,
 	.restart_fw = 1,
 	/* the rest are 0 by default */
 };
@@ -6866,6 +6865,6 @@ module_param_named(11n_disable, il4965_mod_params.disable_11n, int, S_IRUGO);
 MODULE_PARM_DESC(11n_disable, "disable 11n functionality");
 module_param_named(amsdu_size_8K, il4965_mod_params.amsdu_size_8K, int,
 		   S_IRUGO);
-MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
+MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size (default 0 [disabled])");
 module_param_named(fw_restart, il4965_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 13145ad..dfb13c7 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1598,7 +1598,7 @@ struct il_mod_params {
 	int disable_hw_scan;	/* def: 0 = use h/w scan */
 	int num_of_queues;	/* def: HW dependent */
 	int disable_11n;	/* def: 0 = 11n capabilities enabled */
-	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
+	int amsdu_size_8K;	/* def: 0 = disable 8K amsdu size */
 	int antenna;		/* def: 0 = both antennas (use diversity) */
 	int restart_fw;		/* def: 1 = restart firmware */
 };
-- 
1.7.11.7

