Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29962 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab1CKC4Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:56:02 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 10/20] ath6kl: remove-typedef AR6K_GMBOX_CTRL_REGISTERS
Date: Thu, 10 Mar 2011 18:55:37 -0800
Message-ID: <1299812147-12069-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s AR6K_GMBOX_CTRL_REGISTERS \
	"struct ar6k_gmbox_ctrl_registers" drivers/staging/ath6k

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index ebcc82b..e8b638c 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -65,9 +65,9 @@ typedef PREPACK struct _AR6K_IRQ_ENABLE_REGISTERS {
     u8 counter_int_status_enable;
 } POSTPACK AR6K_IRQ_ENABLE_REGISTERS;
 
-typedef PREPACK struct _AR6K_GMBOX_CTRL_REGISTERS {
+PREPACK struct ar6k_gmbox_ctrl_registers {
     u8 int_status_enable;
-} POSTPACK AR6K_GMBOX_CTRL_REGISTERS;
+} POSTPACK;
 
 #include "athendpack.h"
 
@@ -139,7 +139,7 @@ struct ar6k_device {
     int                             MaxSendBundleSize;
     AR6K_GMBOX_INFO                 GMboxInfo;
     bool                          GMboxEnabled;
-    AR6K_GMBOX_CTRL_REGISTERS       GMboxControlRegisters;
+    struct ar6k_gmbox_ctrl_registers       GMboxControlRegisters;
     int                             RecheckIRQStatusCnt;
 };
 
-- 
1.7.4.15.g7811d

