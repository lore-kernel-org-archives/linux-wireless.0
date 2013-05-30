Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16673 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966914Ab3E3ICB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 04:02:01 -0400
Date: Thu, 30 May 2013 11:01:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
	"moderated list:NFC SUBSYSTEM" <linux-nfc@ml01.01.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] NFC: mei_phy: use kfree_skb() instead of kfree()
Message-ID: <20130530080141.GC8148@debian> (sfid-20130530_100207_256764_E3C263FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was allocated with alloc_skb() so it needs to be freed with
kfree_skb().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 1201bdbf..5fbaca4 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -127,7 +127,7 @@ void nfc_mei_event_cb(struct mei_cl_device *device, u32 events, void *context)
 
 		reply_size = mei_cl_recv(device, skb->data, MEI_NFC_MAX_READ);
 		if (reply_size < MEI_NFC_HEADER_SIZE) {
-			kfree(skb);
+			kfree_skb(skb);
 			return;
 		}
 
