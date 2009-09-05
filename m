Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49115 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751226AbZIEOHo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 10:07:44 -0400
Message-ID: <4AA270AF.2010902@gmx.de>
Date: Sat, 05 Sep 2009 16:07:43 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath,ar9170: move CTL_ defines into regd.h
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ar9170 driver needs the defines for conformance test limit groups
and cannot include regd_common.h

Signed-off-by: Joerg Albert <jal2@gmx.de>
---
 drivers/net/wireless/ath/regd.h        |    6 ++++++
 drivers/net/wireless/ath/regd_common.h |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 4d3c536..c1dd857 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -22,6 +22,12 @@
 
 #include "ath.h"
 
+enum ctl_group {
+	CTL_FCC = 0x10,
+	CTL_MKK = 0x40,
+	CTL_ETSI = 0x30,
+};
+
 #define NO_CTL 0xff
 #define SD_NO_CTL               0xE0
 #define NO_CTL                  0xff
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index ad6d938..9847af7 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -154,12 +154,6 @@ enum EnumRd {
 	DEBUG_REG_DMN = 0x01ff,
 };
 
-enum ctl_group {
-	CTL_FCC = 0x10,
-	CTL_MKK = 0x40,
-	CTL_ETSI = 0x30,
-};
-
 /* Regpair to CTL band mapping */
 static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	/* regpair, 5 GHz CTL, 2 GHz CTL */
-- 
1.6.0.4

