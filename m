Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55073 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753010AbdFOSZZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:25 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 08/23] adapter: Return '-errno' when connect() call fails
Date: Thu, 15 Jun 2017 11:25:01 -0700
Message-Id: <20170615182516.4508-9-mgreer@animalcreek.com> (sfid-20170615_202646_128008_CF3F33B4)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

near_adapter_connect() incorrectly returns '-1' when the connect()
call fails.  Instead, it should return '-errno' which is the real
error code.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/adapter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/adapter.c b/src/adapter.c
index bfc64c2..466753b 100644
--- a/src/adapter.c
+++ b/src/adapter.c
@@ -1054,7 +1054,7 @@ int near_adapter_connect(uint32_t idx, uint32_t target_idx, uint8_t protocol)
 	err = connect(sock, (struct sockaddr *) &addr, sizeof(addr));
 	if (err) {
 		close(sock);
-		return err;
+		return -errno;
 	}
 
 	adapter->tag_sock = sock;
-- 
2.13.0
