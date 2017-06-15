Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58985 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753154AbdFOSZa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:30 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 09/23] adapter: Clear timeout handle when check presence timer stopped
Date: Thu, 15 Jun 2017 11:25:02 -0700
Message-Id: <20170615182516.4508-10-mgreer@animalcreek.com> (sfid-20170615_202637_778331_83AA4C59)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

__near_adapter_stop_check_presence() stops the neard check presence
timer but doesn't clear the timer handle.  This can cause neard to
try to stop the timer when it isn't running.  To fix that, clear the
handle so neard doesn't try to stop an already stopped timer.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/adapter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/adapter.c b/src/adapter.c
index 466753b..7be87e2 100644
--- a/src/adapter.c
+++ b/src/adapter.c
@@ -505,8 +505,10 @@ void __near_adapter_stop_check_presence(uint32_t adapter_idx,
 	if (!adapter)
 		return;
 
-	if (adapter->presence_timeout > 0)
+	if (adapter->presence_timeout > 0) {
 		g_source_remove(adapter->presence_timeout);
+		adapter->presence_timeout = 0;
+	}
 }
 
 static const GDBusMethodTable adapter_methods[] = {
-- 
2.13.0
