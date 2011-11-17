Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34320 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1KQWWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:22:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 3/4] compat: check CONFIG_COMPAT_FIRMWARE_CLASS in compat-2.6.33.h
Date: Thu, 17 Nov 2011 17:20:41 -0500
Message-Id: <1321568442-22758-3-git-send-email-linville@tuxdriver.com> (sfid-20111117_232220_343834_20C286F0)
In-Reply-To: <1321568442-22758-1-git-send-email-linville@tuxdriver.com>
References: <1321568442-22758-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a pre-2.6.33 kernel has backported suitable firmware loader
functionality, then it doesn't need the compat_firmware_class.  In that
case, compat-2.6.33 should not redefine the *_firmware function names.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/linux/compat-2.6.33.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 539b469..e9e888a 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -14,9 +14,11 @@
 #endif
 #include <linux/firmware.h>
 
+#if defined(CONFIG_COMPAT_FIRMWARE_CLASS)
 #define release_firmware compat_release_firmware
 #define request_firmware compat_request_firmware
 #define request_firmware_nowait compat_request_firmware_nowait
+#endif
 
 #if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
 int compat_request_firmware(const struct firmware **fw, const char *name,
-- 
1.7.4.4

