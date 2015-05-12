Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35110 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808AbbELVyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 17:54:06 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, jlee@suse.com, tiwai@suse.de,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>
Subject: [PATCH v3 1/4] firmware: fix __getname() missing failure check
Date: Tue, 12 May 2015 14:49:40 -0700
Message-Id: <1431467383-28540-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20150512_235427_026662_35290FB4)
In-Reply-To: <1431467383-28540-1-git-send-email-mcgrof@do-not-panic.com>
References: <1431467383-28540-1-git-send-email-mcgrof@do-not-panic.com>
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
index 171841a..49139a1 100644
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
+	if (!path)
+		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
 		struct file *file;
-- 
2.3.2.209.gd67f9d5.dirty

