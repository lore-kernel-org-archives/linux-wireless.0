Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6426 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab1F2WBM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 18:01:12 -0400
Subject: [PATCH] compat: define irq_set_probe() and irq_set_noprobe() only
 on Linux 2.6.25+
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 29 Jun 2011 18:01:10 -0400
Message-ID: <20110629220110.15622.34326.stgit@mj.roinet.com> (sfid-20110630_000115_009050_875439E8)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>

set_irq_probe() and set_irq_probe() are missing on Linux 2.6.24, so the
code won't compile.  compat-wireless doesn't need those functions.  Keep
the functions for Linux 2.6.25 and newer for other compat packages.
---
 include/linux/compat-2.6.39.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.39.h b/include/linux/compat-2.6.39.h
index b4d85fd..406f8eb 100644
--- a/include/linux/compat-2.6.39.h
+++ b/include/linux/compat-2.6.39.h
@@ -64,6 +64,8 @@ static inline struct msi_desc *irq_get_msi_desc(unsigned int irq)
 {
 	return get_irq_msi(irq);
 }
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
 static inline void irq_set_noprobe(unsigned int irq)
 {
 	set_irq_noprobe(irq);
@@ -72,6 +74,7 @@ static inline void irq_set_probe(unsigned int irq)
 {
 	set_irq_probe(irq);
 }
+#endif
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
 static inline struct irq_chip *irq_desc_get_chip(struct irq_desc *desc)
