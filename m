Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54388 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaJIIiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:38:12 -0400
Received: by mail-wi0-f177.google.com with SMTP id fb4so1051581wid.10
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 01:38:11 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Seth Forshee <seth.forshee@canonical.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH][RTF][RFC] brcmsmac: add workaround for old BCM4313 devices with Bluetooth
Date: Thu,  9 Oct 2014 10:37:47 +0200
Message-Id: <1412843867-26563-1-git-send-email-zajec5@gmail.com> (sfid-20141009_103818_544888_779DA460)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Please check if it fixes BCM4313 performance problems.
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c | 13 +++++++++++++
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |  3 +++
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |  6 ++++++
 3 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 5336597..3d39176 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -310,6 +310,9 @@
 /* External PA enable mask */
 #define GPIO_CTRL_EPA_EN_MASK 0x40
 
+/* WL/BT control enable mask */
+#define GPIO_CTRL_5_6_EN_MASK 0x60
+
 #define DEFAULT_GPIOTIMERVAL \
 	((DEFAULT_GPIO_ONTIME << GPIO_ONTIME_SHIFT) | DEFAULT_GPIO_OFFTIME)
 
@@ -691,6 +694,16 @@ void ai_epa_4313war(struct si_pub *sih)
 	bcma_set32(cc, CHIPCREGOFFS(gpiocontrol), GPIO_CTRL_EPA_EN_MASK);
 }
 
+/* WL/BT control for 4313 btcombo boards >= P250 */
+void ai_btcombo_p250_4313_war(struct si_pub *sih)
+{
+	struct si_info *sii = container_of(sih, struct si_info, pub);
+	struct bcma_device *cc = sii->icbus->drv_cc.core;
+
+	bcma_set32(cc, CHIPCREGOFFS(gpiocontrol), GPIO_CTRL_5_6_EN_MASK);
+	bcma_set32(cc, CHIPCREGOFFS(gpioouten), GPIO_CTRL_5_6_EN_MASK);
+}
+
 /* check if the device is removed */
 bool ai_deviceremoved(struct si_pub *sih)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 2d08c15..7652a0f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -186,6 +186,9 @@ bool ai_deviceremoved(struct si_pub *sih);
 /* Enable Ex-PA for 4313 */
 void ai_epa_4313war(struct si_pub *sih);
 
+/* WL/BT control for 4313 btcombo boards >= P250 */
+void ai_btcombo_p250_4313_war(struct si_pub *sih);
+
 static inline u32 ai_get_cccaps(struct si_pub *sih)
 {
 	return sih->cccaps;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 1b47482..046e832 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4942,6 +4942,12 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 		     && (wlc_hw->boardflags & BFL_FEM_BT)))
 			ai_epa_4313war(wlc_hw->sih);
 	}
+
+	/* TODO: Fix the condition. Only for boards >= P250 */
+	if (ai_get_chip_id(wlc_hw->sih) == BCMA_CHIP_ID_BCM4313 && (wlc_hw->boardflags & BFL_FEM_BT)) {
+		pr_info("Applying BCM4313 WL/BT workaround\n");
+		ai_btcombo_p250_4313_war(wlc_hw->sih);
+	}
 }
 
 static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
-- 
1.8.4.5

