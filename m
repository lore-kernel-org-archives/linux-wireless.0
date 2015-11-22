Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38703 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbbKVJIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 04:08:13 -0500
Received: by wmec201 with SMTP id c201so69798406wme.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 01:08:12 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/8] staging: vt6655: rf.c/h Replace DeviceContext with vnt_private
Date: Sun, 22 Nov 2015 09:07:20 +0000
Message-Id: <1448183242-3397-6-git-send-email-tvboxspy@gmail.com> (sfid-20151122_100847_485450_A68DCD20)
In-Reply-To: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
References: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing void and including device.h for power.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/power.c | 10 +++-------
 drivers/staging/vt6655/power.h |  8 +++++---
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index e58afbd..ad44746 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -64,11 +64,10 @@
 
 void
 PSvEnablePowerSaving(
-	void *hDeviceContext,
+	struct vnt_private *priv,
 	unsigned short wListenInterval
 )
 {
-	struct vnt_private *priv = hDeviceContext;
 	u16 wAID = priv->current_aid | BIT(14) | BIT(15);
 
 	/* set period of power up before TBTT */
@@ -117,11 +116,9 @@ PSvEnablePowerSaving(
 
 void
 PSvDisablePowerSaving(
-	void *hDeviceContext
+	struct vnt_private *priv
 )
 {
-	struct vnt_private *priv = hDeviceContext;
-
 	/* disable power saving hw function */
 	MACbPSWakeup(priv->PortOffset);
 	/* clear AutoSleep */
@@ -149,10 +146,9 @@ PSvDisablePowerSaving(
 
 bool
 PSbIsNextTBTTWakeUp(
-	void *hDeviceContext
+	struct vnt_private *priv
 )
 {
-	struct vnt_private *priv = hDeviceContext;
 	struct ieee80211_hw *hw = priv->hw;
 	struct ieee80211_conf *conf = &hw->conf;
 	bool bWakeUp = false;
diff --git a/drivers/staging/vt6655/power.h b/drivers/staging/vt6655/power.h
index 538e685..d82dd8d 100644
--- a/drivers/staging/vt6655/power.h
+++ b/drivers/staging/vt6655/power.h
@@ -29,25 +29,27 @@
 #ifndef __POWER_H__
 #define __POWER_H__
 
+#include "device.h"
+
 #define C_PWBT                   1000    /* micro sec. power up before TBTT */
 #define PS_FAST_INTERVAL         1       /* Fast power saving listen interval */
 #define PS_MAX_INTERVAL          4       /* MAX power saving listen interval */
 
 void
 PSvDisablePowerSaving(
-	void *hDeviceContext
+	struct vnt_private *
 );
 
 void
 PSvEnablePowerSaving(
-	void *hDeviceContext,
+	struct vnt_private *,
 	unsigned short wListenInterval
 );
 
 
 bool
 PSbIsNextTBTTWakeUp(
-	void *hDeviceContext
+	struct vnt_private *
 );
 
 #endif /* __POWER_H__ */
-- 
2.6.2

