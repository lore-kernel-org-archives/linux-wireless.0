Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37061 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750792AbdFPDkx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 23:40:53 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 2/2] NFC: Add NFC_CMD_DEACTIVATE_TARGET support
Date: Thu, 15 Jun 2017 20:34:22 -0700
Message-Id: <20170616033422.18484-3-mgreer@animalcreek.com> (sfid-20170616_054104_184170_B15D7841)
In-Reply-To: <20170616033422.18484-1-mgreer@animalcreek.com>
References: <20170616033422.18484-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once an NFC target (i.e., a tag) is found, it remains active until
there is a failure reading or writing it (often caused by the target
moving out of range).  While the target is active, the NFC adapter
and antenna must remain powered.  This wastes power when the target
remains in range but the client application no longer cares whether
it is there or not.

To mitigate this, add a new netlink command that allows userspace
to deactivate an active target.  When issued, this command will cause
the NFC subsystem to act as though the target was moved out of range.
Once the command has been executed, the client application can power
off the NFC adapter to reduce power consumption.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---

I'm not really sure what the correct argument for the mode parameter
of digital_activate_target() is.  I do not have any NCI controllers
to test with.
---
 include/uapi/linux/nfc.h |  2 ++
 net/nfc/netlink.c        | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/uapi/linux/nfc.h b/include/uapi/linux/nfc.h
index 399f39ff8048..f6e3c8c9c744 100644
--- a/include/uapi/linux/nfc.h
+++ b/include/uapi/linux/nfc.h
@@ -89,6 +89,7 @@
  * @NFC_CMD_ACTIVATE_TARGET: Request NFC controller to reactivate target.
  * @NFC_CMD_VENDOR: Vendor specific command, to be implemented directly
  *	from the driver in order to support hardware specific operations.
+ * @NFC_CMD_DEACTIVATE_TARGET: Request NFC controller to deactivate target.
  */
 enum nfc_commands {
 	NFC_CMD_UNSPEC,
@@ -121,6 +122,7 @@ enum nfc_commands {
 	NFC_CMD_SE_IO,
 	NFC_CMD_ACTIVATE_TARGET,
 	NFC_CMD_VENDOR,
+	NFC_CMD_DEACTIVATE_TARGET,
 /* private: internal use only */
 	__NFC_CMD_AFTER_LAST
 };
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 6b0850e63e09..43a27e43ef12 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -926,6 +926,30 @@ static int nfc_genl_activate_target(struct sk_buff *skb, struct genl_info *info)
 	return rc;
 }
 
+static int nfc_genl_deactivate_target(struct sk_buff *skb,
+				      struct genl_info *info)
+{
+	struct nfc_dev *dev;
+	u32 device_idx, target_idx;
+	int rc;
+
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
+		return -EINVAL;
+
+	device_idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
+
+	dev = nfc_get_device(device_idx);
+	if (!dev)
+		return -ENODEV;
+
+	target_idx = nla_get_u32(info->attrs[NFC_ATTR_TARGET_INDEX]);
+
+	rc = nfc_deactivate_target(dev, target_idx, NFC_TARGET_MODE_SLEEP);
+
+	nfc_put_device(dev);
+	return rc;
+}
+
 static int nfc_genl_dep_link_up(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nfc_dev *dev;
@@ -1749,6 +1773,11 @@ static const struct genl_ops nfc_genl_ops[] = {
 		.doit = nfc_genl_vendor_cmd,
 		.policy = nfc_genl_policy,
 	},
+	{
+		.cmd = NFC_CMD_DEACTIVATE_TARGET,
+		.doit = nfc_genl_deactivate_target,
+		.policy = nfc_genl_policy,
+	},
 };
 
 static struct genl_family nfc_genl_family __ro_after_init = {
-- 
2.13.0
