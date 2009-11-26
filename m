Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:27780 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760643AbZKZPJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 10:09:29 -0500
Subject: [PATCH 04/12] wl1251: reduce ELP wakeup timeout
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 17:08:51 +0200
Message-ID: <20091126150850.917.96234.stgit@tikku>
In-Reply-To: <20091126150141.917.35278.stgit@tikku>
References: <20091126150141.917.35278.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The original TI driver uses 100 ms timeout ELP wakeup timeout, better
to use the same. Otherwise problems with wakeup might get unnoticed.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_ps.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.c b/drivers/net/wireless/wl12xx/wl1251_ps.c
index 9931b19..54a2720 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.c
@@ -26,7 +26,8 @@
 #include "wl1251_cmd.h"
 #include "wl1251_io.h"
 
-#define WL1251_WAKEUP_TIMEOUT 2000
+/* in ms */
+#define WL1251_WAKEUP_TIMEOUT 100
 
 void wl1251_elp_work(struct work_struct *work)
 {

