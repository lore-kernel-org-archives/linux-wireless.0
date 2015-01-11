Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:54929 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbbAKKdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2015 05:33:35 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so14563200wes.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2015 02:33:34 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] staging: vt6655: [BUG] Protect MACvSelectPage1 with lock.
Date: Sun, 11 Jan 2015 10:26:12 +0000
Message-Id: <1420971972-3476-1-git-send-email-tvboxspy@gmail.com> (sfid-20150111_113339_510427_E4E94AE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device must not flip to page 1 while in interrupt lock causing
loss of connection or dead lock.

Protect from changes to page by adding lock where user can
change the page in CARDvSetRSPINF, vnt_configure and set_channel

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        | 5 +++++
 drivers/staging/vt6655/channel.c     | 6 ++++++
 drivers/staging/vt6655/device_main.c | 6 ++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index a079640..47801ca 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -670,6 +670,9 @@ void CARDvSetRSPINF(struct vnt_private *pDevice, u8 bb_type)
 {
 	union vnt_phy_field_swap phy;
 	unsigned char byTxRate, byRsvTime;      /* For OFDM */
+	unsigned long flags;
+
+	spin_lock_irqsave(&pDevice->lock, flags);
 
 	/* Set to Page1 */
 	MACvSelectPage1(pDevice->PortOffset);
@@ -767,6 +770,8 @@ void CARDvSetRSPINF(struct vnt_private *pDevice, u8 bb_type)
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_72, MAKEWORD(byTxRate, byRsvTime));
 	/* Set to Page0 */
 	MACvSelectPage0(pDevice->PortOffset);
+
+	spin_unlock_irqrestore(&pDevice->lock, flags);
 }
 
 void CARDvUpdateBasicTopRate(struct vnt_private *pDevice)
diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index 70f8705..d593f5f 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -210,6 +210,10 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 	BBvSoftwareReset(pDevice);
 
 	if (pDevice->byLocalID > REV_ID_VT3253_B1) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&pDevice->lock, flags);
+
 		/* set HW default power register */
 		MACvSelectPage1(pDevice->PortOffset);
 		RFbSetPower(pDevice, RATE_1M, pDevice->byCurrentCh);
@@ -217,6 +221,8 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 		RFbSetPower(pDevice, RATE_6M, pDevice->byCurrentCh);
 		VNSvOutPortB(pDevice->PortOffset + MAC_REG_PWROFDM, pDevice->byCurPwr);
 		MACvSelectPage0(pDevice->PortOffset);
+
+		spin_unlock_irqrestore(&pDevice->lock, flags);
 	}
 
 	if (pDevice->byBBType == BB_TYPE_11B)
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index cd1a277..d5c45f8 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1572,6 +1572,10 @@ static void vnt_configure(struct ieee80211_hw *hw,
 
 	if (changed_flags & FIF_ALLMULTI) {
 		if (*total_flags & FIF_ALLMULTI) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&priv->lock, flags);
+
 			if (priv->mc_list_count > 2) {
 				MACvSelectPage1(priv->PortOffset);
 
@@ -1593,6 +1597,8 @@ static void vnt_configure(struct ieee80211_hw *hw,
 				MACvSelectPage0(priv->PortOffset);
 			}
 
+			spin_unlock_irqrestore(&priv->lock, flags);
+
 			rx_mode |= RCR_MULTICAST | RCR_BROADCAST;
 		} else {
 			rx_mode &= ~(RCR_MULTICAST | RCR_BROADCAST);
-- 
2.1.0

