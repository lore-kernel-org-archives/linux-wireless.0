Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40987 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753181AbdFOSZa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:30 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 10/23] adapter: Clear timer handle when DEP timer stopped
Date: Thu, 15 Jun 2017 11:25:03 -0700
Message-Id: <20170615182516.4508-11-mgreer@animalcreek.com> (sfid-20170615_202637_237795_7F3E26D6)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

__near_adapter_set_dep_state() stops the neard DEP timer but
doesn't clear the timer handle.  This can cause neard to try
to stop the timer when it isn't running.  To fix that, clear
the handle so neard doesn't try to stop an already stopped timer.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/adapter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/adapter.c b/src/adapter.c
index 7be87e2..eb1a407 100644
--- a/src/adapter.c
+++ b/src/adapter.c
@@ -615,8 +615,10 @@ int __near_adapter_set_dep_state(uint32_t idx, bool dep)
 		target_idx =  __neard_device_get_idx(adapter->device_link);
 		__near_adapter_remove_target(idx, target_idx);
 	} else {
-		if (adapter->dep_timer > 0)
+		if (adapter->dep_timer > 0) {
 			g_source_remove(adapter->dep_timer);
+			adapter->dep_timer = 0;
+		}
 
 		if (!__near_device_register_interface(adapter->device_link))
 			return -ENODEV;
-- 
2.13.0
