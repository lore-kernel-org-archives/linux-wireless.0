Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44692 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbaEQIwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:52:38 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm4so1999344wib.16
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:52:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/22] staging: vt6656: rf.c additional power.
Date: Sat, 17 May 2014 09:50:18 +0100
Message-Id: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com> (sfid-20140517_105242_928654_028AED92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provides extra power on weak RSSI.

The values orginate from the vendors driver.

It is applied later in RFbRawSetPower to simplify and check that it doesn't
exceed the max power.

Vendor driver VT6656_Linux_src_v1.21.03_x86_11.04.zip
http://www.viaembedded.com/servlet/downloadSvl?id=1890&download_file_id=14704
This is GPL-licensed code.

vendors code
...
if (pDevice->byRFType == RF_VT3226D0) {
	if (lRSSI == 0){
		lAdditionalPower = 7;
	}
	else if ((lRSSI < -60) && (lRSSI >= -65)){
		lAdditionalPower = 5;
		//lAdditionalPower = 9;
	}
	else if ((lRSSI < -65) && (lRSSI >= -70)){
		lAdditionalPower = 7;
		//lAdditionalPower = 9;
	}
	else if ((lRSSI < -70) && (lRSSI >= -80)){
		lAdditionalPower = 9;
		}
	else if (lRSSI < -80) {
		lAdditionalPower = 9;
	}
}
else {
	if (lRSSI == 0){
		lAdditionalPower = 7;
	}
	else if ((lRSSI < -70) && (lRSSI >= -75)){
		lAdditionalPower = 5;
	}
	else if ((lRSSI < -75) && (lRSSI >= -80)){
			lAdditionalPower = 7;
		}
		else if (lRSSI < -80) {
			lAdditionalPower = 9;
		}
	}

...

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 30 ++++++++++++++++++++++++++++++
 drivers/staging/vt6656/rf.h |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 1e8f64b..64632e9 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -769,6 +769,32 @@ int RFbSetPower(struct vnt_private *priv, u32 rate, u32 channel)
 	return ret;
 }
 
+static u8 vnt_rf_addpower(struct vnt_private *priv)
+{
+	s32 rssi = -priv->uCurrRSSI;
+
+	if (!rssi)
+		return 7;
+
+	if (priv->byRFType == RF_VT3226D0) {
+		if (rssi < -70)
+			return 9;
+		else if (rssi < -65)
+			return 7;
+		else if (rssi < -60)
+			return 5;
+	} else {
+		if (rssi < -80)
+			return 9;
+		else if (rssi < -75)
+			return 7;
+		else if (rssi < -70)
+			return 5;
+	}
+
+	return 0;
+}
+
 /*
  * Description: Set Tx power
  *
@@ -788,6 +814,10 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 	u32 power_setting = 0;
 	int ret = true;
 
+	power += vnt_rf_addpower(priv);
+	if (power > VNT_RF_MAX_POWER)
+		power = VNT_RF_MAX_POWER;
+
 	if (priv->byCurPwr == power)
 		return true;
 
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index de5c613..e9a01fe 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -53,6 +53,8 @@
 #define RF_EMU              0x80
 #define RF_MASK             0x7F
 
+#define VNT_RF_MAX_POWER    0x3f
+
 extern const u8 RFaby11aChannelIndex[200];
 
 int IFRFbWriteEmbedded(struct vnt_private *, u32 dwData);
-- 
1.9.1

