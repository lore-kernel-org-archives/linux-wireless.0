Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25507 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbYHOCFB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 22:05:01 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Cahill Ben <ben.m.cahill@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 13/15] iwlwifi: fix hidden ssid discovery in passive channels
Date: Fri, 15 Aug 2008 10:01:18 +0800
Message-Id: <1218765680-8378-14-git-send-email-yi.zhu@intel.com> (sfid-20080815_040507_200992_84995308)
In-Reply-To: <1218765680-8378-13-git-send-email-yi.zhu@intel.com>
References: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-2-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-3-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-4-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-5-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-6-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-7-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-8-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-9-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-10-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-11-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-12-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-13-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch gives the HW the possibility to send direct probes in passive
channels (as long as traffic was detected in that channel) if such ssid
was requested, so hidden ssid can be found now in those channels as well.

Signed-off-by: Cahill Ben <ben.m.cahill@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 9bb6adb..6c8ac3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -421,7 +421,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		else
 			scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
 
-		if ((scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) && n_probes)
+		if (n_probes)
 			scan_ch->type |= IWL_SCAN_PROBE_MASK(n_probes);
 
 		scan_ch->active_dwell = cpu_to_le16(active_dwell);
-- 
1.5.3.6

