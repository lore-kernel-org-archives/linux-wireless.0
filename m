Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19455 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbYC0QEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 12:04:04 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [RFC] libertas: convert libertas driver to use an event/cmdresp queue
Date: Thu, 27 Mar 2008 17:00:58 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803271700.58477.hs4233@mail.mn-solutions.de> (sfid-20080327_160412_076278_C4822F5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implemens the new event queue driven interrupt logic
in the the libertas driver liberary and in the compact flash
hardware driver.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

This patch (on top of all patches that I submitted so far)
get's me a working libertas driver that can scan, associate
(only tested with iwconfig/wep so far), receive packets and
send packets. So I can actually ping :-)

However, I have only lightly tested.

Unlike the previous version, this now survives

CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y

which is definitely a pro :-)

Althought this patch is RFC; I put a Signed-off-by line into it.
So if you think this patch is ok (or mostly ok) and want to add
support for if_usb.c into it, you naturally can re-use this.

Index: wireless-testing/drivers/net/wireless/libertas/dev.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/dev.h	2008-03-27 15:42:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/dev.h	2008-03-27 15:44:34.000000000 +0100
@@ -97,6 +97,13 @@ struct lbs_mesh_stats {
 	u32	tx_failed_cnt;		/* Tx:  Failed transmissions */
 };
 
