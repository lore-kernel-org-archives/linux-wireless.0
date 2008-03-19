Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19706 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbYCSTx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:26 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: misc power saving adjusts
Date: Wed, 19 Mar 2008 14:25:18 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803191425.18653.hs4233@mail.mn-solutions.de> (sfid-20080319_195437_562789_F2549498)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* firmware for the CF card supports power saving
* the driver currenly only accept "iwconfig ethX power on|off", so
  I fixed what the range wext ioctl reports.
* initialize value/flags in lbs_get_power()
* get rid of unused parameter psmode in lbs_ps_confirm_sleep()
* some minor debug output tweaks

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/if_cs.c	2008-03-19 12:42:12.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/if_cs.c	2008-03-19 12:44:06.000000000 +0100
@@ -882,6 +882,9 @@ static int if_cs_probe(struct pcmcia_dev
 		goto out3;
 	}
 
+	/* The firmware for the CF card supports powersave */
+	priv->ps_supported = 1;
+
 	ret = 0;
 	goto out;
 
Index: wireless-testing/drivers/net/wireless/libertas/wext.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/wext.c	2008-03-19 12:42:12.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/wext.c	2008-03-19 12:44:06.000000000 +0100
@@ -656,13 +656,10 @@ static int lbs_get_range(struct net_devi
 	range->num_encoding_sizes = 2;
 	range->max_encoding_tokens = 4;
 
-	range->min_pmp = 1000000;
-	range->max_pmp = 120000000;
-	range->min_pmt = 1000;
-	range->max_pmt = 1000000;
-	range->pmp_flags = IW_POWER_PERIOD;
-	range->pmt_flags = IW_POWER_TIMEOUT;
-	range->pm_capa = IW_POWER_PERIOD | IW_POWER_TIMEOUT | IW_POWER_ALL_R;
+	/*
+ 	 * Right now we support only "iwconfig ethX power on|off"
+	 */
+	range->pm_capa = IW_POWER_ON;
 
 	/*
 	 * Minimum version we recommend
@@ -784,21 +781,14 @@ static int lbs_get_power(struct net_devi
 			  struct iw_param *vwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	int mode;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	mode = priv->psmode;
-
-	if ((vwrq->disabled = (mode == LBS802_11POWERMODECAM))
-	    || priv->connect_status == LBS_DISCONNECTED)
-	{
-		goto out;
-	}
-
 	vwrq->value = 0;
+	vwrq->flags = 0;
+	vwrq->disabled = priv->psmode == LBS802_11POWERMODECAM
+		|| priv->connect_status == LBS_DISCONNECTED;
 
-out:
 	lbs_deb_leave(LBS_DEB_WEXT);
 	return 0;
 }
Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-19 12:42:12.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-19 12:44:06.000000000 +0100
@@ -1940,10 +1940,6 @@ static int sendconfirmsleep(struct lbs_p
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_HOST);
-
-	lbs_deb_host("SEND_SLEEPC_CMD: before download, cmd size %d\n",
-	       size);
-
 	lbs_deb_hex(LBS_DEB_HOST, "sleep confirm command", cmdptr, size);
 
 	ret = priv->hw_host_to_card(priv, MVMS_CMD, cmdptr, size);
@@ -1966,8 +1962,6 @@ static int sendconfirmsleep(struct lbs_p
 			       priv->intcounter);
 		}
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
-
-		lbs_deb_host("SEND_SLEEPC_CMD: sent confirm sleep\n");
 	}
 
 	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
@@ -2019,10 +2013,10 @@ void lbs_ps_wakeup(struct lbs_private *p
  *  @param psmode  	Power Saving mode
  *  @return 	   	n/a
  */
-void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
+void lbs_ps_confirm_sleep(struct lbs_private *priv)
 {
 	unsigned long flags =0;
-	u8 allowed = 1;
+	int allowed = 1;
 
 	lbs_deb_enter(LBS_DEB_HOST);
 
Index: wireless-testing/drivers/net/wireless/libertas/decl.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/decl.h	2008-03-19 12:42:12.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/decl.h	2008-03-19 12:44:06.000000000 +0100
@@ -49,7 +49,7 @@ int lbs_set_regiontable(struct lbs_priva
 int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *);
 
 void lbs_ps_sleep(struct lbs_private *priv, int wait_option);
-void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode);
+void lbs_ps_confirm_sleep(struct lbs_private *priv);
 void lbs_ps_wakeup(struct lbs_private *priv, int wait_option);
 
 struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-03-19 12:42:12.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-03-19 12:44:06.000000000 +0100
@@ -802,7 +802,7 @@ static int lbs_thread(void *data)
 				lbs_deb_thread("main_thread: PRE_SLEEP--intcounter=%d currenttxskb=%p dnld_sent=%d cur_cmd=%p, confirm now\n",
 					       priv->intcounter, priv->currenttxskb, priv->dnld_sent, priv->cur_cmd);
 
-				lbs_ps_confirm_sleep(priv, (u16) priv->psmode);
+				lbs_ps_confirm_sleep(priv);
 			} else {
 				/* workaround for firmware sending
 				 * deauth/linkloss event immediately
Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-03-19 12:42:12.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-03-19 12:44:06.000000000 +0100
@@ -613,11 +613,9 @@ int lbs_process_event(struct lbs_private
 	eventcause = priv->eventcause >> SBI_EVENT_CAUSE_SHIFT;
 	spin_unlock_irq(&priv->driver_lock);
 
-	lbs_deb_cmd("event cause %d\n", eventcause);
-
 	switch (eventcause) {
 	case MACREG_INT_CODE_LINK_SENSED:
-		lbs_deb_cmd("EVENT: MACREG_INT_CODE_LINK_SENSED\n");
+		lbs_deb_cmd("EVENT: link sensed\n");
 		break;
 
 	case MACREG_INT_CODE_DEAUTHENTICATED:
@@ -636,7 +634,7 @@ int lbs_process_event(struct lbs_private
 		break;
 
 	case MACREG_INT_CODE_PS_SLEEP:
-		lbs_deb_cmd("EVENT: sleep\n");
+		lbs_deb_cmd("EVENT: ps sleep\n");
 
 		/* handle unexpected PS SLEEP event */
 		if (priv->psstate == PS_STATE_FULL_POWER) {
@@ -646,17 +644,17 @@ int lbs_process_event(struct lbs_private
 		}
 		priv->psstate = PS_STATE_PRE_SLEEP;
 
-		lbs_ps_confirm_sleep(priv, (u16) priv->psmode);
+		lbs_ps_confirm_sleep(priv);
 
 		break;
 
 	case MACREG_INT_CODE_HOST_AWAKE:
-		lbs_deb_cmd("EVENT: HOST_AWAKE\n");
+		lbs_deb_cmd("EVENT: host awake\n");
 		lbs_send_confirmwake(priv);
 		break;
 
 	case MACREG_INT_CODE_PS_AWAKE:
-		lbs_deb_cmd("EVENT: awake\n");
+		lbs_deb_cmd("EVENT: ps awake\n");
 		/* handle unexpected PS AWAKE event */
 		if (priv->psstate == PS_STATE_FULL_POWER) {
 			lbs_deb_cmd(
@@ -687,14 +685,16 @@ int lbs_process_event(struct lbs_private
 		lbs_deb_cmd("EVENT: MULTICAST MIC ERROR\n");
 		handle_mic_failureevent(priv, MACREG_INT_CODE_MIC_ERR_MULTICAST);
 		break;
+
 	case MACREG_INT_CODE_MIB_CHANGED:
+		lbs_deb_cmd("EVENT: MIB CHANGED\n");
+		break;
 	case MACREG_INT_CODE_INIT_DONE:
+		lbs_deb_cmd("EVENT: INIT DONE\n");
 		break;
-
 	case MACREG_INT_CODE_ADHOC_BCN_LOST:
 		lbs_deb_cmd("EVENT: ADHOC beacon lost\n");
 		break;
-
 	case MACREG_INT_CODE_RSSI_LOW:
 		lbs_pr_alert("EVENT: rssi low\n");
 		break;
