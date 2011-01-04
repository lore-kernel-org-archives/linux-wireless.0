Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:43006 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1ADXsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:48:32 -0500
Subject: [RFC PATCH 05/17] zd1211rw: move set_rts_cts_work to bss_info_changed
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:48:28 +0200
Message-ID: <20110104234828.25309.21518.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As bss_info_changed may sleep, we can as well set RTS_CTS register right away.
Keep mac->short_preamble for later use (hw reset).

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   27 +++++----------------------
 drivers/net/wireless/zd1211rw/zd_mac.h |    3 ---
 2 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index ca3b4e1..9284643 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -994,20 +994,9 @@ static void zd_op_configure_filter(struct ieee80211_hw *hw,
 	 * time. */
 }
 
-static void set_rts_cts_work(struct work_struct *work)
+static void set_rts_cts(struct zd_mac *mac, unsigned int short_preamble)
 {
-	struct zd_mac *mac =
-		container_of(work, struct zd_mac, set_rts_cts_work);
-	unsigned long flags;
-	unsigned int short_preamble;
-
 	mutex_lock(&mac->chip.mutex);
-
-	spin_lock_irqsave(&mac->lock, flags);
-	mac->updating_rts_rate = 0;
-	short_preamble = mac->short_preamble;
-	spin_unlock_irqrestore(&mac->lock, flags);
-
 	zd_chip_set_rts_cts_rate_locked(&mac->chip, short_preamble);
 	mutex_unlock(&mac->chip.mutex);
 }
@@ -1018,7 +1007,6 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 				   u32 changes)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
-	unsigned long flags;
 	int associated;
 
 	dev_dbg_f(zd_mac_dev(mac), "changes: %x\n", changes);
@@ -1056,15 +1044,11 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 	/* TODO: do hardware bssid filtering */
 
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
-		spin_lock_irqsave(&mac->lock, flags);
+		spin_lock_irq(&mac->lock);
 		mac->short_preamble = bss_conf->use_short_preamble;
-		if (!mac->updating_rts_rate) {
-			mac->updating_rts_rate = 1;
-			/* FIXME: should disable TX here, until work has
-			 * completed and RTS_CTS reg is updated */
-			queue_work(zd_workqueue, &mac->set_rts_cts_work);
-		}
-		spin_unlock_irqrestore(&mac->lock, flags);
+		spin_unlock_irq(&mac->lock);
+
+		set_rts_cts(mac, bss_conf->use_short_preamble);
 	}
 }
 
@@ -1138,7 +1122,6 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 
 	zd_chip_init(&mac->chip, hw, intf);
 	housekeeping_init(mac);
-	INIT_WORK(&mac->set_rts_cts_work, set_rts_cts_work);
 	INIT_WORK(&mac->process_intr, zd_process_intr);
 
 	SET_IEEE80211_DEV(hw, &intf->dev);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index f28ecb9..ff7ef30 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -189,9 +189,6 @@ struct zd_mac {
 	/* Short preamble (used for RTS/CTS) */
 	unsigned int short_preamble:1;
 
-	/* flags to indicate update in progress */
-	unsigned int updating_rts_rate:1;
-
 	/* whether to pass frames with CRC errors to stack */
 	unsigned int pass_failed_fcs:1;
 

