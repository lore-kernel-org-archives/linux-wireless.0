Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44472 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636AbYBRLVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 06:21:40 -0500
Subject: Re: Kernel panic after insmodding rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Michael Wu <flamingice@sourmilk.net>, andreamrl@tiscali.it,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <47B8406E.8020105@hauke-m.de>
References: <47B71171.6040805@hauke-m.de>
	 (sfid-20080216_163902_820241_FD2C42FD) <1203243029.12783.25.camel@johannes.berg>
	 <47B8406E.8020105@hauke-m.de>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 12:21:30 +0100
Message-Id: <1203333690.12783.37.camel@johannes.berg> (sfid-20080218_112142_891550_1338A744)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> http://www.hauke-m.de/fileadmin/rtl-wifi/kernel-panic-2008-02-17.JPG
> 
> The error appears when starting the wireless network with "ifup wlan0".
> The insmodding works without any error.

Thanks, I think this patch will fix it.

johannes

--- everything.orig/drivers/net/wireless/rtl8187_dev.c	2008-02-18 12:19:40.070030491 +0100
+++ everything/drivers/net/wireless/rtl8187_dev.c	2008-02-18 12:20:44.290028429 +0100
@@ -176,12 +176,16 @@ static int rtl8187_tx(struct ieee80211_h
 
 	flags = skb->len;
 	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
-	flags |= control->rts_cts_rate->hw_value << 19;
+
+	BUG_ON(!control->tx_rate);
+
 	flags |= control->tx_rate->hw_value << 24;
 	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb->data))
 		flags |= RTL8187_TX_FLAG_MORE_FRAG;
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+		BUG_ON(!control->rts_cts_rate);
 		flags |= RTL8187_TX_FLAG_RTS;
+		flags |= control->rts_cts_rate->hw_value << 19;
 		rts_dur = ieee80211_rts_duration(dev, priv->vif,
 						 skb->len, control);
 	}


