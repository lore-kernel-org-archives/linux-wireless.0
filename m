Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35228 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbbEFA7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 20:59:47 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1 06/12] firmware: generalize "firmware" as "system data" helpers
Date: Tue,  5 May 2015 17:44:24 -0700
Message-Id: <1430873070-7290-7-git-send-email-mcgrof@do-not-panic.com> (sfid-20150506_030031_573252_DDD779C0)
In-Reply-To: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Historically firmware_class code was added to help
get device driver firmware binaries but these days
request_firmware*() helpers are being repurposed for
general system data needed by the kernel.

Annotate this before we extend firmare_class more,
as this is expected. We want to generalize the code
as much as possible.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Kyle McMartin <kyle@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/base/firmware_class.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 65fcf2d..55091b4 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -346,7 +346,7 @@ static int fw_get_filesystem_firmware(struct device *device,
 		rc = fw_read_file_contents(file, buf);
 		fput(file);
 		if (rc)
-			dev_warn(device, "firmware, attempted to load %s, but failed with error %d\n",
+			dev_warn(device, "system data, attempted to load %s, but failed with error %d\n",
 				path, rc);
 		else
 			break;
@@ -354,7 +354,7 @@ static int fw_get_filesystem_firmware(struct device *device,
 	__putname(path);
 
 	if (!rc) {
-		dev_dbg(device, "firmware: direct-loading firmware %s\n",
+		dev_dbg(device, "system data: direct-loading firmware %s\n",
 			buf->fw_id);
 		mutex_lock(&fw_lock);
 		set_bit(FW_STATUS_DONE, &buf->status);
@@ -1063,7 +1063,7 @@ _request_firmware_prepare(struct firmware **firmware_p, const char *name,
 	}
 
 	if (fw_get_builtin_firmware(firmware, name)) {
-		dev_dbg(device, "firmware: using built-in firmware %s\n", name);
+		dev_dbg(device, "system data: using built-in system data%s\n", name);
 		return 0; /* assigned */
 	}
 
-- 
2.3.2.209.gd67f9d5.dirty

