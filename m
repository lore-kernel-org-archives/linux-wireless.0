Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39235 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753139AbdFOSZl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:41 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 18/23] nfctype5: Remove useless initialization
Date: Thu, 15 Jun 2017 11:25:11 -0700
Message-Id: <20170615182516.4508-19-mgreer@animalcreek.com> (sfid-20170615_202545_516779_9A89DC7F)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no point in assigning 'local_data' to 'cookie' when 'cookie'
is going to be reassigned before it is used.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 plugins/nfctype5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/plugins/nfctype5.c b/plugins/nfctype5.c
index f26d8fa..873ac79 100644
--- a/plugins/nfctype5.c
+++ b/plugins/nfctype5.c
@@ -430,7 +430,7 @@ static int t5_read(struct near_tag *tag, uint8_t offset, uint8_t *buf,
 		size_t len, t5_local_cb local_cb, void *local_data)
 {
 	struct type5_read_single_block_cmd t5_cmd;
-	struct t5_cookie *cookie = local_data;
+	struct t5_cookie *cookie;
 	uint8_t blk_size = near_tag_get_blk_size(tag);
 	int err;
 
@@ -529,7 +529,7 @@ static int t5_write(struct near_tag *tag, uint8_t offset, uint8_t *buf,
 		size_t len, t5_local_cb local_cb, void *local_data)
 {
 	struct type5_write_single_block_cmd *t5_cmd;
-	struct t5_cookie *cookie = local_data;
+	struct t5_cookie *cookie;
 	uint8_t blk_size = near_tag_get_blk_size(tag);
 	int err;
 
-- 
2.13.0
