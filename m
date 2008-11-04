Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39826 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbYKDUVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 15:21:17 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwl3945: do not send scan command if channel count zero
Date: Tue,  4 Nov 2008 12:21:35 -0800
Message-Id: <1225830096-7052-3-git-send-email-reinette.chatre@intel.com> (sfid-20081104_212124_599526_BFE5DC35)
In-Reply-To: <1225830096-7052-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1225830096-7052-1-git-send-email-reinette.chatre@intel.com>
 <1225830096-7052-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not send scan command if no channels to scan.

This avoids a Microcode error as reported in:
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1650
http://bugzilla.kernel.org/show_bug.cgi?id=11806
http://marc.info/?l=linux-wireless&m=122437145211886&w=2

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Also applies to 2.6.28.

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 88465e4..caac74c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6196,6 +6196,11 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 					      n_probes,
 			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
+	if (scan->channel_count == 0) {
+		IWL_DEBUG_SCAN("channel count %d\n", scan->channel_count);
+		goto done;
+	}
+
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl3945_scan_channel);
 	cmd.data = scan;
-- 
1.5.4.3

