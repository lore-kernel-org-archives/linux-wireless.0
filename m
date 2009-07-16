Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47921 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbZGPJdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:33:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/10] iwmc3200wifi: fix UMAC INIT_COMPLETE notification handling
Date: Thu, 16 Jul 2009 17:34:06 +0800
Message-Id: <1247736854-6760-2-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1247736854-6760-1-git-send-email-yi.zhu@intel.com>
References: <1247736854-6760-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the missing UMAC iwm_umac_wifi_in_hdr header in
the UMAC INIT_COMPLETE (iwm_umac_notif_init_complete) notification.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c   |    1 -
 drivers/net/wireless/iwmc3200wifi/umac.h |    6 ++++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 3909477..59ef69c 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -102,7 +102,6 @@ static int iwm_ntf_error(struct iwm_priv *iwm, u8 *buf,
 	error = (struct iwm_umac_notif_error *)buf;
 	fw_err = &error->err;
 
-
 	IWM_ERR(iwm, "%cMAC FW ERROR:\n",
 	 (le32_to_cpu(fw_err->category) == UMAC_SYS_ERR_CAT_LMAC) ? 'L' : 'U');
 	IWM_ERR(iwm, "\tCategory:    %d\n", le32_to_cpu(fw_err->category));
diff --git a/drivers/net/wireless/iwmc3200wifi/umac.h b/drivers/net/wireless/iwmc3200wifi/umac.h
index 0af2a3c..c5a14ae 100644
--- a/drivers/net/wireless/iwmc3200wifi/umac.h
+++ b/drivers/net/wireless/iwmc3200wifi/umac.h
@@ -615,6 +615,7 @@ struct iwm_umac_notif_alive {
 } __attribute__ ((packed));
 
 struct iwm_umac_notif_init_complete {
+	struct iwm_umac_wifi_in_hdr hdr;
 	__le16 status;
 	__le16 reserved;
 } __attribute__ ((packed));
@@ -643,6 +644,11 @@ struct iwm_fw_error_hdr {
 	__le32 umac_status;
 	__le32 lmac_status;
 	__le32 sdio_status;
+	__le32 dbm_sample_ctrl;
+	__le32 dbm_buf_base;
+	__le32 dbm_buf_end;
+	__le32 dbm_buf_write_ptr;
+	__le32 dbm_buf_cycle_cnt;
 } __attribute__ ((packed));
 
 struct iwm_umac_notif_error {
-- 
1.6.0.4

