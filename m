Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:59698 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1GFP0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 11:26:49 -0400
Received: by fxd18 with SMTP id 18so194768fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 08:26:48 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: select BLOCKIO for BCMA
Date: Wed,  6 Jul 2011 18:05:14 +0200
Message-Id: <1309968314-11634-1-git-send-email-zajec5@gmail.com> (sfid-20110706_172654_806128_E720F378)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We want PIO as fallback for BCMA as well.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Kconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 0c29c74..17f9dab 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -90,6 +90,12 @@ config B43_SDIO
 
 #Data transfers to the device via PIO. We want it as a fallback even
 # if we can do DMA.
+config B43_BCMA_PIO
+	bool
+	depends on B43_BCMA
+	select BCMA_BLOCKIO
+	default y
+
 config B43_PIO
 	bool
 	depends on B43
-- 
1.7.3.4

