Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:38467 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1AaSrc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:47:32 -0500
Subject: [PATCH 03/22] zd1211rw: add locking for mac->process_intr
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:47:27 +0200
Message-ID: <20110131184727.10044.58568.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    6 +++++-
 drivers/net/wireless/zd1211rw/zd_usb.c |    2 ++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 6107304..8b3d779 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -911,9 +911,13 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
 static void zd_process_intr(struct work_struct *work)
 {
 	u16 int_status;
+	unsigned long flags;
 	struct zd_mac *mac = container_of(work, struct zd_mac, process_intr);
 
-	int_status = le16_to_cpu(*(__le16 *)(mac->intr_buffer+4));
+	spin_lock_irqsave(&mac->lock, flags);
+	int_status = le16_to_cpu(*(__le16 *)(mac->intr_buffer + 4));
+	spin_unlock_irqrestore(&mac->lock, flags);
+
 	if (int_status & INT_CFG_NEXT_BCN)
 		dev_dbg_f_limit(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
 	else
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index c32a247..9493ab8 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -377,8 +377,10 @@ static inline void handle_regs_int(struct urb *urb)
 	int_num = le16_to_cpu(*(__le16 *)(urb->transfer_buffer+2));
 	if (int_num == CR_INTERRUPT) {
 		struct zd_mac *mac = zd_hw_mac(zd_usb_to_hw(urb->context));
+		spin_lock(&mac->lock);
 		memcpy(&mac->intr_buffer, urb->transfer_buffer,
 				USB_MAX_EP_INT_BUFFER);
+		spin_unlock(&mac->lock);
 		schedule_work(&mac->process_intr);
 	} else if (intr->read_regs_enabled) {
 		intr->read_regs.length = len = urb->actual_length;

