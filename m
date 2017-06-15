Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52645 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753188AbdFOSZa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:30 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 07/23] adapter: Return '-errno' when socket() call fails
Date: Thu, 15 Jun 2017 11:25:00 -0700
Message-Id: <20170615182516.4508-8-mgreer@animalcreek.com> (sfid-20170615_202604_436769_87384E61)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

near_adapter_connect() incorrectly returns '-1' when the socket()
call fails.  Instead, it should return '-errno' which is the real
error code.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/adapter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/adapter.c b/src/adapter.c
index bc29ace..bfc64c2 100644
--- a/src/adapter.c
+++ b/src/adapter.c
@@ -1044,7 +1044,7 @@ int near_adapter_connect(uint32_t idx, uint32_t target_idx, uint8_t protocol)
 
 	sock = socket(AF_NFC, SOCK_SEQPACKET, NFC_SOCKPROTO_RAW);
 	if (sock == -1)
-		return sock;
+		return -errno;
 
 	addr.sa_family = AF_NFC;
 	addr.dev_idx = idx;
-- 
2.13.0
