Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50475 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab2AXUQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 15:16:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: use bool type for no_hw_rfkill_switch module parameter
Date: Tue, 24 Jan 2012 15:01:32 -0500
Message-Id: <1327435292-25050-1-git-send-email-linville@tuxdriver.com> (sfid-20120124_211621_342898_29BFB8CC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoids this:

  CC [M]  drivers/net/wireless/ath/ath5k/base.o
drivers/net/wireless/ath/ath5k/base.c: In function ‘__check_no_hw_rfkill_switch’:
drivers/net/wireless/ath/ath5k/base.c:85:1: warning: return from incompatible pointer type

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4ab835f..a339693 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -80,7 +80,7 @@ static bool modparam_fastchanswitch;
 module_param_named(fastchanswitch, modparam_fastchanswitch, bool, S_IRUGO);
 MODULE_PARM_DESC(fastchanswitch, "Enable fast channel switching for AR2413/AR5413 radios.");
 
-static int ath5k_modparam_no_hw_rfkill_switch;
+static bool ath5k_modparam_no_hw_rfkill_switch;
 module_param_named(no_hw_rfkill_switch, ath5k_modparam_no_hw_rfkill_switch,
 								bool, S_IRUGO);
 MODULE_PARM_DESC(no_hw_rfkill_switch, "Ignore the GPIO RFKill switch state");
-- 
1.7.4.4

