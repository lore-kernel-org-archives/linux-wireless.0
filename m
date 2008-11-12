Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23107.mail.ird.yahoo.com ([217.146.189.47]:29762 "HELO
	web23107.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751593AbYKLBMo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 20:12:44 -0500
Date: Wed, 12 Nov 2008 01:12:42 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: throughput problem/bisect with rtl8187B
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200811111634.14786.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <413196.94590.qm@web23107.mail.ird.yahoo.com> (sfid-20081112_021247_779722_728CF495)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 11/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> Please check this patch to see if things improve, if not,
> can you check with
> the patch I posted earlier, "Add conf_tx callback and
> use it to configure tx
> queues of 8187L/8187B.", if things improve? (I think
> you already checked, but
> just in case you tested only the rate control related
> patch)

okay, very good - this one does it. I didn't try the conf_tx callback patch when I posted the problem, but I did this time - so I have the
conf_tx callback patch, feedback patch, and a modified version of this new
one, and I get decent throughput; reverting the 3rd patch, (ie. just the conf_tx callback and feekback transmitted patch) and the throughput is appalling. So you can add tested-by me to both the conf_tx and feedback patches, and either tested-by or signed-off-by for this version of the 3rd patch (I made some small changes just so that it applies on top of the conf_tx patch which has a priv->slot_time rather than local slot_time).
Sorry about the indentation - no doubt you'll polish it up before sending off the three.

These 3 are tested against v2.6.28-rc4-5168-gaafbf3d (moved on a bit since my last tests).

Thanks for looking into this.

Hin-Tak

------------------------------
--- rtl8187_dev.c.orig	2008-11-11 23:49:09.000000000 +0000
+++ rtl8187_dev.c	2008-11-12 00:11:54.000000000 +0000
@@ -1050,45 +1050,29 @@
 
 #define SIFS_TIME 0xa
 
-static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot,
-			     bool use_short_preamble)
+static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot)
 {
 	if (priv->is_rtl8187b) {
-		u8 difs, eifs;
-		u16 ack_timeout;
+		u8 difs;
 		int queue;
 
-		if (use_short_slot) {
+		if (use_short_slot)
 			priv->slot_time = 0x9;
-			difs = 0x1c;
-			eifs = 0x53;
-		} else {
+		else
 			priv->slot_time = 0x14;
-			difs = 0x32;
-			eifs = 0x5b;
-		}
-		rtl818x_iowrite8(priv, &priv->map->SIFS, SIFS_TIME);
+  difs = 10 + 2 * priv->slot_time;
+		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 		rtl818x_iowrite8(priv, &priv->map->SLOT, priv->slot_time);
 		rtl818x_iowrite8(priv, &priv->map->DIFS, difs);
 
 		/*
-		 * BRSR+1 on 8187B is in fact EIFS register
-		 * Value in units of 4 us
+        * On 8187B:
+        * - BRSR+1 is in fact EIFS register
+        * - CARRIER_SENSE_COUNTER is ack timeout register
+        * Values in units of 4 us
 		 */
-		rtl818x_iowrite8(priv, (u8 *)&priv->map->BRSR + 1, eifs);
-
-		/*
-		 * For 8187B, CARRIER_SENSE_COUNTER is in fact ack timeout
-		 * register. In units of 4 us like eifs register
-		 * ack_timeout = ack duration + plcp + difs + preamble
-		 */
-		ack_timeout = 112 + 48 + difs;
-		if (use_short_preamble)
-			ack_timeout += 72;
-		else
-			ack_timeout += 144;
-		rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER,
-				 DIV_ROUND_UP(ack_timeout, 4));
+   rtl818x_iowrite8(priv, (u8 *)&priv->map->BRSR + 1, 0x5b);
+   rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER, 0x5b);
 
 		for (queue = 0; queue < 4; queue++)
 			rtl818x_iowrite8(priv, (u8 *) rtl8187b_ac_addr[queue],
@@ -1115,9 +1099,8 @@
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	if (changed & (BSS_CHANGED_ERP_SLOT | BSS_CHANGED_ERP_PREAMBLE))
-		rtl8187_conf_erp(priv, info->use_short_slot,
-				 info->use_short_preamble);
+    if (changed & BSS_CHANGED_ERP_SLOT)
+        rtl8187_conf_erp(priv, info->use_short_slot);
 }
 
 static void rtl8187_configure_filter(struct ieee80211_hw *dev,
------------------------






      
