Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53487 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2IZRkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 13:40:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-nfc@lists.01.org,
	Randy Dunlap <rdunlap@xenotime.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] nfc: add dummy nfc_llc_shdlc_register definition
Date: Wed, 26 Sep 2012 13:39:10 -0400
Message-Id: <1348681150-29095-1-git-send-email-linville@tuxdriver.com> (sfid-20120926_194010_378470_9AEADA51)
In-Reply-To: <50631EE7.8010203@xenotime.net>
References: <50631EE7.8010203@xenotime.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

This is used when CONFIG_NFC_SHDLC is disabled.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/nfc/hci/llc.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/nfc/hci/llc.h b/net/nfc/hci/llc.h
index c7014fd..7be0b7f 100644
--- a/net/nfc/hci/llc.h
+++ b/net/nfc/hci/llc.h
@@ -56,6 +56,14 @@ int nfc_llc_register(const char *name, struct nfc_llc_ops *ops);
 void nfc_llc_unregister(const char *name);
 
 int nfc_llc_nop_register(void);
+
+#if defined(CONFIG_NFC_SHDLC)
 int nfc_llc_shdlc_register(void);
+#else
+static inline int nfc_llc_shdlc_register(void)
+{
+	return 0;
+}
+#endif
 
 #endif /* __LOCAL_LLC_H_ */
-- 
1.7.11.4

