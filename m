Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20948 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYDAMxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:53:49 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [RFC] libertas: convert libertas driver to use an event/cmdresp queue
Date: Tue, 1 Apr 2008 14:50:43 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200803271700.58477.hs4233@mail.mn-solutions.de> <1206722403.3392.9.camel@localhost.localdomain>
In-Reply-To: <1206722403.3392.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804011450.43967.hs4233@mail.mn-solutions.de> (sfid-20080401_135355_252465_CD8AE132)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


[RFC] libertas: convert libertas driver to use an event/cmdresp queue

This patch (co-developed by Dan Williams and Holger Schurig) uses a kfifo
object for events and a swapping buffer scheme for the command response to
preserve the zero-copy semantics of the CF driver and keep memory usage low. 
The main thread should only ever touch the buffer indexed by priv->resp_idx,
while the interface code is free to write to the second buffer, then swap
priv->resp_idx under the driver spinlock.  The firmware specs only permit
one in-flight command, so there will only ever be one command response to
process at a time.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

Dan, I hope it's OK to do ping-ponging of the signed-off-by line. Actually,
we'd need a

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>, Dan Williams <dcbw@redhat.com>

but I doubt that this is allowed :-)



The patch has been made (almost) checkpatch.pl clean, just one
silly 80 lines violation which doesn't make sense to convert.
I've also checked with

   make modules SUBDIRS=drivers/net/wireless/libertas C=2 CHECKFLAGS="-D__CHECK_ENDIAN__"

the ISR in if_cs.c has been changed again to be more like the old
if_cs_get_int_status().


Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-04-01 10:44:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-04-01 12:37:04.000000000 +0200
@@ -4,6 +4,7 @@
   */
 
 #include <net/iw_handler.h>
+#include <linux/kfifo.h>
 #include "host.h"
 #include "hostcmd.h"
 #include "decl.h"
@@ -1826,15 +1827,20 @@ static void lbs_send_confirmsleep(struct
 
 	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) &confirm_sleep,
 		sizeof(confirm_sleep));
-
 	if (ret) {
 		lbs_pr_alert("confirm_sleep failed\n");
-	} else {
-		spin_lock_irqsave(&priv->driver_lock, flags);
-		if (!priv->intcounter)
-			priv->psstate = PS_STATE_SLEEP;
-		spin_unlock_irqrestore(&priv->driver_lock, flags);
+		goto out;
 	}
+
+	spin_lock_irqsave(&priv->driver_lock, flags);
+
+	/* If nothing to do, go back to sleep (?) */
+	if (!__kfifo_len(priv->event_fifo) && !priv->resp_len[priv->resp_idx])
+		priv->psstate = PS_STATE_SLEEP;
+
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
+
+out:
 	lbs_deb_leave(LBS_DEB_HOST);
 }
 
@@ -1896,13 +1902,16 @@ void lbs_ps_confirm_sleep(struct lbs_pri
 	}
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
+	/* In-progress command? */
 	if (priv->cur_cmd) {
 		allowed = 0;
 		lbs_deb_host("cur_cmd was set\n");
 	}
