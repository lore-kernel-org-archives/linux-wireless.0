Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:60984 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753AbaFQJlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 05:41:06 -0400
Subject: [PATCH 3/6] ath6kl: don't set hi_refclk_hz if hardware version
 doesn't need it
To: ath6kl@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Jun 2014 12:41:04 +0300
Message-ID: <20140617094104.22040.98561.stgit@potku.adurom.net> (sfid-20140617_114109_981283_9855B7A0)
In-Reply-To: <20140617093836.22040.99081.stgit@potku.adurom.net>
References: <20140617093836.22040.99081.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed for ar6004 hw3.0 support.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index c2ec36ab8121..3eb4508331e3 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -624,9 +624,12 @@ int ath6kl_configure_target(struct ath6kl *ar)
 		return status;
 
 	/* Configure target refclk_hz */
-	status = ath6kl_bmi_write_hi32(ar, hi_refclk_hz, ar->hw.refclk_hz);
-	if (status)
-		return status;
+	if (ar->hw.refclk_hz != 0) {
+		status = ath6kl_bmi_write_hi32(ar, hi_refclk_hz,
+					       ar->hw.refclk_hz);
+		if (status)
+			return status;
+	}
 
 	return 0;
 }

