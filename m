Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:57826 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbbJ0JZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:25:12 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 02/27] staging: wilc1000: isr_bh_routine: use wilc instead of g_linux_wlan
Date: Tue, 27 Oct 2015 18:27:38 +0900
Message-ID: <1445938083-20445-2-git-send-email-glen.lee@atmel.com> (sfid-20151027_102516_280044_078FADF4)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use netdev private data member wilc instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 324cc57..7d0d722 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -248,8 +248,14 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 
 irqreturn_t isr_bh_routine(int irq, void *userdata)
 {
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
+
+	nic = netdev_priv(userdata);
+	wilc = nic->wilc;
+
 	/*While mac is closing cacncel the handling of any interrupts received*/
-	if (g_linux_wlan->close) {
+	if (wilc->close) {
 		PRINT_ER("Driver is CLOSING: Can't handle BH interrupt\n");
 		return IRQ_HANDLED;
 	}
-- 
1.9.1

