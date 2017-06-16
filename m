Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60931 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751667AbdFPD5b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 23:57:31 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 2/4] adapter: Add call indicating whether constant poll is enabled
Date: Thu, 15 Jun 2017 20:57:26 -0700
Message-Id: <20170616035728.19415-3-mgreer@animalcreek.com> (sfid-20170616_055745_658754_74DA5389)
In-Reply-To: <20170616035728.19415-1-mgreer@animalcreek.com>
References: <20170616035728.19415-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a routine that returns a boolean indicating whether the adapter
constant poll option is enabled or not.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/adapter.c | 5 +++++
 src/near.h    | 1 +
 2 files changed, 6 insertions(+)

diff --git a/src/adapter.c b/src/adapter.c
index e8c7c61..9c483ca 100644
--- a/src/adapter.c
+++ b/src/adapter.c
@@ -578,6 +578,11 @@ void __near_adapter_destroy(struct near_adapter *adapter)
 	free_adapter(adapter);
 }
 
+bool __near_adapter_is_constant_poll(struct near_adapter *adapter)
+{
+	return adapter->constant_poll;
+}
+
 const char *__near_adapter_get_path(struct near_adapter *adapter)
 {
 	return adapter->path;
diff --git a/src/near.h b/src/near.h
index 7795e61..50a4c8b 100644
--- a/src/near.h
+++ b/src/near.h
@@ -78,6 +78,7 @@ void __near_manager_cleanup(void);
 struct near_adapter *__near_adapter_create(uint32_t idx,
 		const char *name, uint32_t protocols, bool powered);
 void __near_adapter_destroy(struct near_adapter *adapter);
+bool __near_adapter_is_constant_poll(struct near_adapter *adapter);
 const char *__near_adapter_get_path(struct near_adapter *adapter);
 struct near_adapter *__near_adapter_get(uint32_t idx);
 int __near_adapter_add(struct near_adapter *adapter);
-- 
2.13.0
