Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:47874 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbaEaKvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:36 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so3134202wes.32
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:34 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/14] staging: vt6656: rename MACvWriteWord to vnt_mac_write_word
Date: Sat, 31 May 2014 11:50:43 +0100
Message-Id: <1401533449-2972-8-git-send-email-tvboxspy@gmail.com> (sfid-20140531_132148_170072_8E2B5B3E)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c   | 2 +-
 drivers/staging/vt6656/mac.h   | 2 +-
 drivers/staging/vt6656/power.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 58a1a01..d0c3bd3 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -169,7 +169,7 @@ void vnt_mac_reg_bits_on(struct vnt_private *priv, u8 reg_ofs, u8 bits)
 		reg_ofs, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvWriteWord(struct vnt_private *priv, u8 reg_ofs, u16 word)
+void vnt_mac_write_word(struct vnt_private *priv, u8 reg_ofs, u16 word)
 {
 	u8 data[2];
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index d41299c..fa59131 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -421,7 +421,7 @@ void vnt_mac_disable_keyentry(struct vnt_private *, u8);
 void vnt_mac_set_keyentry(struct vnt_private *, u16, u32, u32, u8 *, u8 *);
 void vnt_mac_reg_bits_off(struct vnt_private *, u8, u8);
 void vnt_mac_reg_bits_on(struct vnt_private *, u8, u8);
-void MACvWriteWord(struct vnt_private *, u8, u16);
+void vnt_mac_write_word(struct vnt_private *, u8, u16);
 void MACvWriteBSSIDAddress(struct vnt_private *, u8 *);
 void MACvEnableProtectMD(struct vnt_private *);
 void MACvDisableProtectMD(struct vnt_private *);
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index 7c61da6..8cc2596 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -64,11 +64,11 @@ void PSvEnablePowerSaving(struct vnt_private *pDevice, u16 wListenInterval)
 	u16 wAID = pMgmt->wCurrAID | BIT14 | BIT15;
 
 	/* set period of power up before TBTT */
-	MACvWriteWord(pDevice, MAC_REG_PWBT, C_PWBT);
+	vnt_mac_write_word(pDevice, MAC_REG_PWBT, C_PWBT);
 
 	if (pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
 		/* set AID */
-		MACvWriteWord(pDevice, MAC_REG_AIDATIM, wAID);
+		vnt_mac_write_word(pDevice, MAC_REG_AIDATIM, wAID);
 	}
 
 	/* Warren:06-18-2004,the sequence must follow
-- 
1.9.1

