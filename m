Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63989 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab2CDX5Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:57:25 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 02/22] NFC: Add device powered netlink attribute
Date: Mon,  5 Mar 2012 01:03:34 +0100
Message-Id: <1330905834-6994-3-git-send-email-sameo@linux.intel.com> (sfid-20120305_005728_300585_D0053AE3)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For user space to know if a device is up or down.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/nfc.h |    1 +
 net/nfc/netlink.c   |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index b4999ab..39c1fcf 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -107,6 +107,7 @@ enum nfc_attrs {
 	NFC_ATTR_TARGET_SENSF_RES,
 	NFC_ATTR_COMM_MODE,
 	NFC_ATTR_RF_MODE,
+	NFC_ATTR_DEVICE_POWERED,
 /* private: internal use only */
 	__NFC_ATTR_AFTER_LAST
 };
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 07f0348..a1388e4 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -48,6 +48,7 @@ static const struct nla_policy nfc_genl_policy[NFC_ATTR_MAX + 1] = {
 	[NFC_ATTR_PROTOCOLS] = { .type = NLA_U32 },
 	[NFC_ATTR_COMM_MODE] = { .type = NLA_U8 },
 	[NFC_ATTR_RF_MODE] = { .type = NLA_U8 },
+	[NFC_ATTR_DEVICE_POWERED] = { .type = NLA_U8 },
 };
 
 static int nfc_genl_send_target(struct sk_buff *msg, struct nfc_target *target,
@@ -200,6 +201,7 @@ int nfc_genl_device_added(struct nfc_dev *dev)
 	NLA_PUT_STRING(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev));
 	NLA_PUT_U32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx);
 	NLA_PUT_U32(msg, NFC_ATTR_PROTOCOLS, dev->supported_protocols);
+	NLA_PUT_U8(msg, NFC_ATTR_DEVICE_POWERED, dev->dev_up);
 
 	genlmsg_end(msg, hdr);
 
@@ -261,6 +263,7 @@ static int nfc_genl_send_device(struct sk_buff *msg, struct nfc_dev *dev,
 	NLA_PUT_STRING(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev));
 	NLA_PUT_U32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx);
 	NLA_PUT_U32(msg, NFC_ATTR_PROTOCOLS, dev->supported_protocols);
+	NLA_PUT_U8(msg, NFC_ATTR_DEVICE_POWERED, dev->dev_up);
 
 	return genlmsg_end(msg, hdr);
 
-- 
1.7.7.3