+struct lbs_event {
+	struct list_head list;
+	u32 event;  /* MACREG_INT_CODE_xxxxx */
+	u32 len;
+	u8 data[LBS_UPLD_SIZE];
+};
+
 /** Private structure for the MV device */
 struct lbs_private {
 	int mesh_open;
@@ -128,10 +135,6 @@ struct lbs_private {
 	u32 bbp_offset;
 	u32 rf_offset;
 
-	/** Upload length */
-	u32 upld_len;
-	/* Upload buffer */
-	u8 upld_buf[LBS_UPLD_SIZE];
 	/* Download sent:
 	   bit0 1/0=data_sent/data_tx_done,
 	   bit1 1/0=cmd_sent/cmd_tx_done,
@@ -154,21 +157,16 @@ struct lbs_private {
 
 	/** Hardware access */
 	int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *payload, u16 nb);
-	int (*hw_get_int_status) (struct lbs_private *priv, u8 *);
-	int (*hw_read_event_cause) (struct lbs_private *);
 
 	/* Wake On LAN */
 	uint32_t wol_criteria;
 	uint8_t wol_gpio;
 	uint8_t wol_gap;
 
-	/* was struct lbs_adapter from here... */
-
 	/** Wlan adapter data structure*/
 	/** STATUS variables */
 	u32 fwrelease;
 	u32 fwcapinfo;
-	/* protected with big lock */
 
 	struct mutex lock;
 
@@ -180,7 +178,6 @@ struct lbs_private {
 
 	/** command-related variables */
 	u16 seqnum;
-	/* protected by big lock */
 
 	struct cmd_ctrl_node *cmd_array;
 	/** Current command */
@@ -193,12 +190,14 @@ struct lbs_private {
 	struct list_head cmdpendingq;
 
 	wait_queue_head_t cmd_pending;
-	/* command related variables protected by priv->driver_lock */
 
-	/** Async and Sync Event variables */
-	u32 intcounter;
-	u32 eventcause;
-	u8 nodename[16];	/* nickname */
+	/* This holds holds event send from the hardware to the driver */
+	struct lbs_event *event_array;
+	struct list_head event_list;
+	struct list_head event_free_list;
+
+	/* nickname */
+	u8 nodename[16];
 
 	/** spin locks */
 	spinlock_t driver_lock;
@@ -208,8 +207,6 @@ struct lbs_private {
 	int nr_retries;
 	int cmd_timed_out;
 
-	u8 hisregcpy;
-
 	/** current ssid/bssid related parameters*/
 	struct current_bss_params curbssparams;
 
Index: wireless-testing/drivers/net/wireless/libertas/decl.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/decl.h	2008-03-27 15:42:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/decl.h	2008-03-27 15:44:34.000000000 +0100
@@ -30,8 +30,9 @@ int lbs_prepare_and_send_command(struct 
 
 int lbs_allocate_cmd_buffer(struct lbs_private *priv);
 int lbs_execute_next_command(struct lbs_private *priv);
-int lbs_process_event(struct lbs_private *priv);
-void lbs_interrupt(struct lbs_private *priv);
+int lbs_process_event(struct lbs_private *priv, u32 eventcause);
+struct lbs_event *lbs_get_free_event(struct lbs_private *priv);
+void lbs_handle_event(struct lbs_private *priv, struct lbs_event *event);
 int lbs_set_radio_control(struct lbs_private *priv);
 u32 lbs_fw_index_to_data_rate(u8 index);
 u8 lbs_data_rate_to_fw_index(u32 rate);
@@ -40,7 +41,7 @@ void lbs_get_fwversion(struct lbs_privat
 	int maxlen);
 
 /** The proc fs interface */
-int lbs_process_rx_command(struct lbs_private *priv);
+int lbs_process_rx_command(struct lbs_private *priv, u8 *data, u32 len);
 void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
 			  int result);
 int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev);
Index: wireless-testing/drivers/net/wireless/libertas/defs.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/defs.h	2008-03-27 15:42:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/defs.h	2008-03-27 15:44:34.000000000 +0100
@@ -177,8 +177,6 @@ static inline void lbs_deb_hex(unsigned 
 #define MRVDRV_CMD_UPLD_RDY		0x0008
 #define MRVDRV_CARDEVENT		0x0010
 
-#define SBI_EVENT_CAUSE_SHIFT		3
-
 /** TxPD status */
 
 /*	Station firmware use TxPD status field to report final Tx transmit
Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-03-27 15:42:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-03-27 15:44:34.000000000 +0100
@@ -481,9 +481,13 @@ static void lbs_tx_timeout(struct net_de
 	dev->trans_start = jiffies;
 
 	if (priv->currenttxskb) {
+#ifdef TODO
+/* TODO: was this fake bit for lbs_send_tx_feedback() to expose this into radiotap? */
 		priv->eventcause = 0x01000000;
+#endif
 		lbs_send_tx_feedback(priv);
 	}
+
 	/* XX: Shouldn't we also call into the hw-specific driver
 	   to kick it somehow? */
 	lbs_host_to_card_done(priv);
@@ -659,7 +663,7 @@ static int lbs_thread(void *data)
 	struct net_device *dev = data;
 	struct lbs_private *priv = dev->priv;
 	wait_queue_t wait;
-	u8 ireg = 0;
+	struct lbs_event *event = NULL;
 
 	lbs_deb_enter(LBS_DEB_THREAD);
 
@@ -668,8 +672,8 @@ static int lbs_thread(void *data)
 	for (;;) {
 		int shouldsleep;
 
-		lbs_deb_thread( "main-thread 111: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
-				priv->intcounter, priv->currenttxskb, priv->dnld_sent);
+		lbs_deb_thread( "1: currenttxskb %p, dnld_sent %d\n",
+				priv->currenttxskb, priv->dnld_sent);
 
 		add_wait_queue(&priv->waitq, &wait);
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -681,8 +685,6 @@ static int lbs_thread(void *data)
 			shouldsleep = 1;	/* We need to wait until we're _told_ to die */
 		else if (priv->psstate == PS_STATE_SLEEP)
 			shouldsleep = 1;	/* Sleep mode. Nothing we can do till it wakes */
-		else if (priv->intcounter)
-			shouldsleep = 0;	/* Interrupt pending. Deal with it now */
 		else if (priv->cmd_timed_out)
 			shouldsleep = 0;	/* Command timed out. Recover */
 		else if (!priv->fw_ready)
@@ -695,29 +697,31 @@ static int lbs_thread(void *data)
 			shouldsleep = 1;	/* Can't send a command; one already running */
 		else if (!list_empty(&priv->cmdpendingq))
 			shouldsleep = 0;	/* We have a command to send */
+		else if (!list_empty(&priv->event_list))
+			shouldsleep = 0;	/* We have an event to process */
 		else
 			shouldsleep = 1;	/* No command */
 
 		if (shouldsleep) {
-			lbs_deb_thread("main-thread sleeping... Conn=%d IntC=%d PS_mode=%d PS_State=%d\n",
-				       priv->connect_status, priv->intcounter,
-				       priv->psmode, priv->psstate);
+			lbs_deb_thread("sleeping, connect_status %d, ps_mode %d, "
+				"ps_state %d\n", priv->connect_status,
+				priv->psmode, priv->psstate);
 			spin_unlock_irq(&priv->driver_lock);
 			schedule();
 		} else
 			spin_unlock_irq(&priv->driver_lock);
 
-		lbs_deb_thread("main-thread 222 (waking up): intcounter=%d currenttxskb=%p dnld_sent=%d\n",
-			       priv->intcounter, priv->currenttxskb, priv->dnld_sent);
+		lbs_deb_thread("2: currenttxskb %p, dnld_send %d\n",
+			       priv->currenttxskb, priv->dnld_sent);
 
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&priv->waitq, &wait);
 
-		lbs_deb_thread("main-thread 333: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
-			       priv->intcounter, priv->currenttxskb, priv->dnld_sent);
+		lbs_deb_thread("3: currenttxskb %p, dnld_sent %d\n",
+			       priv->currenttxskb, priv->dnld_sent);
 
 		if (kthread_should_stop()) {
-			lbs_deb_thread("main-thread: break from main thread\n");
+			lbs_deb_thread("break from main thread\n");
 			break;
 		}
 
@@ -726,35 +730,24 @@ static int lbs_thread(void *data)
 			continue;
 		}
 
-		spin_lock_irq(&priv->driver_lock);
-
-		if (priv->intcounter) {
-			u8 int_status;
-
-			priv->intcounter = 0;
-			int_status = priv->hw_get_int_status(priv, &ireg);
-
-			if (int_status) {
-				lbs_deb_thread("main-thread: reading HOST_INT_STATUS_REG failed\n");
-				spin_unlock_irq(&priv->driver_lock);
-				continue;
-			}
-			priv->hisregcpy |= ireg;
-		}
-
-		lbs_deb_thread("main-thread 444: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
-			       priv->intcounter, priv->currenttxskb, priv->dnld_sent);
-
-		/* command response? */
-		if (priv->hisregcpy & MRVDRV_CMD_UPLD_RDY) {
-			lbs_deb_thread("main-thread: cmd response ready\n");
+ do_events:
+		lbs_deb_thread("4: currenttxskb %p, dnld_sent %d\n",
+		       priv->currenttxskb, priv->dnld_sent);
 
-			priv->hisregcpy &= ~MRVDRV_CMD_UPLD_RDY;
-			spin_unlock_irq(&priv->driver_lock);
-			lbs_process_rx_command(priv);
+		/* Get event (if any) and process command responses */
+		if (!list_empty(&priv->event_list)) {
+			/* Get used event */
 			spin_lock_irq(&priv->driver_lock);
+			event = list_first_entry(
+				&priv->event_list, struct lbs_event, list);
+			list_del(&event->list);
+			spin_unlock_irq(&priv->driver_lock);
+
+			if (event->len)
+				lbs_process_rx_command(priv, event->data, event->len);
 		}
 
+		/* command timeout stuff */
 		if (priv->cmd_timed_out && priv->cur_cmd) {
 			struct cmd_ctrl_node *cmdnode = priv->cur_cmd;
 
@@ -775,21 +768,22 @@ static int lbs_thread(void *data)
 		}
 		priv->cmd_timed_out = 0;
 
-		/* Any Card Event */
-		if (priv->hisregcpy & MRVDRV_CARDEVENT) {
-			lbs_deb_thread("main-thread: Card Event Activity\n");
-
-			priv->hisregcpy &= ~MRVDRV_CARDEVENT;
+		/* Process hardware events, e.g. card removed, link lost */
+		if (event) {
+			if (event->event)
+				lbs_process_event(priv, event->event);
 
-			if (priv->hw_read_event_cause(priv)) {
-				lbs_pr_alert("main-thread: hw_read_event_cause failed\n");
-				spin_unlock_irq(&priv->driver_lock);
-				continue;
-			}
-			spin_unlock_irq(&priv->driver_lock);
-			lbs_process_event(priv);
-		} else
+			/* let this event be re-used */
+			event->event = 0;
+			event->len = 0;
+			spin_lock_irq(&priv->driver_lock);
+			list_add_tail(&event->list, &priv->event_free_list);
 			spin_unlock_irq(&priv->driver_lock);
+			event = NULL;
+
+			/* Process more events, until nothing there anymore */
+			goto do_events;
+		}
 
 		if (!priv->fw_ready)
 			continue;
@@ -798,8 +792,8 @@ static int lbs_thread(void *data)
 		if (priv->psstate == PS_STATE_PRE_SLEEP &&
 		    !priv->dnld_sent && !priv->cur_cmd) {
 			if (priv->connect_status == LBS_CONNECTED) {
-				lbs_deb_thread("main_thread: PRE_SLEEP--intcounter=%d currenttxskb=%p dnld_sent=%d cur_cmd=%p, confirm now\n",
-					       priv->intcounter, priv->currenttxskb, priv->dnld_sent, priv->cur_cmd);
+				lbs_deb_thread("main_thread: PRE_SLEEP--currenttxskb=%p dnld_sent=%d cur_cmd=%p, confirm now\n",
+					       priv->currenttxskb, priv->dnld_sent, priv->cur_cmd);
 
 				lbs_ps_confirm_sleep(priv);
 			} else {
@@ -809,7 +803,7 @@ static int lbs_thread(void *data)
 				 * after firmware fixes it
 				 */
 				priv->psstate = PS_STATE_AWAKE;
-				lbs_pr_alert("main-thread: ignore PS_SleepConfirm in non-connected state\n");
+				lbs_pr_alert("ignore PS_SleepConfirm in non-connected state\n");
 			}
 		}
 
@@ -994,6 +988,29 @@ static void lbs_sync_channel_worker(stru
 }
 
 
+//TODO: move this to some *.h file or to the top of this file
+#define LBS_NUM_EVENT_BUFFERS 10
+static int lbs_allocate_event_buffer(struct lbs_private *priv)
+{
+	int ret = 0;
+	u32 bufsize;
+	u32 i;
+
+	lbs_deb_enter(LBS_DEB_MAIN);
+	/* Allocate and initialize the command array */
+	bufsize = sizeof(struct lbs_event) * LBS_NUM_EVENT_BUFFERS;
+	if (!(priv->event_array = kzalloc(bufsize, GFP_KERNEL))) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	for (i = 0; i < LBS_NUM_EVENT_BUFFERS; i++)
+		list_add_tail(&priv->event_array[i].list, &priv->event_free_list);
+
+out:
+	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
+	return ret;
+}
+
 static int lbs_init_adapter(struct lbs_private *priv)
 {
 	size_t bufsize;
@@ -1046,7 +1063,16 @@ static int lbs_init_adapter(struct lbs_p
 	/* Allocate the command buffers */
 	if (lbs_allocate_cmd_buffer(priv)) {
 		lbs_pr_err("Out of memory allocating command buffers\n");
-		ret = -1;
+		ret = -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&priv->event_list);
+	INIT_LIST_HEAD(&priv->event_free_list);
+
+	/* Allocate the event buffers */
+	if (lbs_allocate_event_buffer(priv)) {
+		lbs_pr_err("Out of memory allocating event buffers\n");
+		ret = -ENOMEM;
 	}
 
 out:
@@ -1060,6 +1086,7 @@ static void lbs_free_adapter(struct lbs_
 	lbs_deb_enter(LBS_DEB_MAIN);
 
 	lbs_free_cmd_buffer(priv);
+	kfree(priv->event_array);
 	del_timer(&priv->command_timer);
 	kfree(priv->networks);
 	priv->networks = NULL;
@@ -1434,27 +1461,44 @@ out:
 	return ret;
 }
 
-/**
- *  @brief This function handles the interrupt. it will change PS
- *  state if applicable. it will wake up main_thread to handle
- *  the interrupt event as well.
- *
- *  @param dev     A pointer to net_device structure
- *  @return 	   n/a
- */
-void lbs_interrupt(struct lbs_private *priv)
+struct lbs_event *lbs_get_free_event(struct lbs_private *priv)
 {
+	struct lbs_event *event = NULL;
+	unsigned long flags;
+
 	lbs_deb_enter(LBS_DEB_THREAD);
 
-	lbs_deb_thread("lbs_interrupt: intcounter=%d\n", priv->intcounter);
-	priv->intcounter++;
+	spin_lock_irqsave(&priv->driver_lock, flags);
+	if (list_empty(&priv->event_free_list)) {
+		lbs_pr_alert("no free events");
+		goto out;
+	}
+
+	event = list_first_entry(&priv->event_free_list, struct lbs_event, list);
+	list_del(&event->list);
+
+out:
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
+	lbs_deb_leave_args(LBS_DEB_THREAD, "event %p", event);
+	return event;
+}
+EXPORT_SYMBOL_GPL(lbs_get_free_event);
+
+
+void lbs_handle_event(struct lbs_private *priv, struct lbs_event *event)
+{
+	unsigned long flags;
+
+	list_add_tail(&event->list, &priv->event_list);
+	spin_lock_irqsave(&priv->driver_lock, flags);
 	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
-	wake_up_interruptible(&priv->waitq);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
+	wake_up_interruptible(&priv->waitq);
 	lbs_deb_leave(LBS_DEB_THREAD);
 }
-EXPORT_SYMBOL_GPL(lbs_interrupt);
+EXPORT_SYMBOL_GPL(lbs_handle_event);
 
 static int __init lbs_init_module(void)
 {
Index: wireless-testing/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/if_cs.c	2008-03-27 15:42:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/if_cs.c	2008-03-27 15:51:33.000000000 +0100
@@ -83,14 +83,14 @@ static inline unsigned int if_cs_read8(s
 {
 	unsigned int val = ioread8(card->iobase + reg);
 	if (debug_output)
-		printk(KERN_INFO "##inb %08x<%02x\n", reg, val);
+		printk(KERN_INFO "inb %08x<%02x\n", reg, val);
 	return val;
 }
 static inline unsigned int if_cs_read16(struct if_cs_card *card, uint reg)
 {
 	unsigned int val = ioread16(card->iobase + reg);
 	if (debug_output)
-		printk(KERN_INFO "##inw %08x<%04x\n", reg, val);
+		printk(KERN_INFO "inw %08x<%04x\n", reg, val);
 	return val;
 }
 static inline void if_cs_read16_rep(
@@ -100,7 +100,7 @@ static inline void if_cs_read16_rep(
 	unsigned long count)
 {
 	if (debug_output)
-		printk(KERN_INFO "##insw %08x<(0x%lx words)\n",
+		printk(KERN_INFO "insw %08x<(0x%lx words)\n",
 			reg, count);
 	ioread16_rep(card->iobase + reg, buf, count);
 }
@@ -108,14 +108,14 @@ static inline void if_cs_read16_rep(
 static inline void if_cs_write8(struct if_cs_card *card, uint reg, u8 val)
 {
 	if (debug_output)
-		printk(KERN_INFO "##outb %08x>%02x\n", reg, val);
+		printk(KERN_INFO "outb %08x>%02x\n", reg, val);
 	iowrite8(val, card->iobase + reg);
 }
 
 static inline void if_cs_write16(struct if_cs_card *card, uint reg, u16 val)
 {
 	if (debug_output)
-		printk(KERN_INFO "##outw %08x>%04x\n", reg, val);
+		printk(KERN_INFO "outw %08x>%04x\n", reg, val);
 	iowrite16(val, card->iobase + reg);
 }
 
@@ -126,7 +126,7 @@ static inline void if_cs_write16_rep(
 	unsigned long count)
 {
 	if (debug_output)
-		printk(KERN_INFO "##outsw %08x>(0x%lx words)\n",
+		printk(KERN_INFO "outsw %08x>(0x%lx words)\n",
 			reg, count);
 	iowrite16_rep(card->iobase + reg, buf, count);
 }
@@ -199,17 +199,6 @@ static int if_cs_poll_while_fw_download(
 #define IF_CS_C_S_CARDEVENT		0x0010
 #define IF_CS_C_S_MASK			0x001f
 #define IF_CS_C_S_STATUS_MASK		0x7f00
-/* The following definitions should be the same as the MRVDRV_ ones */
-
-#if MRVDRV_CMD_DNLD_RDY != IF_CS_C_S_CMD_DNLD_RDY
-#error MRVDRV_CMD_DNLD_RDY and IF_CS_C_S_CMD_DNLD_RDY not in sync
-#endif
-#if MRVDRV_CMD_UPLD_RDY != IF_CS_C_S_CMD_UPLD_RDY
-#error MRVDRV_CMD_UPLD_RDY and IF_CS_C_S_CMD_UPLD_RDY not in sync
-#endif
-#if MRVDRV_CARDEVENT != IF_CS_C_S_CARDEVENT
-#error MRVDRV_CARDEVENT and IF_CS_C_S_CARDEVENT not in sync
-#endif
 
 #define IF_CS_C_INT_CAUSE		0x00000022
 #define	IF_CS_C_IC_MASK			0x001f
@@ -226,55 +215,6 @@ static int if_cs_poll_while_fw_download(
 
 
 /********************************************************************/
-/* Interrupts                                                       */
-/********************************************************************/
-
-static inline void if_cs_enable_ints(struct if_cs_card *card)
-{
-	lbs_deb_enter(LBS_DEB_CS);
-	if_cs_write16(card, IF_CS_H_INT_MASK, 0);
-}
-
-static inline void if_cs_disable_ints(struct if_cs_card *card)
-{
-	lbs_deb_enter(LBS_DEB_CS);
-	if_cs_write16(card, IF_CS_H_INT_MASK, IF_CS_H_IM_MASK);
-}
-
-static irqreturn_t if_cs_interrupt(int irq, void *data)
-{
-	struct if_cs_card *card = data;
-	u16 int_cause;
-
-	lbs_deb_enter(LBS_DEB_CS);
-
-	int_cause = if_cs_read16(card, IF_CS_C_INT_CAUSE);
-	if (int_cause == 0x0) {
-		/* Not for us */
-		return IRQ_NONE;
-
-	} else if (int_cause == 0xffff) {
-		/* Read in junk, the card has probably been removed */
-		card->priv->surpriseremoved = 1;
-		return IRQ_HANDLED;
-	} else {
-		if (int_cause & IF_CS_H_IC_TX_OVER)
-			lbs_host_to_card_done(card->priv);
-
-		/* clear interrupt */
-		if_cs_write16(card, IF_CS_C_INT_CAUSE, int_cause & IF_CS_C_IC_MASK);
-	}
-	spin_lock(&card->priv->driver_lock);
-	lbs_interrupt(card->priv);
-	spin_unlock(&card->priv->driver_lock);
-
-	return IRQ_HANDLED;
-}
-
-
-
-
-/********************************************************************/
 /* I/O                                                              */
 /********************************************************************/
 
@@ -351,6 +291,7 @@ static void if_cs_send_data(struct lbs_p
  */
 static int if_cs_receive_cmdres(struct lbs_private *priv, u8 *data, u32 *len)
 {
+	unsigned long flags;
 	int ret = -1;
 	u16 val;
 
@@ -378,6 +319,12 @@ static int if_cs_receive_cmdres(struct l
 	 * bytes */
 	*len -= 8;
 	ret = 0;
+
+	/* Clear this flag again */
+	spin_lock_irqsave(&priv->driver_lock, flags);
+	priv->dnld_sent = DNLD_RES_RECEIVED;
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
+
 out:
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d, len %d", ret, *len);
 	return ret;
@@ -396,11 +343,9 @@ static struct sk_buff *if_cs_receive_dat
 	if (len == 0 || len > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE) {
 		lbs_pr_err("card data buffer has invalid # of bytes (%d)\n", len);
 		priv->stats.rx_dropped++;
-		printk(KERN_INFO "##HS %s:%d TODO\n", __FUNCTION__, __LINE__);
 		goto dat_err;
 	}
 
-	//TODO: skb = dev_alloc_skb(len+ETH_FRAME_LEN+MRVDRV_SNAP_HEADER_LEN+EXTRA_LEN);
 	skb = dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE + 2);
 	if (!skb)
 		goto out;
@@ -425,6 +370,88 @@ out:
 
 
 /********************************************************************/
+/* Interrupts                                                       */
+/********************************************************************/
+
+static inline void if_cs_enable_ints(struct if_cs_card *card)
+{
+	lbs_deb_enter(LBS_DEB_CS);
+	if_cs_write16(card, IF_CS_H_INT_MASK, 0);
+}
+
+static inline void if_cs_disable_ints(struct if_cs_card *card)
+{
+	lbs_deb_enter(LBS_DEB_CS);
+	if_cs_write16(card, IF_CS_H_INT_MASK, IF_CS_H_IM_MASK);
+}
+
+
+static irqreturn_t if_cs_interrupt(int irq, void *data)
+{
+	struct if_cs_card *card = data;
+	struct lbs_private *priv = card->priv;
+	u16 card_int_cause;
+
+	lbs_deb_enter(LBS_DEB_CS);
+
+	card_int_cause = if_cs_read16(card, IF_CS_C_INT_CAUSE);
+	lbs_deb_cs("card_int_cause 0x%04x\n", card_int_cause);
+	if (card_int_cause == 0) {
+		/* Not for us */
+		return IRQ_NONE;
+
+	}
+	if (card_int_cause == 0xffff) {
+		/* Read in junk, the card has probably been removed */
+		card->priv->surpriseremoved = 1;
+		return IRQ_HANDLED;
+	}
+
+	/* TODO: I'm not sure what the best ordering is */
+
+	if (card_int_cause & IF_CS_H_STATUS_RX_OVER) {
+		struct sk_buff *skb;
+		lbs_deb_cs("rx packet\n");
+		skb = if_cs_receive_data(priv);
+		lbs_process_rxed_packet(priv, skb);
+	}
+
+	if (card_int_cause & IF_CS_H_IC_TX_OVER)
+		lbs_host_to_card_done(priv);
+
+	if (card_int_cause & IF_CS_C_S_CMD_UPLD_RDY) {
+		struct lbs_event *event;
+		lbs_deb_cs("cmd upload ready\n");
+		event = lbs_get_free_event(priv);
+		if (event) {
+			if_cs_receive_cmdres(priv, event->data, &event->len);
+			lbs_handle_event(priv, event);
+		}
+	}
+
+	if (card_int_cause & IF_CS_H_IC_HOST_EVENT) {
+		struct lbs_event *event;
+
+		u16 eventcause = if_cs_read16(priv->card, IF_CS_C_STATUS) & IF_CS_C_S_STATUS_MASK;
+		if_cs_write16(priv->card, IF_CS_H_INT_CAUSE, IF_CS_H_IC_HOST_EVENT);
+
+		lbs_deb_cs("eventcause 0x%04x\n", eventcause);
+		event = lbs_get_free_event(priv);
+		if (event) {
+			event->event = eventcause >> 8 & 0xff;
+			lbs_handle_event(priv, event);
+		}
+	}
+
+	if_cs_write16(card, IF_CS_C_INT_CAUSE, card_int_cause & IF_CS_C_IC_MASK);
+
+	return IRQ_HANDLED;
+}
+
+
+
+
+/********************************************************************/
 /* Firmware                                                         */
 /********************************************************************/
 
@@ -547,7 +574,7 @@ static int if_cs_prog_real(struct if_cs_
 		int i;
 		lbs_pr_err("helper firmware doesn't answer\n");
 		for (i = 0; i < 0x50; i += 2)
-			printk(KERN_INFO "## HS %02x: %04x\n",
+			printk(KERN_INFO "##HS %02x: %04x\n",
 				i, if_cs_read16(card, i));
 		goto err_release;
 	}
@@ -642,64 +669,6 @@ static int if_cs_host_to_card(struct lbs
 }
 
 
-static int if_cs_get_int_status(struct lbs_private *priv, u8 *ireg)
-{
-	struct if_cs_card *card = (struct if_cs_card *)priv->card;
-	int ret = 0;
-	u16 int_cause;
-	*ireg = 0;
-
-	lbs_deb_enter(LBS_DEB_CS);
-
-	if (priv->surpriseremoved)
-		goto out;
-
-	int_cause = if_cs_read16(card, IF_CS_C_INT_CAUSE) & IF_CS_C_IC_MASK;
-	if_cs_write16(card, IF_CS_C_INT_CAUSE, int_cause);
-
-	*ireg = if_cs_read16(card, IF_CS_C_STATUS) & IF_CS_C_S_MASK;
-
-	if (!*ireg)
-		goto sbi_get_int_status_exit;
-
-sbi_get_int_status_exit:
-
-	/* is there a data packet for us? */
-	if (*ireg & IF_CS_C_S_RX_UPLD_RDY) {
-		struct sk_buff *skb = if_cs_receive_data(priv);
-		lbs_process_rxed_packet(priv, skb);
-		*ireg &= ~IF_CS_C_S_RX_UPLD_RDY;
-	}
-
-	if (*ireg & IF_CS_C_S_TX_DNLD_RDY) {
-		priv->dnld_sent = DNLD_RES_RECEIVED;
-	}
-
-	/* Card has a command result for us */
-	if (*ireg & IF_CS_C_S_CMD_UPLD_RDY) {
-		ret = if_cs_receive_cmdres(priv, priv->upld_buf, &priv->upld_len);
-		if (ret < 0)
-			lbs_pr_err("could not receive cmd from card\n");
-	}
-
-out:
-	lbs_deb_leave_args(LBS_DEB_CS, "ret %d, ireg 0x%x, hisregcpy 0x%x", ret, *ireg, priv->hisregcpy);
-	return ret;
-}
-
-
-static int if_cs_read_event_cause(struct lbs_private *priv)
-{
-	lbs_deb_enter(LBS_DEB_CS);
-
-	priv->eventcause = (if_cs_read16(priv->card, IF_CS_C_STATUS) & IF_CS_C_S_STATUS_MASK) >> 5;
-	if_cs_write16(priv->card, IF_CS_H_INT_CAUSE, IF_CS_H_IC_HOST_EVENT);
-
-	return 0;
-}
-
-
-
 /********************************************************************/
 /* Card Services                                                    */
 /********************************************************************/
@@ -852,13 +821,10 @@ static int if_cs_probe(struct pcmcia_dev
 		goto out2;
 	}
 
-	/* Store pointers to our call-back functions */
+	/* Finish setting up fields in lbs_private */
 	card->priv = priv;
 	priv->card = card;
-	priv->hw_host_to_card     = if_cs_host_to_card;
-	priv->hw_get_int_status   = if_cs_get_int_status;
-	priv->hw_read_event_cause = if_cs_read_event_cause;
-
+	priv->hw_host_to_card = if_cs_host_to_card;
 	priv->fw_ready = 1;
 
 	/* Now actually get the IRQ */
Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-27 15:42:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-27 15:44:34.000000000 +0100
@@ -1818,7 +1818,11 @@ static void lbs_send_confirmsleep(struct
 		lbs_pr_alert("confirm_sleep failed\n");
 	} else {
 		spin_lock_irqsave(&priv->driver_lock, flags);
+#ifdef TODO
+/* TODO: As there is no intcounter anymore, I'll have to set PS_STATE_SLEEP always.
+ * But I'm not sure if this is right. */
 		if (!priv->intcounter)
+#endif
 			priv->psstate = PS_STATE_SLEEP;
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 	}
@@ -1887,10 +1891,13 @@ void lbs_ps_confirm_sleep(struct lbs_pri
 		allowed = 0;
 		lbs_deb_host("cur_cmd was set\n");
 	}
+#ifdef TODO
+/* TODO: this also needs more checking */
 	if (priv->intcounter > 0) {
 		allowed = 0;
 		lbs_deb_host("intcounter %d\n", priv->intcounter);
 	}
+#endif
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	if (allowed) {
Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-03-27 15:42:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-03-27 15:44:34.000000000 +0100
@@ -384,7 +384,7 @@ static inline int handle_cmd_response(st
 	return ret;
 }
 
-int lbs_process_rx_command(struct lbs_private *priv)
+int lbs_process_rx_command(struct lbs_private *priv, u8 *data, u32 len)
 {
 	uint16_t respcmd, curcmd;
 	struct cmd_header *resp;
@@ -404,14 +404,14 @@ int lbs_process_rx_command(struct lbs_pr
 		goto done;
 	}
 
-	resp = (void *)priv->upld_buf;
+	resp = (void *)data;
 	curcmd = le16_to_cpu(priv->cur_cmd->cmdbuf->command);
 	respcmd = le16_to_cpu(resp->command);
 	result = le16_to_cpu(resp->result);
 
 	lbs_deb_cmd("CMD_RESP: response 0x%04x, seq %d, size %d\n",
-		     respcmd, le16_to_cpu(resp->seqnum), priv->upld_len);
-	lbs_deb_hex(LBS_DEB_CMD, "CMD_RESP", (void *) resp, priv->upld_len);
+		     respcmd, le16_to_cpu(resp->seqnum), len);
+	lbs_deb_hex(LBS_DEB_CMD, "CMD_RESP", (void *) resp, len);
 
 	if (resp->seqnum != priv->cur_cmd->cmdbuf->seqnum) {
 		lbs_pr_info("Received CMD_RESP with invalid sequence %d (expected %d)\n",
@@ -569,17 +569,12 @@ static int lbs_send_confirmwake(struct l
 	return ret;
 }
 
-int lbs_process_event(struct lbs_private *priv)
+int lbs_process_event(struct lbs_private *priv, u32 eventcause)
 {
 	int ret = 0;
-	u32 eventcause;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	spin_lock_irq(&priv->driver_lock);
-	eventcause = priv->eventcause >> SBI_EVENT_CAUSE_SHIFT;
-	spin_unlock_irq(&priv->driver_lock);
-
 	switch (eventcause) {
 	case MACREG_INT_CODE_LINK_SENSED:
 		lbs_deb_cmd("EVENT: link sensed\n");
@@ -700,10 +695,6 @@ int lbs_process_event(struct lbs_private
 		break;
 	}
 
-	spin_lock_irq(&priv->driver_lock);
-	priv->eventcause = 0;
-	spin_unlock_irq(&priv->driver_lock);
-
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
 }
Index: wireless-testing/drivers/net/wireless/libertas/tx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/tx.c	2008-03-27 15:42:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/tx.c	2008-03-27 15:44:34.000000000 +0100
@@ -182,15 +182,19 @@ int lbs_hard_start_xmit(struct sk_buff *
 void lbs_send_tx_feedback(struct lbs_private *priv)
 {
 	struct tx_radiotap_hdr *radiotap_hdr;
+/* TODO: Do we really need to expose the hardware eventcause bits into the radiotap header? */
+#ifdef TODO
 	u32 status = priv->eventcause;
 	int txfail;
 	int try_count;
+#endif
 
 	if (!priv->monitormode || priv->currenttxskb == NULL)
 		return;
 
 	radiotap_hdr = (struct tx_radiotap_hdr *)priv->currenttxskb->data;
 
+#ifdef TODO
 	txfail = (status >> 24);
 
 #if 0
@@ -203,7 +207,7 @@ void lbs_send_tx_feedback(struct lbs_pri
 	try_count = (status >> 16) & 0xff;
 	radiotap_hdr->data_retries = (try_count) ?
 	    (1 + priv->txretrycount - try_count) : 0;
-
+#endif
 
 	priv->currenttxskb->protocol = eth_type_trans(priv->currenttxskb,
 						      priv->rtap_net_dev);
Index: wireless-testing/drivers/net/wireless/libertas/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/debugfs.c	2008-03-27 15:42:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/debugfs.c	2008-03-27 15:44:34.000000000 +0100
@@ -824,7 +824,6 @@ struct debug_data {
 /* To debug any member of struct lbs_private, simply add one line here.
  */
 static struct debug_data items[] = {
-	{"intcounter", item_size(intcounter), item_addr(intcounter)},
 	{"psmode", item_size(psmode), item_addr(psmode)},
 	{"psstate", item_size(psstate), item_addr(psstate)},
 };
