Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47601 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0HAWD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 18:03:28 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so1137298ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 15:03:27 -0700 (PDT)
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Subject: [PATCH 2/3] compat: header <pcmcia/cs_types.h> was removed in v2.6.36
Date: Mon,  2 Aug 2010 00:02:50 +0200
Message-Id: <1280700173-14690-3-git-send-email-kkhere.geo@gmail.com>
In-Reply-To: <4C55D22A.5040302@hauke-m.de>
References: <4C55D22A.5040302@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the header <pcmcia/cs.h> in versions < 2.6.36 requires types defined
in <pcmcia/cs_types.h> so include it first.

Signed-off-by: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
---
 include/pcmcia/cs.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)
 create mode 100644 include/pcmcia/cs.h

diff --git a/include/pcmcia/cs.h b/include/pcmcia/cs.h
new file mode 100644
index 0000000..1c5e0fa
--- /dev/null
+++ b/include/pcmcia/cs.h
@@ -0,0 +1,10 @@
+#ifndef _COMPAT_PCMCIA_CS_H
+#define _COMPAT_PCMCIA_CS_H
+#include <linux/version.h>
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)
+#include <pcmcia/cs_types.h>
+#endif
+
+#include_next <pcmcia/cs.h>
+#endif
-- 
1.7.1

