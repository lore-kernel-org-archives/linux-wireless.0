Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1818 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab2EGKcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:31 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 11/20] NFC: Send device index instead of its name when target is lost
Date: Mon,  7 May 2012 12:31:22 +0200
Message-Id: <1336386691-24840-12-git-send-email-sameo@linux.intel.com> (sfid-20120507_123234_999536_9A3BF6D9)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index cc89e4f..747c6b3 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -197,7 +197,7 @@ int nfc_genl_target_lost(struct nfc_dev *dev, u32 target_idx)
 	if (!hdr)
 		goto free_msg;
 
-	if (nla_put_string(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev)))
+	if (nla_put_u32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx))
 		goto nla_put_failure;
 	if (nla_put_u32(msg, NFC_ATTR_TARGET_INDEX, target_idx))
 		goto nla_put_failure;
-- 
1.7.9.1

