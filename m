Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab2BFQJc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 11:09:32 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 1/4] iwlwifi: dump stack when fail to gain access to the device
Date: Mon,  6 Feb 2012 17:09:21 +0100
Message-Id: <1328544564-8696-1-git-send-email-sgruszka@redhat.com> (sfid-20120206_170935_330207_3F73DF0A)
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
index 83fdff3..ce6d9c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -120,10 +120,10 @@ int iwl_grab_nic_access_silent(struct iwl_bus *bus)
 int iwl_grab_nic_access(struct iwl_bus *bus)
 {
 	int ret = iwl_grab_nic_access_silent(bus);
-	if (ret) {
+	if (unlikely(ret)) {
 		u32 val = iwl_read32(bus, CSR_GP_CNTRL);
-		IWL_ERR(bus,
-			"MAC is in deep sleep!. CSR_GP_CNTRL = 0x%08X\n", val);
+		WARN_ONCE(1, "Timeout waiting for ucode processor access "
+			     "(CSR_GP_CNTRL 0x%08x)\n", val);
 	}
 
 	return ret;
-- 
1.7.1

