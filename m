Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52621 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbYIFO0v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 10:26:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix QoS defaults
Date: Sat, 6 Sep 2008 16:21:47 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Lorenzo Nava <pipe1984@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200809061621.48449.mb@bu3sch.de> (sfid-20080906_162656_925402_BA486F0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the initialization of the default QoS parameters.
This got broken by 0b57664cf2393bc1eff594ff7e5ff26533843fe6

Reported-by: Lorenzo Nava
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next merge window, as I'm not interested
in finding explanations for applying this to 2.6.27 (2.6.27 already has
this bug)


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-09-06 15:09:16.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-09-06 15:45:09.000000000 +0200
@@ -3056,37 +3056,40 @@ static void b43_qos_params_upload(struct
 					shm_offset + (i * 2),
 					params[i]);
 		}
 	}
 }
 
+/* Mapping of mac80211 queue numbers to b43 QoS SHM offsets. */
+static const u16 b43_qos_shm_offsets[] = {
+	/* [mac80211-queue-nr] = SHM_OFFSET, */
+	[0] = B43_QOS_VOICE,
+	[1] = B43_QOS_VIDEO,
+	[2] = B43_QOS_BESTEFFORT,
+	[3] = B43_QOS_BACKGROUND,
+};
+
 /* Update the QOS parameters in hardware. */
 static void b43_qos_update(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
 	struct b43_qos_params *params;
 	unsigned long flags;
 	unsigned int i;
 
-	/* Mapping of mac80211 queues to b43 SHM offsets. */
-	static const u16 qos_shm_offsets[] = {
-		[0] = B43_QOS_VOICE,
-		[1] = B43_QOS_VIDEO,
-		[2] = B43_QOS_BESTEFFORT,
-		[3] = B43_QOS_BACKGROUND,
-	};
-	BUILD_BUG_ON(ARRAY_SIZE(qos_shm_offsets) != ARRAY_SIZE(wl->qos_params));
+	BUILD_BUG_ON(ARRAY_SIZE(b43_qos_shm_offsets) !=
+		     ARRAY_SIZE(wl->qos_params));
 
 	b43_mac_suspend(dev);
 	spin_lock_irqsave(&wl->irq_lock, flags);
 
 	for (i = 0; i < ARRAY_SIZE(wl->qos_params); i++) {
 		params = &(wl->qos_params[i]);
 		if (params->need_hw_update) {
 			b43_qos_params_upload(dev, &(params->p),
-					      qos_shm_offsets[i]);
+					      b43_qos_shm_offsets[i]);
 			params->need_hw_update = 0;
 		}
 	}
 
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 	b43_mac_enable(dev);
@@ -3094,17 +3097,48 @@ static void b43_qos_update(struct b43_wl
 
 static void b43_qos_clear(struct b43_wl *wl)
 {
 	struct b43_qos_params *params;
 	unsigned int i;
 
+	/* Initialize QoS parameters to sane defaults. */
+
+	BUILD_BUG_ON(ARRAY_SIZE(b43_qos_shm_offsets) !=
+		     ARRAY_SIZE(wl->qos_params));
+
 	for (i = 0; i < ARRAY_SIZE(wl->qos_params); i++) {
 		params = &(wl->qos_params[i]);
 
-		memset(&(params->p), 0, sizeof(params->p));
-		params->p.aifs = -1;
+		switch (b43_qos_shm_offsets[i]) {
+		case B43_QOS_VOICE:
+			params->p.txop = 0;
+			params->p.aifs = 2;
+			params->p.cw_min = 0x0001;
+			params->p.cw_max = 0x0001;
+			break;
+		case B43_QOS_VIDEO:
+			params->p.txop = 0;
+			params->p.aifs = 2;
+			params->p.cw_min = 0x0001;
+			params->p.cw_max = 0x0001;
+			break;
+		case B43_QOS_BESTEFFORT:
+			params->p.txop = 0;
+			params->p.aifs = 3;
+			params->p.cw_min = 0x0001;
+			params->p.cw_max = 0x03FF;
+			break;
+		case B43_QOS_BACKGROUND:
+			params->p.txop = 0;
+			params->p.aifs = 7;
+			params->p.cw_min = 0x0001;
+			params->p.cw_max = 0x03FF;
+			break;
+		default:
+			B43_WARN_ON(1);
+		}
 		params->need_hw_update = 1;
 	}
 }
 
 /* Initialize the core's QOS capabilities */
 static void b43_qos_init(struct b43_wldev *dev)
