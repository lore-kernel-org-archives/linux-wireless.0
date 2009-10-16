Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbZJPFVY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:21:24 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 14/16] iwmc3200wifi: Support unexpected reboot barker
Date: Fri, 16 Oct 2009 13:18:58 +0800
Message-Id: <1255670340-22565-15-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-14-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-6-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-7-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-8-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-9-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-10-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-11-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-12-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-13-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-14-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

We can receive unexpected reboot barker at any time, and we're supposed to
reset the whole device then.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index c0fa853..95deb0a 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1322,6 +1322,14 @@ int iwm_rx_handle(struct iwm_priv *iwm, u8 *buf, unsigned long buf_size)
 
 	switch (le32_to_cpu(hdr->cmd)) {
 	case UMAC_REBOOT_BARKER:
+		if (test_bit(IWM_STATUS_READY, &iwm->status)) {
+			IWM_ERR(iwm, "Unexpected BARKER\n");
+
+			schedule_work(&iwm->reset_worker);
+
+			return 0;
+		}
+
 		return iwm_notif_send(iwm, NULL, IWM_BARKER_REBOOT_NOTIFICATION,
 				      IWM_SRC_UDMA, buf, buf_size);
 	case UMAC_ACK_BARKER:
-- 
1.6.0.4

