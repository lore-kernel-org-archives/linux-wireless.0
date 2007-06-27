Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbXF0VQ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 17:16:56 -0400
Message-ID: <4682D3A6.40506@redhat.com>
Date: Wed, 27 Jun 2007 23:16:22 +0200
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Matteo Croce <rootkit85@yahoo.it>
Subject: [PATCH 2/4] airo: delay parts of initialization until the netdev  is up
References: <4682D323.2010605@redhat.com>
In-Reply-To: <4682D323.2010605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

airo's kernel thread and the IRQ handler are needed only when the interface
is up.
With their initialization moved to .open() there are no more users of
dev->name before registration, so this fixes the race when the
initialization could fail when another netdev stole airo's name.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

---
 drivers/net/wireless/airo.c |   84 +++++++++++++++++++++++--------------------
 1 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 38346a5..63a4aaa 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1928,28 +1928,55 @@ static int readStatsRid(struct airo_info*ai, StatsRid *sr, int rid, int lock) {
 	return rc;
 }
 
+static void try_auto_wep(struct airo_info *ai)
+{
+	if (auto_wep && !(ai->flags & FLAG_RADIO_DOWN)) {
+		ai->expires = RUN_AT(3*HZ);
+		wake_up_interruptible(&ai->thr_wait);
+	}
+}
+
 static int airo_open(struct net_device *dev) {
-	struct airo_info *info = dev->priv;
+	struct airo_info *ai = dev->priv;
 	Resp rsp;
+	int rc = 0;
 
-	if (test_bit(FLAG_FLASHING, &info->flags))
+	if (test_bit(FLAG_FLASHING, &ai->flags))
 		return -EIO;
 
 	/* Make sure the card is configured.
 	 * Wireless Extensions may postpone config changes until the card
 	 * is open (to pipeline changes and speed-up card setup). If
 	 * those changes are not yet commited, do it now - Jean II */
-	if (test_bit (FLAG_COMMIT, &info->flags)) {
-		disable_MAC(info, 1);
-		writeConfigRid(info, 1);
+	if (test_bit(FLAG_COMMIT, &ai->flags)) {
+		disable_MAC(ai, 1);
+		writeConfigRid(ai, 1);
 	}
 
-	if (info->wifidev != dev) {
+	if (ai->wifidev != dev) {
+		clear_bit(JOB_DIE, &ai->jobs);
+		ai->airo_thread_task = kthread_run(airo_thread, dev, dev->name);
+		if (IS_ERR(ai->airo_thread_task))
+			return (int)PTR_ERR(ai->airo_thread_task);
+		
+		rc = request_irq(dev->irq, airo_interrupt, IRQF_SHARED,
+			dev->name, dev);
+		if (rc) {
+			airo_print_err(dev->name,
+				"register interrupt %d failed, rc %d",
+				dev->irq, rc);
+			set_bit(JOB_DIE, &ai->jobs);
+			kthread_stop(ai->airo_thread_task);
+			return rc;
+		}
+		
 		/* Power on the MAC controller (which may have been disabled) */
-		clear_bit(FLAG_RADIO_DOWN, &info->flags);
-		enable_interrupts(info);
+		clear_bit(FLAG_RADIO_DOWN, &ai->flags);
+		enable_interrupts(ai);
+
+		try_auto_wep(ai);
 	}
-	enable_MAC(info, &rsp, 1);
+	enable_MAC(ai, &rsp, 1);
 
 	netif_start_queue(dev);
 	return 0;
@@ -2394,6 +2421,11 @@ static int airo_close(struct net_device *dev) {
 		disable_MAC(ai, 1);
 #endif
 		disable_interrupts( ai );
+
+		free_irq(dev->irq, dev);
+		
+		set_bit(JOB_DIE, &ai->jobs);
+		kthread_stop(ai->airo_thread_task);
 	}
 	return 0;
 }
@@ -2405,7 +2437,6 @@ void stop_airo_card( struct net_device *dev, int freeres )
 	set_bit(FLAG_RADIO_DOWN, &ai->flags);
 	disable_MAC(ai, 1);
 	disable_interrupts(ai);
-	free_irq( dev->irq, dev );
 	takedown_proc_entry( dev, ai );
 	if (test_bit(FLAG_REGISTERED, &ai->flags)) {
 		unregister_netdev( dev );
@@ -2416,9 +2447,6 @@ void stop_airo_card( struct net_device *dev, int freeres )
 		}
 		clear_bit(FLAG_REGISTERED, &ai->flags);
 	}
-	set_bit(JOB_DIE, &ai->jobs);
-	kthread_stop(ai->airo_thread_task);
-
 	/*
 	 * Clean out tx queue
 	 */
@@ -2802,10 +2830,6 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 		airo_print_err("", "Couldn't alloc_etherdev");
 		return NULL;
         }
-	if (dev_alloc_name(dev, dev->name) < 0) {
-		airo_print_err("", "Couldn't get name!");
-		goto err_out_free;
-	}
 
 	ai = dev->priv;
 	ai->wifidev = NULL;
@@ -2821,14 +2845,11 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	ai->config.len = 0;
 	ai->pci = pci;
 	init_waitqueue_head (&ai->thr_wait);
-	ai->airo_thread_task = kthread_run(airo_thread, dev, dev->name);
-	if (IS_ERR(ai->airo_thread_task))
-		goto err_out_free;
 	ai->tfm = NULL;
 	add_airo_dev(ai);
 
 	if (airo_networks_allocate (ai))
-		goto err_out_thr;
+		goto err_out_free;
 	airo_networks_initialize (ai);
 
 	/* The Airo-specific entries in the device structure. */
@@ -2851,21 +2872,16 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	dev->base_addr = port;
 
 	SET_NETDEV_DEV(dev, dmdev);
+	SET_MODULE_OWNER(dev);
 
 	reset_card (dev, 1);
 	msleep(400);
 
-	rc = request_irq( dev->irq, airo_interrupt, IRQF_SHARED, dev->name, dev );
-	if (rc) {
-		airo_print_err(dev->name, "register interrupt %d failed, rc %d",
-				irq, rc);
-		goto err_out_nets;
-	}
 	if (!is_pcmcia) {
 		if (!request_region(dev->base_addr, 64, DRV_NAME)) {
 			rc = -EBUSY;
 			airo_print_err("", "Couldn't request region");
-			goto err_out_irq;
+			goto err_out_nets;
 		}
 	}
 
@@ -2921,8 +2937,6 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	if (setup_proc_entry(dev, dev->priv) < 0)
 		goto err_out_wifi;
 
-	netif_start_queue(dev);
-	SET_MODULE_OWNER(dev);
 	return dev;
 
 err_out_wifi:
@@ -2940,14 +2954,9 @@ err_out_map:
 err_out_res:
 	if (!is_pcmcia)
 	        release_region( dev->base_addr, 64 );
-err_out_irq:
-	free_irq(dev->irq, dev);
 err_out_nets:
 	airo_networks_free(ai);
-err_out_thr:
 	del_airo_dev(ai);
-	set_bit(JOB_DIE, &ai->jobs);
-	kthread_stop(ai->airo_thread_task);
 err_out_free:
 	free_netdev(dev);
 	return NULL;
@@ -3919,10 +3928,7 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 		rc = readWepKeyRid(ai, &wkr, 0, lock);
 	} while(lastindex != wkr.kindex);
 
-	if (auto_wep) {
-		ai->expires = RUN_AT(3*HZ);
-		wake_up_interruptible(&ai->thr_wait);
-	}
+	try_auto_wep(ai);
 
 	return SUCCESS;
 }


