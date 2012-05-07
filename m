Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab2EGKby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:31:54 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 01/20] NFC: Fix up for NLA_PUT_ api changes
Date: Mon,  7 May 2012 12:31:12 +0200
Message-Id: <1336386691-24840-2-git-send-email-sameo@linux.intel.com> (sfid-20120507_123157_680398_949BBB49)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stephen Rothwell <sfr@canb.auug.org.au>

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/netlink.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index ebdb605..6c558bc 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -197,8 +197,10 @@ int nfc_genl_target_lost(struct nfc_dev *dev, u32 target_idx)
 	if (!hdr)
 		goto free_msg;
 
-	NLA_PUT_STRING(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev));
-	NLA_PUT_U32(msg, NFC_ATTR_TARGET_INDEX, target_idx);
+	if (nla_put_string(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev)))
+		goto nla_put_failure;
+	if (nla_put_u32(msg, NFC_ATTR_TARGET_INDEX, target_idx))
+		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
 
-- 
1.7.9.1

