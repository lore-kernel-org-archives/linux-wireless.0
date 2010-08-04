Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61233 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab0HDOSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 10:18:55 -0400
Received: by ewy23 with SMTP id 23so1998782ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Aug 2010 07:18:54 -0700 (PDT)
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Subject: [PATCH] compat: backport pcmcia_{read,write}_config byte from v2.6.36
Date: Wed,  4 Aug 2010 16:18:35 +0200
Message-Id: <1280931516-29665-2-git-send-email-kkhere.geo@gmail.com>
In-Reply-To: <1280931516-29665-1-git-send-email-kkhere.geo@gmail.com>
References: <1280931516-29665-1-git-send-email-kkhere.geo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
---
 include/pcmcia/ds.h |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)
 create mode 100644 include/pcmcia/ds.h

diff --git a/include/pcmcia/ds.h b/include/pcmcia/ds.h
new file mode 100644
index 0000000..fc43703
--- /dev/null
+++ b/include/pcmcia/ds.h
@@ -0,0 +1,36 @@
+#ifndef _COMPAT_PCMCIA_DS_H
+#define _COMPAT_PCMCIA_DS_H
+#include <linux/version.h>
+
+#include_next <pcmcia/ds.h>
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)
+/**
+ * pcmcia_read_config_byte() - read a byte from a card configuration register
+ *
+ * pcmcia_read_config_byte() reads a byte from a configuration register in
+ * attribute memory.
+ */
+static inline int pcmcia_read_config_byte(struct pcmcia_device *p_dev, off_t where, u8 *val)
+{
+        int ret;
+        conf_reg_t reg = { 0, CS_READ, where, 0 };
+        ret = pcmcia_access_configuration_register(p_dev, &reg);
+        *val = reg.Value;
+        return ret;
+}
+
+/**
+ * pcmcia_write_config_byte() - write a byte to a card configuration register
+ *
+ * pcmcia_write_config_byte() writes a byte to a configuration register in
+ * attribute memory.
+ */
+static inline int pcmcia_write_config_byte(struct pcmcia_device *p_dev, off_t where, u8 val)
+{
+	conf_reg_t reg = { 0, CS_WRITE, where, val };
+	return pcmcia_access_configuration_register(p_dev, &reg);
+}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36) */
+
+#endif
-- 
1.7.1

