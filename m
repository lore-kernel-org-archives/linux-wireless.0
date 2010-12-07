Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44453 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab0LGXNc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 18:13:32 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 15:13:18 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <amod.bodas@atheros.com>,
	<pstew@google.com>, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 3/5] ath9k: Make DMA warning in ath_stoprecv WARN_ON_ONCE.
Date: Tue, 7 Dec 2010 15:13:21 -0800
Message-ID: <1291763603-26546-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1291763603-26546-1-git-send-email-lrodriguez@atheros.com>
References: <1291763603-26546-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This decreases spammage in the log.  A single line message
will still be printed, so users can be aware that problem
exists.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/debug.h |   94 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/debug.h

diff --git a/drivers/net/wireless/ath/debug.h b/drivers/net/wireless/ath/debug.h
new file mode 100644
index 0000000..10cf682
--- /dev/null
+++ b/drivers/net/wireless/ath/debug.h
@@ -0,0 +1,94 @@
+/*
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef ATH_DEBUG_H
+#define ATH_DEBUG_H
+
+#include "ath.h"
+
+/**
+ * enum ath_debug_level - atheros wireless debug level
+ *
+ * @ATH_DBG_RESET: reset processing
+ * @ATH_DBG_QUEUE: hardware queue management
+ * @ATH_DBG_EEPROM: eeprom processing
+ * @ATH_DBG_CALIBRATE: periodic calibration
+ * @ATH_DBG_INTERRUPT: interrupt processing
+ * @ATH_DBG_REGULATORY: regulatory processing
+ * @ATH_DBG_ANI: adaptive noise immunitive processing
+ * @ATH_DBG_XMIT: basic xmit operation
+ * @ATH_DBG_BEACON: beacon handling
+ * @ATH_DBG_CONFIG: configuration of the hardware
+ * @ATH_DBG_FATAL: fatal errors, this is the default, DBG_DEFAULT
+ * @ATH_DBG_PS: power save processing
+ * @ATH_DBG_HWTIMER: hardware timer handling
+ * @ATH_DBG_BTCOEX: bluetooth coexistance
+ * @ATH_DBG_BSTUCK: stuck beacons
+ * @ATH_DBG_ANY: enable all debugging
+ *
+ * The debug level is used to control the amount and type of debugging output
+ * we want to see. Each driver has its own method for enabling debugging and
+ * modifying debug level states -- but this is typically done through a
+ * module parameter 'debug' along with a respective 'debug' debugfs file
+ * entry.
+ */
+enum ATH_DEBUG {
+	ATH_DBG_RESET		= 0x00000001,
+	ATH_DBG_QUEUE		= 0x00000002,
+	ATH_DBG_EEPROM		= 0x00000004,
+	ATH_DBG_CALIBRATE	= 0x00000008,
+	ATH_DBG_INTERRUPT	= 0x00000010,
+	ATH_DBG_REGULATORY	= 0x00000020,
+	ATH_DBG_ANI		= 0x00000040,
+	ATH_DBG_XMIT		= 0x00000080,
+	ATH_DBG_BEACON		= 0x00000100,
+	ATH_DBG_CONFIG		= 0x00000200,
+	ATH_DBG_FATAL		= 0x00000400,
+	ATH_DBG_PS		= 0x00000800,
+	ATH_DBG_HWTIMER		= 0x00001000,
+	ATH_DBG_BTCOEX		= 0x00002000,
+	ATH_DBG_WMI		= 0x00004000,
+	ATH_DBG_BSTUCK		= 0x00008000,
+	ATH_DBG_ANY		= 0xffffffff
+};
+
+#define ATH_DBG_DEFAULT (ATH_DBG_FATAL)
+
+#ifdef CONFIG_ATH_DEBUG
+void ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+#define ATH_DBG_WARN(foo, arg...) WARN(foo, arg)
+#define ATH_DBG_WARN_ON_ONCE(foo) WARN_ON_ONCE(foo)
+#else
+static inline void __attribute__ ((format (printf, 3, 4)))
+ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
+{
+}
+#define ATH_DBG_WARN(foo, arg)
+#define ATH_DBG_WARN_ON_ONCE(foo)
+#endif /* CONFIG_ATH_DEBUG */
+
+/** Returns string describing opmode, or NULL if unknown mode. */
+#ifdef CONFIG_ATH_DEBUG
+const char *ath_opmode_to_string(enum nl80211_iftype opmode);
+#else
+static inline const char *ath_opmode_to_string(enum nl80211_iftype opmode)
+{
+	return "UNKNOWN";
+}
+#endif
+
+#endif /* ATH_DEBUG_H */
-- 
1.7.3.2.90.gd4c43