-	if (priv->intcounter > 0) {
+
+	/* Pending events or command responses? */
+	if (__kfifo_len(priv->event_fifo) || priv->resp_len[priv->resp_idx]) {
 		allowed = 0;
-		lbs_deb_host("intcounter %d\n", priv->intcounter);
+		lbs_deb_host("pending events or command responses\n");
 	}
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-04-01 10:44:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-04-01 10:44:49.000000000 +0200
@@ -341,7 +341,7 @@ static inline int handle_cmd_response(st
 	return ret;
 }
 
-int lbs_process_rx_command(struct lbs_private *priv)
+int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len)
 {
 	uint16_t respcmd, curcmd;
 	struct cmd_header *resp;
@@ -361,14 +361,14 @@ int lbs_process_rx_command(struct lbs_pr
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
@@ -526,18 +526,13 @@ static int lbs_send_confirmwake(struct l
 	return ret;
 }
 
-int lbs_process_event(struct lbs_private *priv)
+int lbs_process_event(struct lbs_private *priv, u32 event)
 {
 	int ret = 0;
-	u32 eventcause;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	spin_lock_irq(&priv->driver_lock);
-	eventcause = priv->eventcause >> SBI_EVENT_CAUSE_SHIFT;
-	spin_unlock_irq(&priv->driver_lock);
-
-	switch (eventcause) {
+	switch (event) {
 	case MACREG_INT_CODE_LINK_SENSED:
 		lbs_deb_cmd("EVENT: link sensed\n");
 		break;
@@ -653,14 +648,10 @@ int lbs_process_event(struct lbs_private
 		break;
 
 	default:
-		lbs_pr_alert("EVENT: unknown event id %d\n", eventcause);
+		lbs_pr_alert("EVENT: unknown event id %d\n", event);
 		break;
 	}
 
-	spin_lock_irq(&priv->driver_lock);
-	priv->eventcause = 0;
-	spin_unlock_irq(&priv->driver_lock);
-
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
 }
Index: wireless-testing/drivers/net/wireless/libertas/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/debugfs.c	2008-04-01 10:43:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/debugfs.c	2008-04-01 10:44:49.000000000 +0200
@@ -824,7 +824,6 @@ struct debug_data {
 /* To debug any member of struct lbs_private, simply add one line here.
  */
 static struct debug_data items[] = {
-	{"intcounter", item_size(intcounter), item_addr(intcounter)},
 	{"psmode", item_size(psmode), item_addr(psmode)},
 	{"psstate", item_size(psstate), item_addr(psstate)},
 };
Index: wireless-testing/drivers/net/wireless/libertas/decl.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/decl.h	2008-04-01 10:44:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/decl.h	2008-04-01 10:44:49.000000000 +0200
@@ -19,7 +19,7 @@ struct cmd_ds_command;
 
 void lbs_set_mac_control(struct lbs_private *priv);
 
-void lbs_send_tx_feedback(struct lbs_private *priv);
+void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count);
 
 int lbs_free_cmd_buffer(struct lbs_private *priv);
 
@@ -30,8 +30,10 @@ int lbs_prepare_and_send_command(struct 
 
 int lbs_allocate_cmd_buffer(struct lbs_private *priv);
 int lbs_execute_next_command(struct lbs_private *priv);
-int lbs_process_event(struct lbs_private *priv);
-void lbs_interrupt(struct lbs_private *priv);
+int lbs_process_event(struct lbs_private *priv, u32 event);
+void lbs_queue_event(struct lbs_private *priv, u32 event);
+void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx);
+
 int lbs_set_radio_control(struct lbs_private *priv);
 u32 lbs_fw_index_to_data_rate(u8 index);
 u8 lbs_data_rate_to_fw_index(u32 rate);
@@ -40,7 +42,7 @@ void lbs_get_fwversion(struct lbs_privat
 	int maxlen);
 
 /** The proc fs interface */
-int lbs_process_rx_command(struct lbs_private *priv);
+int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len);
 void lbs_complete_command(struct lbs_private *priv, struct cmd_ctrl_node *cmd,
 			  int result);
 int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev);
Index: wireless-testing/drivers/net/wireless/libertas/defs.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/defs.h	2008-04-01 10:43:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/defs.h	2008-04-01 10:44:49.000000000 +0200
@@ -177,8 +177,6 @@ static inline void lbs_deb_hex(unsigned 
 #define MRVDRV_CMD_UPLD_RDY		0x0008
 #define MRVDRV_CARDEVENT		0x0010
 
-#define SBI_EVENT_CAUSE_SHIFT		3
-
 /** TxPD status */
 
 /*	Station firmware use TxPD status field to report final Tx transmit
Index: wireless-testing/drivers/net/wireless/libertas/dev.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/dev.h	2008-04-01 10:44:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/dev.h	2008-04-01 10:44:49.000000000 +0200
@@ -128,10 +128,6 @@ struct lbs_private {
 	u32 bbp_offset;
 	u32 rf_offset;
 
-	/** Upload length */
-	u32 upld_len;
-	/* Upload buffer */
-	u8 upld_buf[LBS_UPLD_SIZE];
 	/* Download sent:
 	   bit0 1/0=data_sent/data_tx_done,
 	   bit1 1/0=cmd_sent/cmd_tx_done,
@@ -154,21 +150,16 @@ struct lbs_private {
 
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
 
@@ -180,7 +171,6 @@ struct lbs_private {
 
 	/** command-related variables */
 	u16 seqnum;
-	/* protected by big lock */
 
 	struct cmd_ctrl_node *cmd_array;
 	/** Current command */
@@ -193,12 +183,17 @@ struct lbs_private {
 	struct list_head cmdpendingq;
 
 	wait_queue_head_t cmd_pending;
-	/* command related variables protected by priv->driver_lock */
 
-	/** Async and Sync Event variables */
-	u32 intcounter;
-	u32 eventcause;
-	u8 nodename[16];	/* nickname */
+	/* Command responses sent from the hardware to the driver */
+	u8 resp_idx;
+	u8 resp_buf[2][LBS_UPLD_SIZE];
+	u32 resp_len[2];
+
+	/* Events sent from hardware to driver */
+	struct kfifo *event_fifo;
+
+	/* nickname */
+	u8 nodename[16];
 
 	/** spin locks */
 	spinlock_t driver_lock;
@@ -208,8 +203,6 @@ struct lbs_private {
 	int nr_retries;
 	int cmd_timed_out;
 
-	u8 hisregcpy;
-
 	/** current ssid/bssid related parameters*/
 	struct current_bss_params curbssparams;
 
Index: wireless-testing/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/if_cs.c	2008-04-01 10:43:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/if_cs.c	2008-04-01 12:37:30.000000000 +0200
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
@@ -425,6 +370,96 @@ out:
 
 
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
+	u16 cause;
+
+	lbs_deb_enter(LBS_DEB_CS);
+
+	cause = if_cs_read16(card, IF_CS_C_INT_CAUSE);
+	if_cs_write16(card, IF_CS_C_INT_CAUSE, cause & IF_CS_C_IC_MASK);
+
+	lbs_deb_cs("cause 0x%04x\n", cause);
+	if (cause == 0) {
+		/* Not for us */
+		return IRQ_NONE;
+	}
+
+	if (cause == 0xffff) {
+		/* Read in junk, the card has probably been removed */
+		card->priv->surpriseremoved = 1;
+		return IRQ_HANDLED;
+	}
+
+	/* TODO: I'm not sure what the best ordering is */
+
+	cause = if_cs_read16(card, IF_CS_C_STATUS) & IF_CS_C_S_MASK;
+
+	if (cause & IF_CS_C_S_RX_UPLD_RDY) {
+		struct sk_buff *skb;
+		lbs_deb_cs("rx packet\n");
+		skb = if_cs_receive_data(priv);
+		if (skb)
+			lbs_process_rxed_packet(priv, skb);
+	}
+
+	if (cause & IF_CS_H_IC_TX_OVER) {
+		lbs_deb_cs("tx over\n");
+		lbs_host_to_card_done(priv);
+	}
+
+	if (cause & IF_CS_C_S_CMD_UPLD_RDY) {
+		unsigned long flags;
+		u8 i;
+
+		lbs_deb_cs("cmd upload ready\n");
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		i = (priv->resp_idx == 0) ? 1 : 0;
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
+
+		BUG_ON(priv->resp_len[i]);
+		if_cs_receive_cmdres(priv, priv->resp_buf[i],
+			&priv->resp_len[i]);
+
+		spin_lock_irqsave(&priv->driver_lock, flags);
+		lbs_notify_command_response(priv, i);
+		spin_unlock_irqrestore(&priv->driver_lock, flags);
+	}
+
+	if (cause & IF_CS_H_IC_HOST_EVENT) {
+		u16 event = if_cs_read16(priv->card, IF_CS_C_STATUS)
+			& IF_CS_C_S_STATUS_MASK;
+		if_cs_write16(priv->card, IF_CS_H_INT_CAUSE,
+			IF_CS_H_IC_HOST_EVENT);
+		lbs_deb_cs("eventcause 0x%04x\n", event);
+		lbs_queue_event(priv, event >> 8 & 0xff);
+	}
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
 
@@ -476,8 +511,6 @@ static int if_cs_prog_helper(struct if_c
 
 		if (remain < count)
 			count = remain;
-		/* printk(KERN_INFO "//HS %d loading %d of %d bytes\n",
-			__LINE__, sent, fw->size); */
 
 		/* "write the number of bytes to be sent to the I/O Command
 		 * write length register" */
@@ -544,18 +577,12 @@ static int if_cs_prog_real(struct if_cs_
 
 	ret = if_cs_poll_while_fw_download(card, IF_CS_C_SQ_READ_LOW, IF_CS_C_SQ_HELPER_OK);
 	if (ret < 0) {
-		int i;
 		lbs_pr_err("helper firmware doesn't answer\n");
-		for (i = 0; i < 0x50; i += 2)
-			printk(KERN_INFO "## HS %02x: %04x\n",
-				i, if_cs_read16(card, i));
 		goto err_release;
 	}
 
 	for (sent = 0; sent < fw->size; sent += len) {
 		len = if_cs_read16(card, IF_CS_C_SQ_READ_LOW);
-		/* printk(KERN_INFO "//HS %d loading %d of %d bytes\n",
-			__LINE__, sent, fw->size); */
 		if (len & 1) {
 			retry++;
 			lbs_pr_info("odd, need to retry this firmware block\n");
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
Index: wireless-testing/drivers/net/wireless/libertas/if_sdio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/if_sdio.c	2008-02-26 15:24:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/if_sdio.c	2008-04-01 10:44:49.000000000 +0200
@@ -91,8 +91,6 @@ struct if_sdio_card {
 	const char		*firmware;
 
 	u8			buffer[65536];
-	u8			int_cause;
-	u32			event;
 
 	spinlock_t		lock;
 	struct if_sdio_packet	*packets;
@@ -129,13 +127,13 @@ static u16 if_sdio_read_scratch(struct i
 static int if_sdio_handle_cmd(struct if_sdio_card *card,
 		u8 *buffer, unsigned size)
 {
+	struct lbs_private *priv = card->priv;
 	int ret;
 	unsigned long flags;
+	u8 i;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
-	spin_lock_irqsave(&card->priv->driver_lock, flags);
-
 	if (size > LBS_CMD_BUFFER_SIZE) {
 		lbs_deb_sdio("response packet too large (%d bytes)\n",
 			(int)size);
@@ -143,20 +141,20 @@ static int if_sdio_handle_cmd(struct if_
 		goto out;
 	}
 
-	memcpy(card->priv->upld_buf, buffer, size);
-	card->priv->upld_len = size;
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
-	card->int_cause |= MRVDRV_CMD_UPLD_RDY;
+	i = (priv->resp_idx == 0) ? 1 : 0;
+	BUG_ON(priv->resp_len[i]);
+	priv->resp_len[i] = size;
+	memcpy(priv->resp_buf[i], buffer, size);
+	lbs_notify_command_response(priv, i);
 
-	lbs_interrupt(card->priv);
+	spin_unlock_irqrestore(&card->priv->driver_lock, flags);
 
 	ret = 0;
 
 out:
-	spin_unlock_irqrestore(&card->priv->driver_lock, flags);
-
 	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
-
 	return ret;
 }
 
@@ -202,7 +200,6 @@ static int if_sdio_handle_event(struct i
 		u8 *buffer, unsigned size)
 {
 	int ret;
-	unsigned long flags;
 	u32 event;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
@@ -222,18 +219,9 @@ static int if_sdio_handle_event(struct i
 		event |= buffer[2] << 16;
 		event |= buffer[1] << 8;
 		event |= buffer[0] << 0;
-		event <<= SBI_EVENT_CAUSE_SHIFT;
 	}
 
-	spin_lock_irqsave(&card->priv->driver_lock, flags);
-
-	card->event = event;
-	card->int_cause |= MRVDRV_CARDEVENT;
-
-	lbs_interrupt(card->priv);
-
-	spin_unlock_irqrestore(&card->priv->driver_lock, flags);
-
+	lbs_queue_event(card->priv, event & 0xFF);
 	ret = 0;
 
 out:
@@ -770,37 +758,6 @@ out:
 	return ret;
 }
 
-static int if_sdio_get_int_status(struct lbs_private *priv, u8 *ireg)
-{
-	struct if_sdio_card *card;
-
-	lbs_deb_enter(LBS_DEB_SDIO);
-
-	card = priv->card;
-
-	*ireg = card->int_cause;
-	card->int_cause = 0;
-
-	lbs_deb_leave(LBS_DEB_SDIO);
-
-	return 0;
-}
-
-static int if_sdio_read_event_cause(struct lbs_private *priv)
-{
-	struct if_sdio_card *card;
-
-	lbs_deb_enter(LBS_DEB_SDIO);
-
-	card = priv->card;
-
-	priv->eventcause = card->event;
-
-	lbs_deb_leave(LBS_DEB_SDIO);
-
-	return 0;
-}
-
 /*******************************************************************/
 /* SDIO callbacks                                                  */
 /*******************************************************************/
@@ -953,8 +910,6 @@ static int if_sdio_probe(struct sdio_fun
 
 	priv->card = card;
 	priv->hw_host_to_card = if_sdio_host_to_card;
-	priv->hw_get_int_status = if_sdio_get_int_status;
-	priv->hw_read_event_cause = if_sdio_read_event_cause;
 
 	priv->fw_ready = 1;
 
Index: wireless-testing/drivers/net/wireless/libertas/if_usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/if_usb.c	2008-03-19 13:16:52.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/if_usb.c	2008-04-01 12:36:37.000000000 +0200
@@ -38,8 +38,6 @@ static void if_usb_receive_fwload(struct
 static int if_usb_prog_firmware(struct if_usb_card *cardp);
 static int if_usb_host_to_card(struct lbs_private *priv, uint8_t type,
 			       uint8_t *payload, uint16_t nb);
-static int if_usb_get_int_status(struct lbs_private *priv, uint8_t *);
-static int if_usb_read_event_cause(struct lbs_private *);
 static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
 			uint16_t nb);
 static void if_usb_free(struct if_usb_card *cardp);
@@ -233,8 +231,6 @@ static int if_usb_probe(struct usb_inter
 	cardp->priv->fw_ready = 1;
 
 	priv->hw_host_to_card = if_usb_host_to_card;
-	priv->hw_get_int_status = if_usb_get_int_status;
-	priv->hw_read_event_cause = if_usb_read_event_cause;
 	cardp->boot2_version = udev->descriptor.bcdDevice;
 
 	if_usb_submit_rx_urb(cardp);
@@ -582,7 +578,6 @@ static inline void process_cmdtypedata(i
 	skb_pull(skb, MESSAGE_HEADER_LEN);
 
 	lbs_process_rxed_packet(priv, skb);
-	priv->upld_len = (recvlength - MESSAGE_HEADER_LEN);
 }
 
 static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
@@ -590,6 +585,8 @@ static inline void process_cmdrequest(in
 				      struct if_usb_card *cardp,
 				      struct lbs_private *priv)
 {
+	u8 i;
+
 	if (recvlength > LBS_CMD_BUFFER_SIZE) {
 		lbs_deb_usbd(&cardp->udev->dev,
 			     "The receive buffer is too large\n");
@@ -601,12 +598,15 @@ static inline void process_cmdrequest(in
 		BUG();
 
 	spin_lock(&priv->driver_lock);
-	cardp->usb_int_cause |= MRVDRV_CMD_UPLD_RDY;
-	priv->upld_len = (recvlength - MESSAGE_HEADER_LEN);
-	memcpy(priv->upld_buf, recvbuff + MESSAGE_HEADER_LEN, priv->upld_len);
 
+	i = (priv->resp_idx == 0) ? 1 : 0;
+	BUG_ON(priv->resp_len[i]);
+	priv->resp_len[i] = (recvlength - MESSAGE_HEADER_LEN);
+	memcpy(priv->resp_buf[i], recvbuff + MESSAGE_HEADER_LEN,
+		priv->resp_len[i]);
 	kfree_skb(skb);
-	lbs_interrupt(priv);
+	lbs_notify_command_response(priv, i);
+
 	spin_unlock(&priv->driver_lock);
 
 	lbs_deb_usbd(&cardp->udev->dev,
@@ -629,6 +629,7 @@ static void if_usb_receive(struct urb *u
 	uint8_t *recvbuff = NULL;
 	uint32_t recvtype = 0;
 	__le32 *pkt = (__le32 *)(skb->data + IPFIELD_ALIGN_OFFSET);
+	uint32_t event;
 
 	lbs_deb_enter(LBS_DEB_USB);
 
@@ -660,26 +661,20 @@ static void if_usb_receive(struct urb *u
 		break;
 
 	case CMD_TYPE_INDICATION:
-		/* Event cause handling */
-		spin_lock(&priv->driver_lock);
+		/* Event handling */
+		event = le32_to_cpu(pkt[1]);
+		lbs_deb_usbd(&cardp->udev->dev, "**EVENT** 0x%X\n", event);
+		kfree_skb(skb);
 
-		cardp->usb_event_cause = le32_to_cpu(pkt[1]);
+		/* Icky undocumented magic special case */
+		if (event & 0xffff0000) {
+			u32 trycount = (event & 0xffff0000) >> 16;
 
-		lbs_deb_usbd(&cardp->udev->dev,"**EVENT** 0x%X\n",
-			     cardp->usb_event_cause);
+			lbs_send_tx_feedback(priv, trycount);
+		} else
+			lbs_queue_event(priv, event & 0xFF);
+		break;
 
-		/* Icky undocumented magic special case */
-		if (cardp->usb_event_cause & 0xffff0000) {
-			lbs_send_tx_feedback(priv);
-			spin_unlock(&priv->driver_lock);
-			break;
-		}
-		cardp->usb_event_cause <<= 3;
-		cardp->usb_int_cause |= MRVDRV_CARDEVENT;
-		kfree_skb(skb);
-		lbs_interrupt(priv);
-		spin_unlock(&priv->driver_lock);
-		goto rx_exit;
 	default:
 		lbs_deb_usbd(&cardp->udev->dev, "Unknown command type 0x%X\n",
 			     recvtype);
@@ -722,30 +717,6 @@ static int if_usb_host_to_card(struct lb
 	return usb_tx_block(cardp, cardp->ep_out_buf, nb + MESSAGE_HEADER_LEN);
 }
 
-/* called with priv->driver_lock held */
-static int if_usb_get_int_status(struct lbs_private *priv, uint8_t *ireg)
-{
-	struct if_usb_card *cardp = priv->card;
-
-	*ireg = cardp->usb_int_cause;
-	cardp->usb_int_cause = 0;
-
-	lbs_deb_usbd(&cardp->udev->dev, "Int cause is 0x%X\n", *ireg);
-
-	return 0;
-}
-
-static int if_usb_read_event_cause(struct lbs_private *priv)
-{
-	struct if_usb_card *cardp = priv->card;
-
-	priv->eventcause = cardp->usb_event_cause;
-	/* Re-submit rx urb here to avoid event lost issue */
-	if_usb_submit_rx_urb(cardp);
-
-	return 0;
-}
-
 /**
  *  @brief This function issues Boot command to the Boot2 code
  *  @param ivalue   1:Boot from FW by USB-Download
Index: wireless-testing/drivers/net/wireless/libertas/if_usb.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/if_usb.h	2008-02-26 14:39:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/if_usb.h	2008-04-01 10:44:49.000000000 +0200
@@ -46,8 +46,6 @@ struct if_usb_card {
 	struct lbs_private *priv;
 
 	struct sk_buff *rx_skb;
-	uint32_t usb_event_cause;
-	uint8_t usb_int_cause;
 
 	uint8_t ep_in;
 	uint8_t ep_out;
Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-04-01 10:44:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-04-01 12:36:10.000000000 +0200
@@ -10,6 +10,7 @@
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
 #include <linux/kthread.h>
+#include <linux/kfifo.h>
 
 #include <net/iw_handler.h>
 #include <net/ieee80211.h>
@@ -480,10 +481,9 @@ static void lbs_tx_timeout(struct net_de
 
 	dev->trans_start = jiffies;
 
-	if (priv->currenttxskb) {
-		priv->eventcause = 0x01000000;
-		lbs_send_tx_feedback(priv);
-	}
+	if (priv->currenttxskb)
+		lbs_send_tx_feedback(priv, 0);
+
 	/* XX: Shouldn't we also call into the hw-specific driver
 	   to kick it somehow? */
 	lbs_host_to_card_done(priv);
@@ -658,7 +658,6 @@ static int lbs_thread(void *data)
 	struct net_device *dev = data;
 	struct lbs_private *priv = dev->priv;
 	wait_queue_t wait;
-	u8 ireg = 0;
 
 	lbs_deb_enter(LBS_DEB_THREAD);
 
@@ -666,9 +665,10 @@ static int lbs_thread(void *data)
 
 	for (;;) {
 		int shouldsleep;
+		u8 resp_idx;
 
-		lbs_deb_thread( "main-thread 111: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
-				priv->intcounter, priv->currenttxskb, priv->dnld_sent);
+		lbs_deb_thread("1: currenttxskb %p, dnld_sent %d\n",
+				priv->currenttxskb, priv->dnld_sent);
 
 		add_wait_queue(&priv->waitq, &wait);
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -680,8 +680,6 @@ static int lbs_thread(void *data)
 			shouldsleep = 1;	/* We need to wait until we're _told_ to die */
 		else if (priv->psstate == PS_STATE_SLEEP)
 			shouldsleep = 1;	/* Sleep mode. Nothing we can do till it wakes */
-		else if (priv->intcounter)
-			shouldsleep = 0;	/* Interrupt pending. Deal with it now */
 		else if (priv->cmd_timed_out)
 			shouldsleep = 0;	/* Command timed out. Recover */
 		else if (!priv->fw_ready)
@@ -694,29 +692,34 @@ static int lbs_thread(void *data)
 			shouldsleep = 1;	/* Can't send a command; one already running */
 		else if (!list_empty(&priv->cmdpendingq))
 			shouldsleep = 0;	/* We have a command to send */
+		else if (__kfifo_len(priv->event_fifo))
+			shouldsleep = 0;	/* We have an event to process */
+		else if (priv->resp_len[priv->resp_idx])
+			shouldsleep = 0;	/* We have a command response */
 		else
 			shouldsleep = 1;	/* No command */
 
 		if (shouldsleep) {
-			lbs_deb_thread("main-thread sleeping... Conn=%d IntC=%d PS_mode=%d PS_State=%d\n",
-				       priv->connect_status, priv->intcounter,
-				       priv->psmode, priv->psstate);
+			lbs_deb_thread("sleeping, connect_status %d, "
+				"ps_mode %d, ps_state %d\n",
+				priv->connect_status,
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
 
@@ -725,35 +728,23 @@ static int lbs_thread(void *data)
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
+		lbs_deb_thread("4: currenttxskb %p, dnld_sent %d\n",
+		       priv->currenttxskb, priv->dnld_sent);
 
-			priv->hisregcpy &= ~MRVDRV_CMD_UPLD_RDY;
+		spin_lock_irq(&priv->driver_lock);
+		/* Process any pending command response */
+		resp_idx = priv->resp_idx;
+		if (priv->resp_len[resp_idx]) {
 			spin_unlock_irq(&priv->driver_lock);
-			lbs_process_rx_command(priv);
+			lbs_process_command_response(priv,
+				priv->resp_buf[resp_idx],
+				priv->resp_len[resp_idx]);
 			spin_lock_irq(&priv->driver_lock);
+			priv->resp_len[resp_idx] = 0;
 		}
+		spin_unlock_irq(&priv->driver_lock);
 
+		/* command timeout stuff */
 		if (priv->cmd_timed_out && priv->cur_cmd) {
 			struct cmd_ctrl_node *cmdnode = priv->cur_cmd;
 
@@ -774,21 +765,18 @@ static int lbs_thread(void *data)
 		}
 		priv->cmd_timed_out = 0;
 
-		/* Any Card Event */
-		if (priv->hisregcpy & MRVDRV_CARDEVENT) {
-			lbs_deb_thread("main-thread: Card Event Activity\n");
-
-			priv->hisregcpy &= ~MRVDRV_CARDEVENT;
+		/* Process hardware events, e.g. card removed, link lost */
+		spin_lock_irq(&priv->driver_lock);
+		while (__kfifo_len(priv->event_fifo)) {
+			u32 event;
 
-			if (priv->hw_read_event_cause(priv)) {
-				lbs_pr_alert("main-thread: hw_read_event_cause failed\n");
-				spin_unlock_irq(&priv->driver_lock);
-				continue;
-			}
-			spin_unlock_irq(&priv->driver_lock);
-			lbs_process_event(priv);
-		} else
+			__kfifo_get(priv->event_fifo, (unsigned char *) &event,
+				sizeof(event));
 			spin_unlock_irq(&priv->driver_lock);
+			lbs_process_event(priv, event);
+			spin_lock_irq(&priv->driver_lock);
+		}
+		spin_unlock_irq(&priv->driver_lock);
 
 		if (!priv->fw_ready)
 			continue;
@@ -797,8 +785,10 @@ static int lbs_thread(void *data)
 		if (priv->psstate == PS_STATE_PRE_SLEEP &&
 		    !priv->dnld_sent && !priv->cur_cmd) {
 			if (priv->connect_status == LBS_CONNECTED) {
-				lbs_deb_thread("main_thread: PRE_SLEEP--intcounter=%d currenttxskb=%p dnld_sent=%d cur_cmd=%p, confirm now\n",
-					       priv->intcounter, priv->currenttxskb, priv->dnld_sent, priv->cur_cmd);
+				lbs_deb_thread("pre-sleep, currenttxskb %p, "
+					"dnld_sent %d, cur_cmd %p\n",
+					priv->currenttxskb, priv->dnld_sent,
+					priv->cur_cmd);
 
 				lbs_ps_confirm_sleep(priv);
 			} else {
@@ -808,7 +798,8 @@ static int lbs_thread(void *data)
 				 * after firmware fixes it
 				 */
 				priv->psstate = PS_STATE_AWAKE;
-				lbs_pr_alert("main-thread: ignore PS_SleepConfirm in non-connected state\n");
+				lbs_pr_alert("ignore PS_SleepConfirm in "
+					"non-connected state\n");
 			}
 		}
 
@@ -1044,7 +1035,18 @@ static int lbs_init_adapter(struct lbs_p
 	/* Allocate the command buffers */
 	if (lbs_allocate_cmd_buffer(priv)) {
 		lbs_pr_err("Out of memory allocating command buffers\n");
-		ret = -1;
+		ret = -ENOMEM;
+		goto out;
+	}
+	priv->resp_idx = 0;
+	priv->resp_len[0] = priv->resp_len[1] = 0;
+
+	/* Create the event FIFO */
+	priv->event_fifo = kfifo_alloc(sizeof(u32) * 16, GFP_KERNEL, NULL);
+	if (IS_ERR(priv->event_fifo)) {
+		lbs_pr_err("Out of memory allocating event FIFO buffer\n");
+		ret = -ENOMEM;
+		goto out;
 	}
 
 out:
@@ -1058,6 +1060,8 @@ static void lbs_free_adapter(struct lbs_
 	lbs_deb_enter(LBS_DEB_MAIN);
 
 	lbs_free_cmd_buffer(priv);
+	if (priv->event_fifo)
+		kfifo_free(priv->event_fifo);
 	del_timer(&priv->command_timer);
 	kfree(priv->networks);
 	priv->networks = NULL;
@@ -1432,27 +1436,41 @@ out:
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
+void lbs_queue_event(struct lbs_private *priv, u32 event)
 {
+	unsigned long flags;
+
 	lbs_deb_enter(LBS_DEB_THREAD);
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
-	lbs_deb_thread("lbs_interrupt: intcounter=%d\n", priv->intcounter);
-	priv->intcounter++;
 	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
+
+	__kfifo_put(priv->event_fifo, (unsigned char *) &event, sizeof(u32));
+
 	wake_up_interruptible(&priv->waitq);
 
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 	lbs_deb_leave(LBS_DEB_THREAD);
 }
-EXPORT_SYMBOL_GPL(lbs_interrupt);
+EXPORT_SYMBOL_GPL(lbs_queue_event);
+
+void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx)
+{
+	lbs_deb_enter(LBS_DEB_THREAD);
+
+	if (priv->psstate == PS_STATE_SLEEP)
+		priv->psstate = PS_STATE_AWAKE;
+
+	/* Swap buffers by flipping the response index */
+	BUG_ON(resp_idx > 1);
+	priv->resp_idx = resp_idx;
+
+	wake_up_interruptible(&priv->waitq);
+
+	lbs_deb_leave(LBS_DEB_THREAD);
+}
+EXPORT_SYMBOL_GPL(lbs_notify_command_response);
 
 static int __init lbs_init_module(void)
 {
Index: wireless-testing/drivers/net/wireless/libertas/rx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/rx.c	2008-04-01 10:44:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/rx.c	2008-04-01 12:33:26.000000000 +0200
@@ -52,14 +52,14 @@ int lbs_process_rxed_packet(struct lbs_p
 	struct net_device *dev = priv->dev;
 	struct rxpackethdr *p_rx_pkt;
 	struct rxpd *p_rx_pd;
-
 	int hdrchop;
 	struct ethhdr *p_ethhdr;
-
 	const u8 rfc1042_eth_hdr[] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 
 	lbs_deb_enter(LBS_DEB_RX);
 
+	BUG_ON(!skb);
+
 	skb->ip_summed = CHECKSUM_NONE;
 
 	if (priv->monitormode)
Index: wireless-testing/drivers/net/wireless/libertas/tx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/tx.c	2008-04-01 10:43:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/tx.c	2008-04-01 10:44:49.000000000 +0200
@@ -179,31 +179,17 @@ int lbs_hard_start_xmit(struct sk_buff *
  *
  *  @returns void
  */
-void lbs_send_tx_feedback(struct lbs_private *priv)
+void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count)
 {
 	struct tx_radiotap_hdr *radiotap_hdr;
-	u32 status = priv->eventcause;
-	int txfail;
-	int try_count;
 
 	if (!priv->monitormode || priv->currenttxskb == NULL)
 		return;
 
 	radiotap_hdr = (struct tx_radiotap_hdr *)priv->currenttxskb->data;
 
-	txfail = (status >> 24);
-
-#if 0
-	/* The version of roofnet that we've tested does not use this yet
-	 * But it may be used in the future.
-	 */
-	if (txfail)
-		radiotap_hdr->flags &= IEEE80211_RADIOTAP_F_TX_FAIL;
-#endif
-	try_count = (status >> 16) & 0xff;
-	radiotap_hdr->data_retries = (try_count) ?
-	    (1 + priv->txretrycount - try_count) : 0;
-
+	radiotap_hdr->data_retries = try_count ?
+		(1 + priv->txretrycount - try_count) : 0;
 
 	priv->currenttxskb->protocol = eth_type_trans(priv->currenttxskb,
 						      priv->rtap_net_dev);
