Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:44068 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbYFLKin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 06:38:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix noise calculation WARN_ON
Date: Thu, 12 Jun 2008 12:36:29 +0200
Cc: Arjan van de Ven <arjan@infradead.org>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806121236.30255.mb@bu3sch.de> (sfid-20080612_123847_625656_DA433C0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes a WARN_ON that is responsible for the following koops:
http://www.kerneloops.org/searchweek.php?search=b43_generate_noise_sample

The comment in the patch describes why it's safe to simply remove
the check.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is a bugfix for 2.6.26


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-06-12 11:42:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-06-12 12:03:29.000000000 +0200
@@ -646,13 +646,12 @@ struct b43_pio {
 
 	struct b43_pio_rxqueue *rx_queue;
 };
 
 /* Context information for a noise calculation (Link Quality). */
 struct b43_noise_calculation {
-	u8 channel_at_start;
 	bool calculation_running;
 	u8 nr_samples;
 	s8 samples[8][4];
 };
 
 struct b43_stats {
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-06-12 11:42:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-06-12 12:10:11.000000000 +0200
@@ -1142,22 +1142,20 @@ static void b43_jssi_write(struct b43_wl
 
 static void b43_generate_noise_sample(struct b43_wldev *dev)
 {
 	b43_jssi_write(dev, 0x7F7F7F7F);
 	b43_write32(dev, B43_MMIO_MACCMD,
 		    b43_read32(dev, B43_MMIO_MACCMD) | B43_MACCMD_BGNOISE);
-	B43_WARN_ON(dev->noisecalc.channel_at_start != dev->phy.channel);
 }
 
 static void b43_calculate_link_quality(struct b43_wldev *dev)
 {
 	/* Top half of Link Quality calculation. */
 
 	if (dev->noisecalc.calculation_running)
 		return;
-	dev->noisecalc.channel_at_start = dev->phy.channel;
 	dev->noisecalc.calculation_running = 1;
 	dev->noisecalc.nr_samples = 0;
 
 	b43_generate_noise_sample(dev);
 }
 
@@ -1168,15 +1166,22 @@ static void handle_irq_noise(struct b43_
 	u8 noise[4];
 	u8 i, j;
 	s32 average;
 
 	/* Bottom half of Link Quality calculation. */
 
+	/* Possible race condition: It might be possible that the user
+	 * changed to a different channel in the meantime since we
+	 * started the calculation. We ignore that fact, since it's
+	 * not really that much of a problem. The background noise is
+	 * an estimation only anyway. Slightly wrong results will get damped
+	 * by the averaging of the 8 sample rounds. Additionally the
+	 * value is shortlived. So it will be replaced by the next noise
+	 * calculation round soon. */
+
 	B43_WARN_ON(!dev->noisecalc.calculation_running);
-	if (dev->noisecalc.channel_at_start != phy->channel)
-		goto drop_calculation;
 	*((__le32 *)noise) = cpu_to_le32(b43_jssi_read(dev));
 	if (noise[0] == 0x7F || noise[1] == 0x7F ||
 	    noise[2] == 0x7F || noise[3] == 0x7F)
 		goto generate_new;
 
 	/* Get the noise samples. */
@@ -1211,17 +1216,16 @@ static void handle_irq_noise(struct b43_
 		if (tmp == 8)
 			average -= 72;
 		else
 			average -= 48;
 
 		dev->stats.link_noise = average;
-	      drop_calculation:
 		dev->noisecalc.calculation_running = 0;
 		return;
 	}
-      generate_new:
+generate_new:
 	b43_generate_noise_sample(dev);
 }
 
 static void handle_irq_tbtt_indication(struct b43_wldev *dev)
 {
 	if (b43_is_mode(dev->wl, IEEE80211_IF_TYPE_AP)) {
