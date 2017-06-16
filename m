Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44555 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751641AbdFPD5b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 23:57:31 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 1/4] adapter: Make adapter_start_poll() global
Date: Thu, 15 Jun 2017 20:57:25 -0700
Message-Id: <20170616035728.19415-2-mgreer@animalcreek.com> (sfid-20170616_055746_213807_4FF9421A)
In-Reply-To: <20170616035728.19415-1-mgreer@animalcreek.com>
References: <20170616035728.19415-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An upcoming commit will need to call adapter_start_poll() from the
tag code so make it global.  To be consistent with the names of
other global routines in adapter.c, add the '__near_' prefix.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/adapter.c | 22 +++++++++++-----------
 src/near.h    |  1 +
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/src/adapter.c b/src/adapter.c
index 9e3e75e..e8c7c61 100644
--- a/src/adapter.c
+++ b/src/adapter.c
@@ -152,7 +152,7 @@ static void rf_mode_changed(struct near_adapter *adapter)
 					NFC_ADAPTER_INTERFACE, "Mode");
 }
 
-static int adapter_start_poll(struct near_adapter *adapter)
+int __near_adapter_start_poll(struct near_adapter *adapter)
 {
 	int err;
 	uint32_t im_protos, tm_protos;
@@ -375,7 +375,7 @@ static DBusMessage *start_poll_loop(DBusConnection *conn,
 	else
 		adapter->poll_mode = NEAR_ADAPTER_MODE_INITIATOR;
 
-	err = adapter_start_poll(adapter);
+	err = __near_adapter_start_poll(adapter);
 	if (err < 0)
 		return __near_error_failed(msg, -err);
 
@@ -433,7 +433,7 @@ static gboolean check_presence(gpointer user_data)
 out_err:
 	near_adapter_disconnect(adapter->idx);
 	if (adapter->constant_poll)
-		adapter_start_poll(adapter);
+		__near_adapter_start_poll(adapter);
 
 	return FALSE;
 }
@@ -447,7 +447,7 @@ static gboolean dep_timer(gpointer user_data)
 	if (!adapter)
 		return FALSE;
 
-	adapter_start_poll(adapter);
+	__near_adapter_start_poll(adapter);
 
 	return FALSE;
 }
@@ -469,7 +469,7 @@ static void tag_present_cb(uint32_t adapter_idx, uint32_t target_idx,
 
 		near_adapter_disconnect(adapter->idx);
 		if (adapter->constant_poll)
-			adapter_start_poll(adapter);
+			__near_adapter_start_poll(adapter);
 
 		return;
 	}
@@ -606,7 +606,7 @@ int __near_adapter_set_dep_state(uint32_t idx, bool dep)
 		 * that very moment. In this case we need to try polling later
 		 * again, so constant polling will work properly.
 		 */
-		if(adapter_start_poll(adapter) == -EBUSY) {
+		if(__near_adapter_start_poll(adapter) == -EBUSY) {
 			near_error("Adapter is busy, retry polling later");
 			g_timeout_add_seconds(1, dep_timer, adapter);
 		}
@@ -688,7 +688,7 @@ static void tag_read_cb(uint32_t adapter_idx, uint32_t target_idx, int status)
 	if (status < 0) {
 		near_adapter_disconnect(adapter->idx);
 		if (adapter->constant_poll)
-			adapter_start_poll(adapter);
+			__near_adapter_start_poll(adapter);
 
 		return;
 	}
@@ -717,7 +717,7 @@ static void device_read_cb(uint32_t adapter_idx, uint32_t target_idx,
 		}
 
 		if (adapter->constant_poll)
-			adapter_start_poll(adapter);
+			__near_adapter_start_poll(adapter);
 
 		return;
 	}
@@ -838,7 +838,7 @@ int __near_adapter_add_target(uint32_t idx, uint32_t target_idx,
 					iso15693_uid_len, iso15693_uid);
 
 	if (ret < 0 && adapter->constant_poll)
-		adapter_start_poll(adapter);
+		__near_adapter_start_poll(adapter);
 
 	return ret;
 }
@@ -879,7 +879,7 @@ static gboolean poll_error(gpointer user_data)
 		 __near_netlink_adapter_enable(adapter->idx, true);
 	}
 
-	adapter_start_poll(adapter);
+	__near_adapter_start_poll(adapter);
 
 	return FALSE;
 }
@@ -954,7 +954,7 @@ int __near_adapter_remove_device(uint32_t idx)
 	adapter->dep_up = false;
 
 	if (adapter->constant_poll)
-		adapter_start_poll(adapter);
+		__near_adapter_start_poll(adapter);
 
 	return 0;
 }
diff --git a/src/near.h b/src/near.h
index 1ac6191..7795e61 100644
--- a/src/near.h
+++ b/src/near.h
@@ -94,6 +94,7 @@ int __near_adapter_remove_device(uint32_t idx);
 int __near_adapter_set_dep_state(uint32_t idx, bool dep);
 bool __near_adapter_get_dep_state(uint32_t idx);
 void __near_adapter_listen(struct near_device_driver *driver);
+int __near_adapter_start_poll(struct near_adapter *adapter);
 void __near_adapter_start_check_presence(uint32_t adapter_idx, uint32_t target_idx);
 void __near_adapter_stop_check_presence(uint32_t adapter_idx, uint32_t target_idx);
 int __near_adapter_init(void);
-- 
2.13.0
