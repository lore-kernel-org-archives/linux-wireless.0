Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36641 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbZHFRA0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 13:00:26 -0400
Subject: [PATCH] libertas: correct packing of rxpd structure
From: Dan Williams <dcbw@redhat.com>
To: John Linville <linville@tuxdriver.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Bob Dunlop <rdunlop@guralp.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 12:01:03 -0400
Message-Id: <1249574463.2916.25.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Dunlop <rdunlop@guralp.com>

Older Gcc compilers (3.4.5 tested) need additional hints in order to get
the packing of the rxpd structure (which contains a 16 bit union)
correct on the ARM processor.

struct txpd does not need these hints since it contains a 32 bit union
that packs naturally.

Signed-off-by: R.J.Dunlop <rdunlop@guralp.com>
Acked-by: Dan Williams <dcbw@redhat.com>

---

diff -u linux-2.6.31-rc2/drivers/net/wireless/libertas/hostcmd.h{-orig,}
--- linux-2.6.31-rc2/drivers/net/wireless/libertas/hostcmd.h-orig	2009-07-04 18:58:48.000000000 +0100
+++ linux-2.6.31-rc2/drivers/net/wireless/libertas/hostcmd.h	2009-07-13 08:27:45.000000000 +0100
@@ -56,8 +56,8 @@
 			u8 bss_type;
 			/* BSS number */
 			u8 bss_num;
-		} bss;
-	} u;
+		} __attribute__ ((packed)) bss;
+	} __attribute__ ((packed)) u;
 
 	/* SNR */
 	u8 snr;



