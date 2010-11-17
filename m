Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55753 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935444Ab0KQT44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 14:56:56 -0500
Received: by wwa36 with SMTP id 36so2414647wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 11:56:55 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] b43: rfkill: use HI enabled bit for all devices
Date: Wed, 17 Nov 2010 20:56:48 +0100
Message-Id: <1290023808-26672-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Devices which use LO enabled bit are covered by b43legacy

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Is this alright to use inline for this? Is my WARN_ON OK?
---
 drivers/net/wireless/b43/main.c   |    2 ++
 drivers/net/wireless/b43/rfkill.c |   21 +++------------------
 drivers/net/wireless/b43/rfkill.h |    4 ++--
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index fa48803..9b71bb1 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4527,6 +4527,8 @@ static int b43_op_start(struct ieee80211_hw *hw)
 		}
 	}
 
+	/* we don't expect older devices which need other RFKILL check */
+	B43_WARN_ON(dev->dev->id.revision < 3);
 	/* XXX: only do if device doesn't support rfkill irq */
 	wiphy_rfkill_start_polling(hw->wiphy);
 
diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
index 78016ae..012ed2f 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -26,25 +26,10 @@
 
 
 /* Returns TRUE, if the radio is enabled in hardware. */
-bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
+inline bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
 {
-	if (dev->phy.rev >= 3 || dev->phy.type == B43_PHYTYPE_LP) {
-		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
-		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
-			return 1;
-	} else {
-		/* To prevent CPU fault on PPC, do not read a register
-		 * unless the interface is started; however, on resume
-		 * for hibernation, this routine is entered early. When
-		 * that happens, unconditionally return TRUE.
-		 */
-		if (b43_status(dev) < B43_STAT_STARTED)
-			return 1;
-		if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
-		    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
-			return 1;
-	}
-	return 0;
+	return !(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
+		& B43_MMIO_RADIO_HWENABLED_HI_MASK);
 }
 
 /* The poll callback for the hardware button. */
diff --git a/drivers/net/wireless/b43/rfkill.h b/drivers/net/wireless/b43/rfkill.h
index f046c3c..7aa8a5a 100644
--- a/drivers/net/wireless/b43/rfkill.h
+++ b/drivers/net/wireless/b43/rfkill.h
@@ -4,8 +4,8 @@
 struct ieee80211_hw;
 struct b43_wldev;
 
-void b43_rfkill_poll(struct ieee80211_hw *hw);
+inline bool b43_is_hw_radio_enabled(struct b43_wldev *dev);
 
-bool b43_is_hw_radio_enabled(struct b43_wldev *dev);
+void b43_rfkill_poll(struct ieee80211_hw *hw);
 
 #endif /* B43_RFKILL_H_ */
-- 
1.6.0.4

