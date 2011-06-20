Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:42279 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1FTLmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 07:42:55 -0400
Subject: [PATCH 6/6] zd1211rw: detect stalled beacon interrupt faster
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 20 Jun 2011 14:42:54 +0300
Message-ID: <20110620114254.964.92160.stgit@localhost6.localdomain6> (sfid-20110620_134259_065489_84D570EE)
In-Reply-To: <20110620114228.964.35459.stgit@localhost6.localdomain6>
References: <20110620114228.964.35459.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As USB_INT_ID_RETRY_FAILED can override USB_INT_ID_REGS, beacon interrupt
(CR_INTERRUPT) might be lost. Problem is that when device trigger CR_INTERRUPT
it disables HW interrupt. Now if USB_INT_ID_REGS with CR_INTERRUPT gets lost,
beacon interrupt stays disabled until beacon watchdog notices the stall. This
happen very often on heavy TX. Improve watchdog to trigger earlier, after three
missing beacon interrupts.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index b67c52d..cabfae1 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1429,7 +1429,8 @@ static void beacon_watchdog_handler(struct work_struct *work)
 	spin_lock_irq(&mac->lock);
 	interval = mac->beacon.interval;
 	period = mac->beacon.period;
-	timeout = mac->beacon.last_update + msecs_to_jiffies(interval) + HZ;
+	timeout = mac->beacon.last_update +
+			msecs_to_jiffies(interval * 1024 / 1000) * 3;
 	spin_unlock_irq(&mac->lock);
 
 	if (interval > 0 && time_is_before_jiffies(timeout)) {

