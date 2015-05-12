Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35188 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924AbbELSfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 14:35:24 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: dhowells@redhat.com, seth.forshee@canonical.com,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>
Subject: [PATCH v2 1/5] firmware: fix __getname() missing failure check
Date: Tue, 12 May 2015 11:30:53 -0700
Message-Id: <1431455457-25322-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20150512_203528_623948_32C45BD2)
In-Reply-To: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com>
References: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The request_firmware*() APIs uses __getname() to iterate
over the list of paths possible for firmware to be found,
the code however never checked for failure on __getname().
Although *very unlikely*, this can still happen. Add the
missing check.

There is still no checks on the concatenation of the path
and filename passed, that requires a bit more work and
subsequent patches address this. The commit that introduced
this is abb139e7 ("firmware: teach the kernel to load
firmware files directly from the filesystem").

mcgrof@ergon ~/linux (git::firmware-fixes) $ git describe --contains abb139e7
v3.7-rc1~120

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Kyle McMartin <kyle@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/base/firmware_class.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 171841a..bc6c8e6 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -322,7 +322,11 @@ static int fw_get_filesystem_firmware(struct device *device,
 {
 	int i;
 	int rc = -ENOENT;
-	char *path = __getname();
+	char *path;
+
+	path = __getname();
+	if (unlikely(!path))
+		return PTR_ERR(path);
 
 	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
 		struct file *file;
-- 
2.3.2.209.gd67f9d5.dirty

