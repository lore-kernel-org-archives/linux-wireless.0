Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36852 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab2CDRng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 12:43:36 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>, stable@kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.3] iwlwifi: fix wowlan suspend
Date: Sun,  4 Mar 2012 08:31:35 -0800
Message-Id: <1330878695-22159-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_184340_788149_270900BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This was broken by the commit 023ca58f1
"iwlwifi: Move the core suspend function to iwl-agn-lib"
where for some reason the code changed while moving,
from
	.len[0] = sizeof(*key_data.rsc_tsc),
to
	.len[0] = sizeof(key_data.rsc_tsc),

Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch will be also available from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 64cf439..ca78e91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1240,7 +1240,7 @@ int iwlagn_suspend(struct iwl_priv *priv,
 				.flags = CMD_SYNC,
 				.data[0] = key_data.rsc_tsc,
 				.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
-				.len[0] = sizeof(key_data.rsc_tsc),
+				.len[0] = sizeof(*key_data.rsc_tsc),
 			};
 
 			ret = iwl_trans_send_cmd(trans(priv), &rsc_tsc_cmd);
-- 
1.7.0.4

