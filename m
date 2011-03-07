Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab1CGIXA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 03:23:00 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlwifi: fix iwl-rx.c compilation
Date: Mon,  7 Mar 2011 09:22:24 +0100
Message-Id: <1299486144-8985-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My commit 466a19a003f3b45a755bc85f967c21da947f9a00 "iwlwifi: move rx
handlers code to iwl-rx.c" breaks compilation on 32 bits. Fix that.

Reported-by: Guy, Wey-Yi <wey-yi.w.guy@intel.com>
Reported-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 7dc2d39..6f9a2fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -29,6 +29,7 @@
 
 #include <linux/etherdevice.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
 #include "iwl-eeprom.h"
-- 
1.7.1

