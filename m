Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49459 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750981AbdFPD5b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 23:57:31 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 3/4] tag: Add Tag deactivate support
Date: Thu, 15 Jun 2017 20:57:27 -0700
Message-Id: <20170616035728.19415-4-mgreer@animalcreek.com> (sfid-20170616_055744_543001_A4A83BE7)
In-Reply-To: <20170616035728.19415-1-mgreer@animalcreek.com>
References: <20170616035728.19415-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once a tag has been discovered, it remains active until it
is moved out of range, or an error occurs while reading or
writing it.  While the tag is active, the adapter cannot
be powered off.  This wastes power when the client application
no longer cares whether the tag is in range or not.

To address this issue, add the ability for a client application
to deactivate an active tag.  Once deactivated, the client
application can poll the tag again to read it or power off the
adapter.

The 'NFC_CMD_DEACTIVATE_TARGET' netlink command is added to
request that the kernel deactivate the target (tag).

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 doc/tag-api.txt    |  8 ++++++++
 include/nfc_copy.h |  2 ++
 src/near.h         |  1 +
 src/netlink.c      | 33 +++++++++++++++++++++++++++++++++
 src/tag.c          | 29 +++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+)

diff --git a/doc/tag-api.txt b/doc/tag-api.txt
index b388b22..4ed24da 100644
--- a/doc/tag-api.txt
+++ b/doc/tag-api.txt
@@ -25,6 +25,14 @@ Method		void Write(dict attributes)
 					 org.neard.Error.InvalidArguments
 					 org.neard.Error.InProgress
 
+Method		void Deactivate()
+
+			Deactivates a tag.
+
+			Possible Errors: org.neard.Error.PermissionDenied
+					 org.neard.Error.OutOfMemory
+					 org.neard.Error.InvalidArguments
+					 org.neard.Error.NotSupported
 
 Properties	string Type [readonly]
 
diff --git a/include/nfc_copy.h b/include/nfc_copy.h
index 399f39f..f6e3c8c 100644
--- a/include/nfc_copy.h
+++ b/include/nfc_copy.h
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
diff --git a/src/near.h b/src/near.h
index 50a4c8b..e7f7fa7 100644
--- a/src/near.h
+++ b/src/near.h
@@ -166,6 +166,7 @@ int __near_netlink_start_poll(int idx,
 int __near_netlink_stop_poll(int idx);
 int __near_netlink_activate_target(uint32_t idx, uint32_t target_idx,
                                    uint32_t protocol);
+int __near_netlink_deactivate_target(uint32_t idx, uint32_t target_idx);
 int __near_netlink_dep_link_up(uint32_t idx, uint32_t target_idx,
 				uint8_t comm_mode, uint8_t rf_mode);
 int __near_netlink_dep_link_down(uint32_t idx);
diff --git a/src/netlink.c b/src/netlink.c
index d02d62f..3c77999 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -329,6 +329,39 @@ nla_put_failure:
 	return err;
 }
 
+int __near_netlink_deactivate_target(uint32_t idx, uint32_t target_idx)
+{
+	struct nl_msg *msg;
+	void *hdr;
+	int err;
+
+	DBG("");
+
+	msg = nlmsg_alloc();
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, NL_AUTO_PID, NL_AUTO_SEQ, nfc_state->nfc_id, 0,
+			NLM_F_REQUEST, NFC_CMD_DEACTIVATE_TARGET,
+			NFC_GENL_VERSION);
+	if (!hdr) {
+		err = -EINVAL;
+		goto nla_put_failure;
+	}
+
+	err = -EMSGSIZE;
+
+	NLA_PUT_U32(msg, NFC_ATTR_DEVICE_INDEX, idx);
+	NLA_PUT_U32(msg, NFC_ATTR_TARGET_INDEX, target_idx);
+
+	err = nl_send_msg(nfc_state->cmd_sock, msg, NULL, NULL);
+
+nla_put_failure:
+	nlmsg_free(msg);
+
+	return err;
+}
+
 int __near_netlink_dep_link_up(uint32_t idx, uint32_t target_idx,
 				uint8_t comm_mode, uint8_t rf_mode)
 {
diff --git a/src/tag.c b/src/tag.c
index 01015a1..9eba4ee 100644
--- a/src/tag.c
+++ b/src/tag.c
@@ -486,9 +486,38 @@ fail:
 	return __near_error_failed(msg, ENOMEM);
 }
 
+static DBusMessage *deactivate_tag(DBusConnection *conn,
+				   DBusMessage *msg, void *data)
+{
+	struct near_tag *tag = data;
+	struct near_adapter *adapter;
+	int err;
+
+	DBG("deactivating tag %p", conn);
+
+	adapter = __near_adapter_get(tag->adapter_idx);
+	if (!adapter)
+		return __near_error_failed(msg, EINVAL);
+
+	__near_adapter_stop_check_presence(tag->adapter_idx, tag->target_idx);
+
+	err = __near_netlink_deactivate_target(tag->adapter_idx,
+					       tag->target_idx);
+	if (err < 0)
+		return __near_error_failed(msg, -err);
+
+	near_adapter_disconnect(tag->adapter_idx);
+
+	if (__near_adapter_is_constant_poll(adapter))
+		__near_adapter_start_poll(adapter);
+
+	return g_dbus_create_reply(msg, DBUS_TYPE_INVALID);
+}
+
 static const GDBusMethodTable tag_methods[] = {
 	{ GDBUS_ASYNC_METHOD("Write", GDBUS_ARGS({"attributes", "a{sv}"}),
 							NULL, write_ndef) },
+	{ GDBUS_METHOD("Deactivate", NULL, NULL, deactivate_tag) },
 	{ },
 };
 
-- 
2.13.0
