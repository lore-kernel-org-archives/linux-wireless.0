Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59082 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1GXTWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jul 2011 15:22:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlagn: wrap suspend/resume definitions in CONFIG_PM block
Date: Sun, 24 Jul 2011 15:19:10 -0400
Message-Id: <1311535150-28686-1-git-send-email-linville@tuxdriver.com> (sfid-20110724_212256_823964_73F31E57)
In-Reply-To: <20110724.030949.1727841105144911931.davem@davemloft.net>
References: <20110724.030949.1727841105144911931.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/iwlwifi/iwl-agn.c:3464: error: unknown field 'suspend' specified in initializer
drivers/net/wireless/iwlwifi/iwl-agn.c:3464: warning: initialization from incompatible pointer type
drivers/net/wireless/iwlwifi/iwl-agn.c:3465: error: unknown field 'resume' specified in initializer
drivers/net/wireless/iwlwifi/iwl-agn.c:3465: warning: initialization from incompatible pointer type

This was caused by commit c8ac61cf ("iwlagn: implement WoWLAN").

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4b666b7..ff3e6c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3461,8 +3461,10 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
 	.stop = iwlagn_mac_stop,
+#ifdef CONFIG_PM
 	.suspend = iwlagn_mac_suspend,
 	.resume = iwlagn_mac_resume,
+#endif /* CONFIG_PM */
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
 	.change_interface = iwl_mac_change_interface,
-- 
1.7.4.4

