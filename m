Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbZJPFVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:21:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 11/16] iwmc3200wifi: Check for cmd pointer before dereferencing it
Date: Fri, 16 Oct 2009 13:18:55 +0800
Message-Id: <1255670340-22565-12-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-11-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

The wifi_if_wrapper notification handling code uses a cmd pointer without
checking if it's valid or not. We're dereferencing it because we assume that
we only get to that point if there was a pending command for us. That's not
always true, so we'd better check.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index a6b1811..0fa3f5c 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1058,8 +1058,14 @@ static int iwm_ntf_wifi_if_wrapper(struct iwm_priv *iwm, u8 *buf,
 				   unsigned long buf_size,
 				   struct iwm_wifi_cmd *cmd)
 {
-	struct iwm_umac_wifi_if *hdr =
-			(struct iwm_umac_wifi_if *)cmd->buf.payload;
+	struct iwm_umac_wifi_if *hdr;
+
+	if (cmd == NULL) {
+		IWM_ERR(iwm, "Couldn't find expected wifi command\n");
+		return -EINVAL;
+	}
+
+	hdr = (struct iwm_umac_wifi_if *)cmd->buf.payload;
 
 	IWM_DBG_NTF(iwm, DBG, "WIFI_IF_WRAPPER cmd is delivered to UMAC: "
 		    "oid is 0x%x\n", hdr->oid);
-- 
1.6.0.4

