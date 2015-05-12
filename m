Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34331 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933572AbbELShe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 14:37:34 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: dhowells@redhat.com, seth.forshee@canonical.com,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>
Subject: [PATCH v2 2/5] firmware: check for file truncation on direct firmware loading
Date: Tue, 12 May 2015 11:30:54 -0700
Message-Id: <1431455457-25322-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20150512_203809_432322_F1F3E192)
In-Reply-To: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com>
References: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

When direct firmware loading is used we iterate over a list
of possible firmware paths and concatenate the desired firmware
name with each path and look for the file there. Should the
passed firmware name be too long we end up truncating the
file we want to look for, the search however is still done.
Add a check for truncation instead of looking for a
truncated firmware filename.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Kyle McMartin <kyle@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/base/firmware_class.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index bc6c8e6..99385fc 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -320,7 +320,7 @@ fail:
 static int fw_get_filesystem_firmware(struct device *device,
 				       struct firmware_buf *buf)
 {
-	int i;
+	int i, len;
 	int rc = -ENOENT;
 	char *path;
 
@@ -335,7 +335,12 @@ static int fw_get_filesystem_firmware(struct device *device,
 		if (!fw_path[i][0])
 			continue;
 
-		snprintf(path, PATH_MAX, "%s/%s", fw_path[i], buf->fw_id);
+		len = snprintf(path, PATH_MAX, "%s/%s",
+			       fw_path[i], buf->fw_id);
+		if (len >= PATH_MAX) {
+			rc = -ENAMETOOLONG;
+			break;
+		}
 
 		file = filp_open(path, O_RDONLY, 0);
 		if (IS_ERR(file))
-- 
2.3.2.209.gd67f9d5.dirty

