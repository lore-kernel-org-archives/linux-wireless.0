Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:52568 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYKKSeD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 13:34:03 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Subject: Re: throughput problem/bisect with rtl8187B
Date: Tue, 11 Nov 2008 16:34:14 -0200
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <992048.28671.qm@web23108.mail.ird.yahoo.com>
In-Reply-To: <992048.28671.qm@web23108.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811111634.14786.herton@mandriva.com.br> (sfid-20081111_193407_888648_CF33348A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 November 2008 14:48:52 Hin-Tak Leung wrote:
> --- On Tue, 11/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> 
> <snipped>
> > Lets try to identify what part is broken, I guess is this,
> > can you try this
> > patch on latest wireless-testing?
> 
> Tried it, no improvement. 
> 
> Can you /did you see any problem similiar to mine with throughput on your system(s)?

Nope, here I can scp a large file from another machine, rate stabilizes at 6M
with minstrel, transfer rate stays around 400-480KB/s, and drops/fluctuates
below 400KB/s usually (must be affected by other network traffic, I can't do
the test now on a clean environment).

Please check this patch to see if things improve, if not, can you check with
the patch I posted earlier, "Add conf_tx callback and use it to configure tx
queues of 8187L/8187B.", if things improve? (I think you already checked, but
just in case you tested only the rate control related patch)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index d49f2a7..a7860b0 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -908,44 +908,28 @@ static int rtl8187_config_interface(struct ieee80211_hw *dev,
 	return 0;
 }
 
-static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot,
-			     bool use_short_preamble)
+static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot)
 {
 	if (priv->is_rtl8187b) {
-		u8 difs, eifs, slot_time;
-		u16 ack_timeout;
+		u8 difs, slot_time;
 
-		if (use_short_slot) {
+		if (use_short_slot)
 			slot_time = 0x9;
-			difs = 0x1c;
-			eifs = 0x53;
-		} else {
+		else
 			slot_time = 0x14;
-			difs = 0x32;
-			eifs = 0x5b;
-		}
-		rtl818x_iowrite8(priv, &priv->map->SIFS, 0xa);
+		difs = 10 + 2 * slot_time;
+		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 		rtl818x_iowrite8(priv, &priv->map->SLOT, slot_time);
 		rtl818x_iowrite8(priv, &priv->map->DIFS, difs);
 
 		/*
-		 * BRSR+1 on 8187B is in fact EIFS register
-		 * Value in units of 4 us
+		 * On 8187B:
+		 * - BRSR+1 is in fact EIFS register
+		 * - CARRIER_SENSE_COUNTER is ack timeout register
+		 * Values in units of 4 us
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
+		rtl818x_iowrite8(priv, (u8 *)&priv->map->BRSR + 1, 0x5b);
+		rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER, 0x5b);
 	} else {
 		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 		if (use_short_slot) {
@@ -969,9 +953,8 @@ static void rtl8187_bss_info_changed(struct ieee80211_hw *dev,
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	if (changed & (BSS_CHANGED_ERP_SLOT | BSS_CHANGED_ERP_PREAMBLE))
-		rtl8187_conf_erp(priv, info->use_short_slot,
-				 info->use_short_preamble);
+	if (changed & BSS_CHANGED_ERP_SLOT)
+		rtl8187_conf_erp(priv, info->use_short_slot);
 }
 
 static void rtl8187_configure_filter(struct ieee80211_hw *dev,


>
> Hin-Tak

--
[]'s
Herton
