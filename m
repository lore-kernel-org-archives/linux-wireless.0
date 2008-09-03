Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbYICDbH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Cahill Ben <ben.m.cahill@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/39] iwlwifi: fix hidden ssid discovery in passive channels
Date: Wed,  3 Sep 2008 11:26:29 +0800
Message-Id: <1220412419-15404-10-git-send-email-yi.zhu@intel.com> (sfid-20080903_053114_736432_0AD248E3)
In-Reply-To: <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
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

