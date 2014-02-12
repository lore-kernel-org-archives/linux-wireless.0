Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:44517 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaBLLCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 06:02:20 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [net-next 2/3] UAPI: add MPLS label stack definition
Date: Wed, 12 Feb 2014 11:53:05 +0100
Message-Id: <1392202386-8826-3-git-send-email-sw@simonwunderlich.de> (sfid-20140212_120228_721009_29A33989)
In-Reply-To: <1392202386-8826-1-git-send-email-sw@simonwunderlich.de>
References: <1392202386-8826-1-git-send-email-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Labels for the Multiprotocol Label Switching are defined in RFC 3032
which was superseded by RFC 5462. Add the definition to UAPI.

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/uapi/linux/mpls.h |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 include/uapi/linux/mpls.h

diff --git a/include/uapi/linux/mpls.h b/include/uapi/linux/mpls.h
new file mode 100644
index 0000000..15c8260
--- /dev/null
+++ b/include/uapi/linux/mpls.h
@@ -0,0 +1,34 @@
+#ifndef _UAPI_MPLS_H
+#define _UAPI_MPLS_H
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+/* Reference: RFC 5462, RFC 3032
+ *
+ *  0                   1                   2                   3
+ *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |                Label                  | TC  |S|       TTL     |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ *	Label:  Label Value, 20 bits
+ *	TC:     Traffic Class field, 3 bits
+ *	S:      Bottom of Stack, 1 bit
+ *	TTL:    Time to Live, 8 bits
+ */
+
+struct mpls_label_stack {
+	__be32 entry;
+};
+
+#define MPLS_LS_LABEL_MASK      0xFFFFF000
+#define MPLS_LS_LABEL_SHIFT     12
+#define MPLS_LS_TC_MASK         0x00000E00
+#define MPLS_LS_TC_SHIFT        9
+#define MPLS_LS_S_MASK          0x00000100
+#define MPLS_LS_S_SHIFT         8
+#define MPLS_LS_TTL_MASK        0x000000FF
+#define MPLS_LS_TTL_SHIFT       0
+
+#endif /* _UAPI_MPLS_H */
-- 
1.7.10.4

