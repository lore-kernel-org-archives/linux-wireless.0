Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47990 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934122Ab2DLWsO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 18:48:14 -0400
From: mjr@cs.wisc.edu
To: j@w1.fi, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Matt Renzelmann <mjr@cs.wisc.edu>
Subject: [PATCH] hostap: GFP_ATOMIC/GFP_KERNEL cleanup
Date: Thu, 12 Apr 2012 17:42:43 -0500
Message-Id: <1334270563-10855-1-git-send-email-mjr@cs.wisc.edu> (sfid-20120413_004817_191716_4EA2163D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matt Renzelmann <mjr@cs.wisc.edu>

The driver is allocating memory during initialization with GFP_ATOMIC
even though GFP_KERNEL is sufficient.  This patch fixes it.

Signed-off-by: Matt Renzelmann <mjr@cs.wisc.edu>
---
 drivers/net/wireless/hostap/hostap_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wireless/hostap/hostap_main.c
index bfa0d54..627bc12 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -244,8 +244,7 @@ u16 hostap_tx_callback_register(local_info_t *local,
 	unsigned long flags;
 	struct hostap_tx_callback_info *entry;
 
-	entry = kmalloc(sizeof(*entry),
-							   GFP_ATOMIC);
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (entry == NULL)
 		return 0;
 
-- 
1.7.5.4

