Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34322 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1KQWWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:22:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 2/4] compat-wireless: remove leading whitespace from CONFIG_COMPAT_FIRMWARE_CLASS
Date: Thu, 17 Nov 2011 17:21:09 -0500
Message-Id: <1321568471-23068-2-git-send-email-linville@tuxdriver.com> (sfid-20111117_232241_514414_2887F417)
In-Reply-To: <1321568471-23068-1-git-send-email-linville@tuxdriver.com>
References: <1321568471-23068-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_COMPAT_FIRMWARE_CLASS is being checked in compat-2.6.33.h, so it
needs to show-up in compat_autoconf.h.  Remove the leading whitespace,
so that gen-compat-autoconf.sh will treat it accordingly.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 config.mk |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 1bb2799..7116206 100644
--- a/config.mk
+++ b/config.mk
@@ -114,9 +114,13 @@ else
 endif
 endif #CONFIG_COMPAT_KERNEL_2_6_27
 
+#
+# CONFIG_COMPAT_FIRMWARE_CLASS definition has no leading whitespace,
+# because it gets passed-on through compat_autoconf.h.
+#
 ifdef CONFIG_COMPAT_KERNEL_2_6_33
 ifdef CONFIG_FW_LOADER
- CONFIG_COMPAT_FIRMWARE_CLASS=m
+CONFIG_COMPAT_FIRMWARE_CLASS=m
 endif #CONFIG_FW_LOADER
 endif #CONFIG_COMPAT_KERNEL_2_6_33
 
-- 
1.7.4.4

