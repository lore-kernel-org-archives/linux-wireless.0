Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:51255 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760241Ab2FVNbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 09:31:00 -0400
Received: by qabj40 with SMTP id j40so496934qab.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 06:31:00 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat-wireless: Naturally sort patch prefixes
Date: Fri, 22 Jun 2012 16:30:54 +0300
Message-Id: <1340371854-24101-1-git-send-email-ozancag@gmail.com> (sfid-20120622_153105_244158_E9E6D8C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ls -v to get a naturally sorted list of patches like:

patches/00-vga_switcheroo_client_ops.patch
patches/01-dma_buf_ops-addition.patch
patches/02-revert-vm_mmap.patch
patches/98-pr_fmt.patch
patches/99-change-makefile.patch
patches/9999-FIXME-dont-build-i915-for-i2c-problems.patch

instead of:

patches/00-vga_switcheroo_client_ops.patch
patches/01-dma_buf_ops-addition.patch
patches/02-revert-vm_mmap.patch
patches/98-pr_fmt.patch
patches/9999-FIXME-dont-build-i915-for-i2c-problems.patch
patches/99-change-makefile.patch

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index ec87f98..01c254f 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -581,7 +581,7 @@ for dir in $EXTRA_PATCHES; do
 	if [ $FOUND -eq 0 ]; then
 		continue
 	fi
-	for i in $dir/*.patch; do
+	for i in $(ls -v $dir/*.patch); do
 		echo -e "${GREEN}Applying backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
 		patch -p1 -N -t < $i
 		RET=$?
-- 
1.7.10.2

