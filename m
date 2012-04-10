Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab2DJRfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:35:09 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 02/18] NFC: Add a target lost netlink event
Date: Tue, 10 Apr 2012 19:43:04 +0200
Message-Id: <1334079800-10671-3-git-send-email-sameo@linux.intel.com> (sfid-20120410_193513_021781_32245113)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some chips are capable of detecting when a tag is out of the field, so
they could send a netlink event about it to userspace.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/nfc.h |    1 +
 net/nfc/netlink.c   |   30 ++++++++++++++++++++++++++++++
 net/nfc/nfc.h       |    1 +
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index 39c1fcf..0ae9b58 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -70,6 +70,7 @@ enum nfc_commands {
 	NFC_EVENT_TARGETS_FOUND,
 	NFC_EVENT_DEVICE_ADDED,
 	NFC_EVENT_DEVICE_REMOVED,
+	NFC_EVENT_TARGET_LOST,
 /* private: internal use only */
 	__NFC_CMD_AFTER_LAST
 };
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 6404052..ebdb605 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -183,6 +183,36 @@ free_msg:
 	return -EMSGSIZE;
 }
 
+int nfc_genl_target_lost(struct nfc_dev *dev, u32 target_idx)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
+			  NFC_EVENT_TARGET_LOST);
+	if (!hdr)
+		goto free_msg;
+
+	NLA_PUT_STRING(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev));
+	NLA_PUT_U32(msg, NFC_ATTR_TARGET_INDEX, target_idx);
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast(msg, 0, nfc_genl_event_mcgrp.id, GFP_KERNEL);
+
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return -EMSGSIZE;
+}
+
 int nfc_genl_device_added(struct nfc_dev *dev)
 {
 	struct sk_buff *msg;
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index ec8794c..2c868d2 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -119,6 +119,7 @@ void nfc_genl_data_init(struct nfc_genl_data *genl_data);
 void nfc_genl_data_exit(struct nfc_genl_data *genl_data);
 
 int nfc_genl_targets_found(struct nfc_dev *dev);
+int nfc_genl_target_lost(struct nfc_dev *dev, u32 target_idx);
 
 int nfc_genl_device_added(struct nfc_dev *dev);
 int nfc_genl_device_removed(struct nfc_dev *dev);
-- 
1.7.9.1

