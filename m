Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32820 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbESAts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 20:49:48 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com
Cc: rusty@rustcorp.com.au, torvalds@linux-foundation.org,
	dhowells@redhat.com, seth.forshee@canonical.com,
	linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	jlee@suse.com, tiwai@suse.de, casey@schaufler-ca.com,
	keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <David.Woodhouse@intel.com>
Subject: [RFC v3 1/2] firmware: generalize reading file contents as a helper
Date: Mon, 18 May 2015 17:45:24 -0700
Message-Id: <1431996325-8840-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20150519_024952_964658_78B64363)
In-Reply-To: <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com>
References: <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We'll want to reuse this same code later in order to
read two separate types of file contents. Although we
can simplify fw_read_file_contents() to do a direct
return we leave a bit of boilerplate code to make the
next changes easier to review. In this case we'll
later extend the firmware specific read to also go
and fetch the signature file when required.

This commit introduces no functional changes.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Kyle McMartin <kyle@kernel.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/base/firmware_class.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8c3aa3c..134dd77 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -291,7 +291,8 @@ static const char * const fw_path[] = {
 module_param_string(path, fw_path_para, sizeof(fw_path_para), 0644);
 MODULE_PARM_DESC(path, "customized firmware image search path with a higher priority than default path");
 
-static int fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
+static int __read_file_contents(struct file *file,
+				void **dest_buf, size_t *dest_size)
 {
 	int size;
 	char *buf;
@@ -314,14 +315,30 @@ static int fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
 	rc = security_kernel_fw_from_file(file, buf, size);
 	if (rc)
 		goto fail;
-	fw_buf->data = buf;
-	fw_buf->size = size;
+
+	*dest_buf = buf;
+	*dest_size = size;
+
 	return 0;
 fail:
 	vfree(buf);
 	return rc;
 }
 
+static int fw_read_file_contents(struct file *file,
+				 struct firmware_buf *fw_buf)
+{
+	int rc;
+
+	rc = __read_file_contents(file,
+				  &fw_buf->data,
+				  &fw_buf->size);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
 static int fw_get_filesystem_firmware(struct device *device,
 				       struct firmware_buf *buf)
 {
-- 
2.3.2.209.gd67f9d5.dirty

