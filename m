Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab2BWKQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 05:16:15 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/6] iwlwifi: dump stack when fail to gain access to the device
Date: Thu, 23 Feb 2012 11:16:03 +0100
Message-Id: <1329992168-19990-1-git-send-email-sgruszka@redhat.com> (sfid-20120223_111618_201870_E3D91EA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print dump stack when the device is not responding. This should give
some more clue about the reason of failure. Also change the message we
print, since "MAC in deep sleep" is kinda confusing.

On the way add unlikely(), as fail to gain NIC access is hmm ...
unlikely.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index e2e3b5c..71015a3 100644
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
+		WARN_ONCE(1, "Timeout waiting for ucode processor access "
+			     "(CSR_GP_CNTRL 0x%08x)\n", val);
 	}
 
 	return ret;
-- 
1.7.1

