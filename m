Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932490Ab2CGTGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:32 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 14/35] iwlwifi: dump stack when fail to gain access to the device
Date: Wed,  7 Mar 2012 09:52:23 -0800
Message-Id: <1331142764-5750-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200726_739126_BA6AC26F)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

Print dump stack when the device is not responding. This should give
some more clue about the reason of failure. Also change the message we
print, since "MAC in deep sleep" is kinda confusing.

On the way add unlikely(), as fail to gain NIC access is hmm ...
unlikely.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index e2e3b5c..fc36535 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -121,10 +121,10 @@ int iwl_grab_nic_access_silent(struct iwl_trans *trans)
 int iwl_grab_nic_access(struct iwl_trans *trans)
 {
 	int ret = iwl_grab_nic_access_silent(trans);
-	if (ret) {
+	if (unlikely(ret)) {
 		u32 val = iwl_read32(trans, CSR_GP_CNTRL);
-		IWL_ERR(trans,
-			"MAC is in deep sleep!. CSR_GP_CNTRL = 0x%08X\n", val);
+		WARN_ONCE(1, "Timeout waiting for hardware access "
+			     "(CSR_GP_CNTRL 0x%08x)\n", val);
 	}
 
 	return ret;
-- 
1.7.0.4

