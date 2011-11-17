Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42716 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab1KQAp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 19:45:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] compat: implement dummy security_sk_clone
Date: Wed, 16 Nov 2011 19:39:34 -0500
Message-Id: <1321490374-24529-2-git-send-email-linville@tuxdriver.com> (sfid-20111117_014555_923735_62BEE61E)
In-Reply-To: <1321490374-24529-1-git-send-email-linville@tuxdriver.com>
References: <1321490374-24529-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has been defined in include/linux/security.h for some time, but was
only given an EXPORT_SYMBOL for 3.2.  Add a compat_* definition to avoid
breaking the module load with an undefined symbol.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/linux/compat-3.2.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
index ceaaecc..08f102f 100644
--- a/include/linux/compat-3.2.h
+++ b/include/linux/compat-3.2.h
@@ -72,6 +72,17 @@ static inline char *hex_byte_pack(char *buf, u8 byte)
 	return buf;
 }
 
+/*
+ * This has been defined in include/linux/security.h for some time, but was
+ * only given an EXPORT_SYMBOL for 3.2.  Add a compat_* definition to avoid
+ * breaking the compile.
+ */
+#define security_sk_clone(a, b) compat_security_sk_clone(a, b)
+
+static inline void security_sk_clone(const struct sock *sk, struct sock *newsk)
+{
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)) */
 
 #endif /* LINUX_3_2_COMPAT_H */
-- 
1.7.4.4

