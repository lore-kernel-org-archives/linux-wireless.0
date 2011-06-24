Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab1FXWC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 18:02:29 -0400
Date: Fri, 24 Jun 2011 17:02:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: rtl8187se: Fix big-endian warning
Message-ID: <4e050973.T019j2fmhZvo/1Jn%Larry.Finger@lwfinger.net> (sfid-20110625_000249_251412_D445ADB7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When compiling the rtl8187se driver from staging on a big-endian
architecture, the following warning results:

  CC [M]  drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.o
drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c: In function 'ieee80211_probe_resp':
drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c:824: warning: value computed is not used

The warning is due to misuse of cpu_to_le16().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ wireless-testing-new/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -820,7 +820,7 @@ static struct sk_buff* ieee80211_probe_r
 		cpu_to_le16(ieee->current_network.capability & WLAN_CAPABILITY_IBSS);
 
 	if(ieee->short_slot && (ieee->current_network.capability & WLAN_CAPABILITY_SHORT_SLOT))
-		cpu_to_le16((beacon_buf->capability |= WLAN_CAPABILITY_SHORT_SLOT));
+		beacon_buf->capability |= cpu_to_le16(WLAN_CAPABILITY_SHORT_SLOT);
 
 	crypt = ieee->crypt[ieee->tx_keyidx];
 
