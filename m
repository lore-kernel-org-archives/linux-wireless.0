Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab1C2JYo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 05:24:44 -0400
Date: Tue, 29 Mar 2011 11:24:21 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwl3945: disable hw scan by default
Message-ID: <20110329092421.GA5919@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After new NetworkManager 0.8.996 changes, hardware scanning is causing
microcode errors as reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=683571
and sometimes kernel crashes:
https://bugzilla.redhat.com/show_bug.cgi?id=688252

Also with hw scan there are very bad performance on some systems
as reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=671366 

Since Intel no longer supports 3945, there is no chance to get proper
firmware fixes, we need workaround problems by disable hardware scanning
by default.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
This patch should be also applied on .38-stable (on older
kernels software scan have performance problems), but need
manual backport due to driver split. I will post to stable
when it gets mainline.

John, please post upstream ASAP, together with commit
c24057cbcd7480602ece65be3f7e039499499007 "iwl3945: do not deprecate
software scan"

 drivers/net/wireless/iwlegacy/iwl3945-base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index b6c5209..28eb3d8 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -93,6 +93,7 @@ MODULE_LICENSE("GPL");
 struct iwl_mod_params iwl3945_mod_params = {
 	.sw_crypto = 1,
 	.restart_fw = 1,
+	.disable_hw_scan = 1,
 	/* the rest are 0 by default */
 };
 
@@ -4279,7 +4280,7 @@ MODULE_PARM_DESC(swcrypto,
 		"using software crypto (default 1 [software])");
 module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan,
 		int, S_IRUGO);
-MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
+MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 1)");
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 module_param_named(debug, iwlegacy_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
-- 
1.7.1

