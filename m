Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926Ab0JWQFY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 12:05:24 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6] iwlwifi: quiet a noisy printk
Date: Sat, 23 Oct 2010 09:02:50 -0700
Message-Id: <1287849770-14477-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Timing issues in microcode for some devices can cause a compressed BA to
be sent to the driver prior to returning any a-MPDU notification.
Traces show RTS-CTS is exchanged and then the timer fires which causes an
empty BA to be sent which acknowledges nothing.  This results in a noisy
printk. Only print the message if the bitmap is non-zero.

Signed-off-by:  Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 69155aa..369b210 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1203,7 +1203,8 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	struct ieee80211_tx_info *info;
 
 	if (unlikely(!agg->wait_for_ba))  {
-		IWL_ERR(priv, "Received BA when not expected\n");
+		if (unlikely(ba_resp->bitmap))
+			IWL_ERR(priv, "Received BA when not expected\n");
 		return -EINVAL;
 	}
 
-- 
1.7.0.4

