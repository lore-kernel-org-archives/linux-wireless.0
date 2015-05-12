Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33954 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbbELWAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 18:00:39 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, jlee@suse.com, tiwai@suse.de,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>
Subject: [PATCH v3 4/4] firmware: use const for remaining firmware names
Date: Tue, 12 May 2015 14:49:43 -0700
Message-Id: <1431467383-28540-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20150513_000043_550938_B1434D61)
In-Reply-To: <1431467383-28540-1-git-send-email-mcgrof@do-not-panic.com>
References: <1431467383-28540-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We currently use flexible arrays with a char at the
end for the remaining internal firmware name uses.
There are two limitations with the way we use this.
Since we're using a flexible array for a string on the
struct if we wanted to use two strings it means we'd
have a disjoint means of handling the strings, one
using the flexible array, and another a char * pointer.
We're also currently not using 'const' for the string.

We wish to later extend some firmware data structures
with other string/char pointers, but we also want to be
very pedantic about const usage. Since we're going to
change things to use 'const' we might as well also address
unified way to use multiple strings on the structs.

Replace the flexible array practice for strings with
kstrdup_const() and kfree_const(), this will avoid
allocations when the vmlinux .rodata is used, and just
allocate a new proper string for us when needed. This
also means we can simplify the struct allocations by
removing the string length from the allocation size
computation, which would otherwise get even more
complicated when supporting multiple strings.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Kyle McMartin <kyle@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/base/firmware_class.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 62e4611..8c3aa3c 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -150,17 +150,17 @@ struct firmware_buf {
 	int page_array_size;
 	struct list_head pending_list;
 #endif
-	char fw_id[];
+	const char *fw_id;
 };
 
 struct fw_cache_entry {
 	struct list_head list;
-	char name[];
+	const char *name;
 };
 
 struct fw_name_devm {
 	unsigned long magic;
-	char name[];
+	const char *name;
 };
 
 #define to_fwbuf(d) container_of(d, struct firmware_buf, ref)
@@ -181,13 +181,17 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
 {
 	struct firmware_buf *buf;
 
-	buf = kzalloc(sizeof(*buf) + strlen(fw_name) + 1, GFP_ATOMIC);
-
+	buf = kzalloc(sizeof(*buf), GFP_ATOMIC);
 	if (!buf)
-		return buf;
+		return NULL;
+
+	buf->fw_id = kstrdup_const(fw_name, GFP_ATOMIC);
+	if (!buf->fw_id) {
+		kfree(buf);
+		return NULL;
+	}
 
 	kref_init(&buf->ref);
-	strcpy(buf->fw_id, fw_name);
 	buf->fwc = fwc;
 	init_completion(&buf->completion);
 #ifdef CONFIG_FW_LOADER_USER_HELPER
@@ -257,6 +261,7 @@ static void __fw_free_buf(struct kref *ref)
 	} else
 #endif
 		vfree(buf->data);
+	kfree_const(buf->fw_id);
 	kfree(buf);
 }
 
@@ -401,6 +406,7 @@ static void fw_name_devm_release(struct device *dev, void *res)
 	if (fwn->magic == (unsigned long)&fw_cache)
 		pr_debug("%s: fw_name-%s devm-%p released\n",
 				__func__, fwn->name, res);
+	kfree_const(fwn->name);
 }
 
 static int fw_devm_match(struct device *dev, void *res,
@@ -431,13 +437,17 @@ static int fw_add_devm_name(struct device *dev, const char *name)
 	if (fwn)
 		return 1;
 
-	fwn = devres_alloc(fw_name_devm_release, sizeof(struct fw_name_devm) +
-			   strlen(name) + 1, GFP_KERNEL);
+	fwn = devres_alloc(fw_name_devm_release, sizeof(struct fw_name_devm),
+			   GFP_KERNEL);
 	if (!fwn)
 		return -ENOMEM;
+	fwn->name = kstrdup_const(name, GFP_KERNEL);
+	if (!fwn->name) {
+		kfree(fwn);
+		return -ENOMEM;
+	}
 
 	fwn->magic = (unsigned long)&fw_cache;
-	strcpy(fwn->name, name);
 	devres_add(dev, fwn);
 
 	return 0;
@@ -1397,11 +1407,16 @@ static struct fw_cache_entry *alloc_fw_cache_entry(const char *name)
 {
 	struct fw_cache_entry *fce;
 
-	fce = kzalloc(sizeof(*fce) + strlen(name) + 1, GFP_ATOMIC);
+	fce = kzalloc(sizeof(*fce), GFP_ATOMIC);
 	if (!fce)
 		goto exit;
 
-	strcpy(fce->name, name);
+	fce->name = kstrdup_const(name, GFP_ATOMIC);
+	if (!fce->name) {
+		kfree(fce);
+		fce = NULL;
+		goto exit;
+	}
 exit:
 	return fce;
 }
@@ -1441,6 +1456,7 @@ found:
 
 static void free_fw_cache_entry(struct fw_cache_entry *fce)
 {
+	kfree_const(fce->name);
 	kfree(fce);
 }
 
-- 
2.3.2.209.gd67f9d5.dirty

