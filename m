Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49012 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2BYETi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 23:19:38 -0500
Received: by pbcup15 with SMTP id up15so170446pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 20:19:37 -0800 (PST)
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: hauke@hauke-m.de, nbd@nbd.name, linville@tuxdriver.com,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 1/4] compat: fix compilation warning for compat_firmware_class on 2.6.26
Date: Fri, 24 Feb 2012 20:19:26 -0800
Message-Id: <1330143569-30296-2-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_051941_704732_A8A2C90C)
In-Reply-To: <1330143569-30296-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330143569-30296-1-git-send-email-rodrigue@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

This fixes this compilation issue:

  CC [M]  /home/mcgrof/compat/compat/compat_firmware_class.o
/home/mcgrof/compat/compat/compat_firmware_class.c:24:0: warning: "to_dev" redefined
include/linux/input.h:1218:0: note: this is the location of the previous definition
/home/mcgrof/compat/compat/compat_firmware_class.c:24:0: warning: "to_dev" redefined
include/linux/input.h:1218:0: note: this is the location of the previous definition

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 compat/compat_firmware_class.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/compat/compat_firmware_class.c b/compat/compat_firmware_class.c
index 4eb5ba7..b085677 100644
--- a/compat/compat_firmware_class.c
+++ b/compat/compat_firmware_class.c
@@ -21,7 +21,10 @@
 #include <linux/firmware.h>
 #include <linux/slab.h>
 
+#ifdef to_dev
+#undef to_dev
 #define to_dev(obj) container_of(obj, struct device, kobj)
+#endif
 
 MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
-- 
1.7.4.15.g7811d

